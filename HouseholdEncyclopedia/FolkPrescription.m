
//
//  FolkPrescription.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FolkPrescription.h"
#import "FolkDetailViewController.h"
#import "FoodDetailViewController.h"

#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] //得到document文件夹的路径
#define FOLKISFIRSTLOADPATH [DOCUMENTPATH stringByAppendingPathComponent:@"folkIsFirstLoad.txt"]  //得到判断是否是第一次加载页面的值路径
#define FOLKDICPATH [DOCUMENTPATH stringByAppendingPathComponent:@"folkdic.txt"] //得到document文件夹下folk字典文件的路径
#define FOLKARRPATH [DOCUMENTPATH stringByAppendingPathComponent:@"folkarr.txt"] //得到document文件夹下folk数组文件的路径
#define TITLE(STR) [[STR componentsSeparatedByString:@"#"]objectAtIndex:0]  //得到＃号之前的字符串
#define CONTENT(STR) [[STR componentsSeparatedByString:@"#"]lastObject]  //得到＃号之后的字符串
#define GETKEY(SECTION) [[[self.folkDic allKeys]sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:SECTION] //得到相对应的key



@interface FolkPrescription()

-(void)loadData;
-(void)initSearchBar;
-(void)addNotification;

@end

@implementation FolkPrescription

@synthesize folkDic,filteredArr,folkArr,isFirstLoad,searchDC,searchBar,folkDicToFilter;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self loadData];    //加载数据
    [self initSearchBar];  //初始化搜索栏
    [self addNotification];  //添加程序回到后台的通知  当程序运行到后台时存储数据

}

#pragma mark 初始化方法

- (void)loadData   //加载数据
{
    self.isFirstLoad = @"YES";
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:FOLKISFIRSTLOADPATH]) {  //保存第一次运行的文件是否存在
        
       self.isFirstLoad = [NSString stringWithContentsOfFile:FOLKISFIRSTLOADPATH encoding:NSUTF8StringEncoding error:nil];
    }
    
    if ([self.isFirstLoad isEqualToString:@"YES"]) {  //判断是否是第一次运行
            
        self.folkDic = [[[NSMutableDictionary alloc]init]autorelease];
        self.folkArr = [[[NSMutableArray alloc]init]autorelease];
        
        NSArray *dataArr1 = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"五官科36" ofType:@"txt"]
                                                  encoding:NSUTF8StringEncoding error:nil]componentsSeparatedByString:@"\n"];
        
        NSArray *dataArr2 = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"儿科17" ofType:@"txt"]
                                                       encoding:NSUTF8StringEncoding error:nil]componentsSeparatedByString:@"\n"];

        NSArray *dataArr3 = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"内科37" ofType:@"txt"]
                                                        encoding:NSUTF8StringEncoding error:nil]componentsSeparatedByString:@"\n"];

        NSArray *dataArr4 = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"外科20" ofType:@"txt"]
                                                       encoding:NSUTF8StringEncoding error:nil]componentsSeparatedByString:@"\n"];
        
        NSArray *dataArr5 = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"皮肤科17" ofType:@"txt"]
                                                       encoding:NSUTF8StringEncoding error:nil]componentsSeparatedByString:@"\n"];
        
        [self.folkDic setObject:dataArr1 forKey:@"五官科"];
        [self.folkDic setObject:dataArr2 forKey:@"儿科"];
        [self.folkDic setObject:dataArr3 forKey:@"内科"];
        [self.folkDic setObject:dataArr4 forKey:@"外科"];
        [self.folkDic setObject:dataArr5 forKey:@"皮肤科"];
        
        [self.folkArr addObjectsFromArray:dataArr1];
        [self.folkArr addObjectsFromArray:dataArr2];
        [self.folkArr addObjectsFromArray:dataArr3];
        [self.folkArr addObjectsFromArray:dataArr4];
        [self.folkArr addObjectsFromArray:dataArr5];
        
        self.folkDicToFilter = [[[NSMutableDictionary alloc]init]autorelease];
        for(NSString *tempstr in self.folkArr) //把标题和相对应的内容放在字典里
        {
            [folkDicToFilter setObject:CONTENT(tempstr) forKey:TITLE(tempstr)];
        }
        
        self.isFirstLoad = @"NO";  
        [self.isFirstLoad writeToFile:FOLKISFIRSTLOADPATH atomically:YES encoding:NSUTF8StringEncoding error:nil]; //存入document文件夹
        
        
    } else {  
            
        self.folkDic = [NSMutableDictionary dictionaryWithContentsOfFile:FOLKDICPATH]; //取得数据
        self.folkArr = [NSMutableArray arrayWithContentsOfFile:FOLKARRPATH];
        self.folkDicToFilter = [[[NSMutableDictionary alloc]init]autorelease];
        for(NSString *tempstr in self.folkArr)  //把标题和相对应的内容放在字典里
        {
            [folkDicToFilter setObject:CONTENT(tempstr) forKey:TITLE(tempstr)];
        }
        NSLog(@"%@",DOCUMENTPATH);
        
        
    }
    
}

