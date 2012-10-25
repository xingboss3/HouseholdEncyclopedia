//
//  ColorViewController.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ColorViewController.h"
#define GETCOLOR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"color.txt"]  //存储颜色文件的路径

@implementation ColorViewController
@synthesize selectColor;



- (void)viewDidLoad
{
    [super viewDidLoad];
    Color *color = [[Color alloc]initWithFrame:CGRectMake(0, 60, 198, 155)];  //新建Color类 用来选择颜色
    color.center = CGPointMake(160, 100);
    color.delegate = self;  //设置代理
    [self.view addSubview:color];
    [color release];
    
}

- (void)viewWillAppear:(BOOL)animated  
{
    [super viewWillAppear:animated];
    if ([[NSFileManager defaultManager]fileExistsAtPath:GETCOLOR]) {  //判断存储颜色的文件是否存在
        
        NSArray *colorArr = [NSArray arrayWithContentsOfFile:GETCOLOR];  //取得颜色
        float alpha =  [[colorArr objectAtIndex:0]floatValue]; 
        float red = [[colorArr objectAtIndex:1]floatValue]; 
        float green = [[colorArr objectAtIndex:2]floatValue]; 
        float blue = [[colorArr objectAtIndex:3]floatValue]; 
        selectColor.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }

}


#pragma mark 代理和手势

- (void)setColor:(UIColor *)color  //实现代理方法  用来显示选中的颜色
{
    self.selectColor.backgroundColor = color;
    
}

- (IBAction)back:(id)sender //当屏幕手指在屏幕上向右滑动时 返回上个页面
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [self setSelectColor:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [selectColor release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */
@end
