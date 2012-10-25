//
//  Tips.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tips.h"
#import "TipDetailViewController.h"

#define DOCPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] //得到document文件夹的路径
#define TIPISFIRSTLOADPATH [DOCPATH stringByAppendingPathComponent:@"tipIsFirstLoad.txt"]  //得到判断是否是第一次加载页面的值路径
#define TIPPATH [DOCPATH stringByAppendingPathComponent:@"tip.txt"] //得到document文件夹下tip文件的路径


@interface Tips() 

-(void)loadData;
-(void)initSearchBar;
-(void)addNotification;

@end

@implementation Tips

@synthesize tipArr,isFirstLoad,searchBar,searchDC,filteredArr,keyCollection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];    //加载数据
    [self initSearchBar];  //初始化搜索栏
    [self addNotification];  //添加程序回到后台的通知  当程序运行到后台时存储数据
    
}

#pragma mark 初始化方法


- (void)loadData  //加载数据
{
    self.isFirstLoad = @"YES";
    
    
    if([[NSFileManager defaultManager]fileExistsAtPath:TIPISFIRSTLOADPATH]) //判断是否存在存储第一次加载页面值的文件
    {
        self.isFirstLoad = [NSString stringWithContentsOfFile:TIPISFIRSTLOADPATH encoding:NSUTF8StringEncoding error:nil];
    }
    
    if ([self.isFirstLoad isEqualToString:@"YES"])  //如果第一次加载该试图
    { 
        
        NSString *tempTipPath = [[NSBundle mainBundle]pathForResource:@"生活窍门" ofType:@"txt"];
        NSString *tip = [NSString stringWithContentsOfFile:tempTipPath encoding:NSUTF8StringEncoding error:nil];
        self.tipArr = [[[tip componentsSeparatedByString:@"\n"]mutableCopy]autorelease];
    
        self.isFirstLoad = @"NO";
        [self.isFirstLoad writeToFile:TIPISFIRSTLOADPATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    } else {   //不是第一次加载该试图
        
        self.tipArr = [NSMutableArray arrayWithContentsOfFile:TIPPATH];
    }

}

- (void)initSearchBar //初始化搜索栏
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


- (void)addNotification  //添加程序回到后台的通知
{
    //添加当程序回到后台通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storageTip) name:  UIApplicationDidEnterBackgroundNotification object:nil];

}


- (void)storageTip  //通知运行的方法  把新的数组存入document文件
{
    [self.tipArr writeToFile:TIPPATH atomically:YES];
}


#pragma mark DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath //设置cell的高度
{
    return 50;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  //设置section的个数
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  //设置row的行数
{
    if (tableView == self.tableView) {  //判断是哪个tableview
        
        return [self.tipArr count];
        
    } else {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains%@",self.searchBar.text]; //谓词
        
        self.filteredArr = [self.tipArr filteredArrayUsingPredicate:predicate]; //搜索后的数组
        return [self.filteredArr count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath //设置cell的内容
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
        cell.textLabel.lineBreakMode = UILineBreakModeClip;
    }
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tip"];
    //UILabel *label = (UILabel *)[cell viewWithTag:100];
    //label.text = [self.keyCollection objectAtIndex:indexPath.row];
    self.keyCollection = (tableView == self.tableView) ? self.tipArr : self.filteredArr; //判断时哪个tableview
    cell.textLabel.text = [self.keyCollection objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark Delegate方法


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  //cell被选中
{
    [self.searchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"tipDetail" sender:tableView];
}

#pragma mark 将要推到下个界面

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tipDetail"]) {
        
        if([segue.destinationViewController isKindOfClass:[TipDetailViewController class]])
        {
            
            TipDetailViewController *detail = (TipDetailViewController *)segue.destinationViewController;
            detail.content = [self.keyCollection objectAtIndex:[(UITableView *)sender indexPathForSelectedRow].row];
            detail.tipArr = self.keyCollection; 
            detail.selectNum = [(UITableView *)sender indexPathForSelectedRow].row;
            //NSLog(@"%d %d",[detail.tipArr count],detail.selectNum);
            
        }
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil]; //移出通知
    self.tipArr = nil;
    self.isFirstLoad = nil;
    self.filteredArr = nil;
    self.keyCollection = nil;
    self.searchBar = nil;
    self.searchDC = nil;
    [super dealloc];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