- (void)addNotification  //添加程序回到后台的通知
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storageFolk) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)initSearchBar   //初始化搜索栏
{
    //设置搜索栏
    self.searchBar = [[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
    self.searchBar.tintColor = [UIColor blackColor];
    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo]; //不自动首字母大写
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchDC = [[[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self]autorelease];
    self.searchDC.searchResultsDataSource = self; //设置代理
    self.searchDC.searchResultsDelegate = self;
}

- (void)storageFolk  //通知运行的方法 用于存储数据
{
    [self.folkDic writeToFile:FOLKDICPATH atomically:YES];  //把数据存入document文件夹
    [self.folkArr writeToFile:FOLKARRPATH atomically:YES];
}


#pragma mark DataSource方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  //设置section的个数
{
    if (tableView == self.tableView) {
        
        return [self.folkDic count];
        
    } else {
        
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  //设置row的行数
{
    if (tableView == self.tableView) {
        
        NSString *key = GETKEY(section);
        //NSString *key = [[[self.folkDic allKeys]sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:section];
        return [[self.folkDic objectForKey:key] count];
        
    } else {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains%@",self.searchBar.text];
        self.filteredArr = [[self.folkDicToFilter allKeys]filteredArrayUsingPredicate:predicate];
        return [self.filteredArr count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  //设置section的标题
{
    if (tableView == self.tableView) 
    {
        return GETKEY(section);
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath //设置cell的内容
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.lineBreakMode =  UILineBreakModeClip;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if(tableView == self.tableView){            //判断时自身的tableview还是SearchDisplayController的
        
        NSString *key = GETKEY(indexPath.section);          //得到key
        NSArray *tempArr = [self.folkDic objectForKey:key];   
        cell.textLabel.text = TITLE([tempArr objectAtIndex:indexPath.row]); 
        
    } else {
        
        cell.textLabel.text = [self.filteredArr objectAtIndex:indexPath.row];  
    }
    
    return cell;
}

#pragma mark Delegate方法

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  //设置高度
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  //当cell被选中时
{
    [self.searchBar resignFirstResponder]; //回收serchbar的键盘
    [self performSegueWithIdentifier:@"folkDetail" sender:tableView];
}

#pragma mark 当要推到下个界面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  //当要推到下个界面
{
    if ([segue.identifier isEqualToString:@"folkDetail"]) {
        
        if ([segue.destinationViewController isKindOfClass:[FoodDetailViewController class]]) { 
            
            FoodDetailViewController *detail = (FoodDetailViewController *)segue.destinationViewController;
            UITableView *tableView = (UITableView *)sender;
            
            
            if (tableView == self.tableView) { //传值给即将push的viewController
                
                NSIndexPath *indexPath = [tableView indexPathForSelectedRow];   //得到选中的indexPath
                NSString *key = GETKEY(indexPath.section);
                NSArray *tempArr = [self.folkDic objectForKey:key];
                
                detail.foodTitle = [[TITLE([tempArr objectAtIndex:indexPath.row])componentsSeparatedByString:@"("]objectAtIndex:0];
                detail.foodContent = CONTENT([tempArr objectAtIndex:indexPath.row]);
                detail.foodArr = self.folkArr;
                
                
                int selectNum = 0;
                
                if (indexPath.section > 0) {  //得到选中的cell的内容在总的偏方里的第几个
                    
                    for (int i = 0; i <= indexPath.section-1; i++) {
                        
                        NSString *key = [[[self.folkDic allKeys]sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:i];
                        NSArray *arr = [self.folkDic objectForKey:key];
                        selectNum = selectNum + [arr count];
                    }
                }
                
                selectNum = selectNum + indexPath.row;
                detail.selectNum = selectNum;  
                
            } else {
                
                NSIndexPath *indexPath = [tableView indexPathForSelectedRow];  //得到选中的indexPath
                NSString *title = [self.filteredArr objectAtIndex:indexPath.row];
                
                detail.foodTitle = [[title componentsSeparatedByString:@"("]objectAtIndex:0];
                detail.foodContent = [self.folkDicToFilter valueForKey:title];
                detail.keyDic = self.folkDicToFilter;  
                detail.foodArr = [[[self filteredArr]mutableCopy]autorelease];
                detail.selectNum = indexPath.row;
                
            }
            
        }
    }
}


- (void)dealloc 
{
    self.folkDic = nil;
    self.folkDicToFilter = nil;
    self.filteredArr = nil;
    self.isFirstLoad = nil;
    self.searchDC = nil;
    self.searchBar = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil]; //移出通知
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


@end
