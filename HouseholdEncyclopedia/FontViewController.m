//
//  FontViewController.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FontViewController.h"

#define GETFONTNAME [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"font.txt"]  //存储字体的路径
#define GETALLKEY [[self.fontDic allKeys]sortedArrayUsingSelector:@selector(compare:)]  //对字典的key进行排序


@interface FontViewController()

- (void)getFontDic;     //私有方法


@end

@implementation FontViewController

@synthesize fontDic,delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFontDic]; //取得字体的字典
}

- (void)getFontDic  //取得字体的字典
{
    self.fontDic = [[[NSMutableDictionary alloc]init]autorelease];
    
    for(NSString *family in [UIFont familyNames]) 
    {
        NSMutableArray *fontArr = [[NSMutableArray alloc]init];
        
        for(NSString *fontName in [UIFont fontNamesForFamilyName:family])
        {
            [fontArr addObject:fontName];
        }
        
        [self.fontDic setObject:fontArr forKey:family];
        
        [fontArr release];
    }

}



#pragma mark DataSource代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  //设置section的个数
{
    return [self.fontDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  //设置row的行数
{
    
    return [[self.fontDic objectForKey:[GETALLKEY objectAtIndex:section]]count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  //设置每个section的标题
{
    return [GETALLKEY objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath //设置cell显示的内容
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"font"];
    
    NSString *fontName = [[self.fontDic objectForKey:[GETALLKEY objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    cell.textLabel.text = fontName; 
    cell.textLabel.font = [UIFont fontWithName:fontName size:15];

    return cell;
}


#pragma mark  Delegate代理方法


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  //设置cell高度当
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath //当选中cell时
{
    NSString *fontName = [[self.fontDic objectForKey:[GETALLKEY objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row]; //得到选中的字体
    [fontName writeToFile:GETFONTNAME atomically:YES encoding:NSUTF8StringEncoding error:nil]; //把字体存到document文件
        
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setFontName:)]) {  //代理运行代理方法
        
        [self.delegate setFontName:fontName];  
    }
        
    [self.navigationController popViewControllerAnimated:YES];  //返回上个界面
}


- (void)dealloc {
    
    self.fontDic = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
