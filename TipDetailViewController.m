//
//  TipDetailViewController.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TipDetailViewController.h"

#define DOCPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] //document的路径
#define GETFONTNAME [DOCPATH stringByAppendingPathComponent:@"font.txt"]  //存储字体的路径
#define GETFONTSIZE [DOCPATH stringByAppendingPathComponent:@"fontsize.txt"]  //存储内容字体大小的路径
#define GETBACKGROUND [DOCPATH stringByAppendingPathComponent:@"background.png"]  //存储背景图片的路径
#define GETCOLOR [DOCPATH stringByAppendingPathComponent:@"color.txt"]  //存储颜色文件的路径


@implementation TipDetailViewController
@synthesize backImageView;
@synthesize content,detailContent;
@synthesize tipArr;
@synthesize selectNum;


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    backImageView.image = [UIImage imageNamed:@"26.png"];
    self.detailContent.backgroundColor = [UIColor clearColor];
    self.detailContent.text = [self.detailContent.text stringByAppendingFormat:self.content];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:GETFONTSIZE]) //判断存储内容字体大小的文件是否存在
    {
        int fontSize = [[NSString stringWithContentsOfFile:GETFONTSIZE encoding:NSUTF8StringEncoding error:nil]intValue];
        self.detailContent.font = [UIFont fontWithName:@"Arial" size:fontSize];
    }
        
    if ([fm fileExistsAtPath:GETFONTNAME])  //判断存储内容字体的文件是否存在
    {
        
        NSString *fontName = [NSString stringWithContentsOfFile:GETFONTNAME encoding:NSUTF8StringEncoding error:nil];
        self.detailContent.font = [UIFont fontWithName:fontName size:14];
    }
    
    if ([fm fileExistsAtPath:GETFONTSIZE] && [fm fileExistsAtPath:GETFONTNAME]) //判断存储内容字体大小和字体的文件是否同时存在
    {
        int fontSize = [[NSString stringWithContentsOfFile:GETFONTSIZE encoding:NSUTF8StringEncoding error:nil]intValue];
        NSString *fontName = [NSString stringWithContentsOfFile:GETFONTNAME encoding:NSUTF8StringEncoding error:nil];
        self.detailContent.font = [UIFont fontWithName:fontName size:fontSize];
    }
    
    if ([fm fileExistsAtPath:GETBACKGROUND])   //判断存储背景图片的文件是否存在
    {     
        self.backImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:GETBACKGROUND]];
    }
        
    if ([fm fileExistsAtPath:GETCOLOR]) {  //判断存储字体颜色的文件是否存在
        
        NSArray *colorArr = [NSArray arrayWithContentsOfFile:GETCOLOR];
        float alpha =  [[colorArr objectAtIndex:0]floatValue]; 
        float red = [[colorArr objectAtIndex:1]floatValue]; 
        float green = [[colorArr objectAtIndex:2]floatValue]; 
        float blue = [[colorArr objectAtIndex:3]floatValue]; 
        self.detailContent.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
        
}

- (IBAction)backTo:(id)sender //横扫的手势 回到上个界面
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)previous:(id)sender //上一页
{
    if (selectNum > 0) {
        
        selectNum--;
        
        [UIView animateWithDuration:0.5 animations:^(void){
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
            self.detailContent.text = [self.tipArr objectAtIndex:selectNum];
            
        }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已到第一条" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
}

- (IBAction)next:(id)sender   //下一页
{

    if (selectNum < [self.tipArr count]-1) {
        
        selectNum++;
        [UIView animateWithDuration:0.5 animations:^(void){
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            self.detailContent.text = [self.tipArr objectAtIndex:selectNum];
            
        }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已到最后一条" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
}


- (void)viewDidUnload
{    
    [self setDetailContent:nil];
    [self setBackImageView:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{    
    self.tipArr = nil;
    self.content = nil;
    [detailContent release];
    [backImageView release];
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

@end
