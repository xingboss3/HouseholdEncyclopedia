//
//  FoodDetailViewController.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "FoodKnowledge.h"

#define DOCPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] //document的路径
#define GETFONTNAME [DOCPATH stringByAppendingPathComponent:@"font.txt"]  //存储字体的路径
#define GETFONTSIZE [DOCPATH stringByAppendingPathComponent:@"fontsize.txt"]  //存储内容字体大小的路径
#define GETTITLEFONTSIZE [DOCPATH stringByAppendingPathComponent:@"titlefontsize.txt"] //存储标题字体大小的路径
#define GETBACKGROUND [DOCPATH stringByAppendingPathComponent:@"background.png"]  //存储背景图片的路径
#define GETCOLOR [DOCPATH stringByAppendingPathComponent:@"color.txt"]  //存储颜色文件的路径

@implementation FoodDetailViewController
@synthesize backImageView;
@synthesize contentTextView;
@synthesize titleLabel;
@synthesize foodTitle,foodContent;
@synthesize foodArr;
@synthesize selectNum;
@synthesize keyDic;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.backImageView.image = [UIImage imageNamed:@"26.png"];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.foodTitle;
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.text = self.foodContent;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSFileManager *fm = [NSFileManager defaultManager];
   
    if ([fm fileExistsAtPath:GETFONTSIZE]) //判断存储内容字体大小的文件是否存在
    {
        int fontSize = [[NSString stringWithContentsOfFile:GETFONTSIZE encoding:NSUTF8StringEncoding error:nil]intValue];
        self.contentTextView.font = [UIFont fontWithName:@"Arial" size:fontSize];
    }
    
    if ([fm fileExistsAtPath:GETFONTNAME])  //判断存储内容字体的文件是否存在
    {
        
        NSString *fontName = [NSString stringWithContentsOfFile:GETFONTNAME encoding:NSUTF8StringEncoding error:nil];
        self.contentTextView.font = [UIFont fontWithName:fontName size:14];
    }
    
    if ([fm fileExistsAtPath:GETFONTSIZE] && [fm fileExistsAtPath:GETFONTNAME]) //判断存储内容字体大小和字体的文件是否同时存在
    {
        int fontSize = [[NSString stringWithContentsOfFile:GETFONTSIZE encoding:NSUTF8StringEncoding error:nil]intValue];
        NSString *fontName = [NSString stringWithContentsOfFile:GETFONTNAME encoding:NSUTF8StringEncoding error:nil];
        self.contentTextView.font = [UIFont fontWithName:fontName size:fontSize];
    }
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:GETTITLEFONTSIZE]) { //判断存储标题字体大小的文件是否存在
        
        NSString *titleFontName = [NSString stringWithContentsOfFile:GETTITLEFONTSIZE encoding:NSUTF8StringEncoding error:nil];
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:[titleFontName intValue]];
    }
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:GETBACKGROUND]) {   //判断存储背景图片的文件是否存在
        
        self.backImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:GETBACKGROUND]];

    }
        
    if ([[NSFileManager defaultManager]fileExistsAtPath:GETCOLOR]) {  //判断存储字体颜色的文件是否存在
        
        NSArray *colorArr = [NSArray arrayWithContentsOfFile:GETCOLOR];
        float alpha =  [[colorArr objectAtIndex:0]floatValue]; 
        float red = [[colorArr objectAtIndex:1]floatValue]; 
        float green = [[colorArr objectAtIndex:2]floatValue]; 
        float blue = [[colorArr objectAtIndex:3]floatValue];   
        self.contentTextView.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        self.titleLabel.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
        
        
}

- (IBAction)backTo:(id)sender  //横扫的手势 回到上个界面
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender  //下一页
{
    if (selectNum < [self.foodArr count]-1) {
        
        [UIView animateWithDuration:0.4 animations:^(void){
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            
            selectNum++;
            if ([[self.foodArr objectAtIndex:self.selectNum] isKindOfClass:[FoodKnowledge class]]) {
                
                FoodKnowledge *food = [self.foodArr objectAtIndex:self.selectNum];
                self.titleLabel.text = food.title;
                self.contentTextView.text = food.content;
                
            } else {
                
                if (self.keyDic == nil) {
                    
                    NSString *str = [self.foodArr objectAtIndex:selectNum];
                    self.titleLabel.text = [[[[str componentsSeparatedByString:@"#"]objectAtIndex:0]componentsSeparatedByString:@"("]objectAtIndex:0];
                    self.contentTextView.text = [[str componentsSeparatedByString:@"#"]objectAtIndex:1];
                    
                } else {
                    
                    NSString *key = [self.foodArr objectAtIndex:self.selectNum];
                    self.titleLabel.text = [[key componentsSeparatedByString:@"("]objectAtIndex:0];
                    NSString *str = [self.keyDic objectForKey:key];
                    self.contentTextView.text = str;
                    
                    
                }
                
                
            }
            
        }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已到最后一条" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}


- (IBAction)previous:(id)sender  //上一页
{

    NSLog(@"%@",[self.foodArr objectAtIndex:selectNum]);
    
    if(selectNum > 0){
        
        [UIView animateWithDuration:0.4 animations:^(void){
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
            selectNum--;
            
            if ([[self.foodArr objectAtIndex:self.selectNum] isKindOfClass:[FoodKnowledge class]]) {
                
                FoodKnowledge *food = [self.foodArr objectAtIndex:self.selectNum];
                self.titleLabel.text = food.title;
                self.contentTextView.text = food.content;
                
            } else {
                
                if (self.keyDic == nil) {
                    
                    NSString *str = [self.foodArr objectAtIndex:selectNum];
                    self.titleLabel.text = [[[[str componentsSeparatedByString:@"#"]objectAtIndex:0]componentsSeparatedByString:@"("]objectAtIndex:0];
                    self.contentTextView.text = [[str componentsSeparatedByString:@"#"]objectAtIndex:1];
                    
                } else {
                    
                    NSString *key = [self.foodArr objectAtIndex:self.selectNum];
                    self.titleLabel.text = [[key componentsSeparatedByString:@"("]objectAtIndex:0];
                    NSString *str = [self.keyDic objectForKey:key];
                    self.contentTextView.text = str;
                    
                    
                }                
            }
            
        
        }];
            
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已到第一条" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)dealloc 
{
    
    self.keyDic = nil;
    self.foodArr = nil;
    self.foodContent = nil;
    self.foodTitle = nil;
    [contentTextView release];
    [backImageView release];
    [titleLabel release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidUnload
{
    [self setContentTextView:nil];
    [self setBackImageView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
