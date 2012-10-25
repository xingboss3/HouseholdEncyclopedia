//
//  SetViewController.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SetViewController.h"

#define DOCPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] //document的路径
#define GETFONTNAME [DOCPATH stringByAppendingPathComponent:@"font.txt"]  //存储字体的路径
#define GETFONTSIZE [DOCPATH stringByAppendingPathComponent:@"fontsize.txt"]  //存储内容字体大小的路径
#define GETTITLEFONTSIZE [DOCPATH stringByAppendingPathComponent:@"titlefontsize.txt"] //存储标题字体大小的路径
#define GETBACKGROUND [DOCPATH stringByAppendingPathComponent:@"background.png"]  //存储背景图片的路径
#define GETCOLOR [DOCPATH stringByAppendingPathComponent:@"color.txt"]  //存储颜色文件的路径


@implementation SetViewController

@synthesize font;
@synthesize fontSize;
@synthesize titleFontSize;
@synthesize pickImage;
@synthesize ColorLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setFont:nil];
    [self setFontSize:nil];
    [self setTitleFontSize:nil];
    [self setPickImage:nil];
    [self setColorLabel:nil];
    [super viewDidUnload];

}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:GETFONTSIZE]) //判断存储内容字体大小的文件是否存在
    {
        NSString *tempFontSize = [NSString stringWithContentsOfFile:GETFONTSIZE encoding:NSUTF8StringEncoding error:nil];
        fontSize.text = tempFontSize;
        fontSize.font = [UIFont fontWithName:@"Arial" size:[tempFontSize intValue]];
    }
    
    if ([fm fileExistsAtPath:GETTITLEFONTSIZE]) //判断存储标题字体大小的文件是否存在
    {
        
        NSString *tempTitleFontSize = [NSString stringWithContentsOfFile:GETTITLEFONTSIZE encoding:NSUTF8StringEncoding error:nil];
        titleFontSize.text = tempTitleFontSize;
        titleFontSize.font = [UIFont fontWithName:@"Arial" size:[tempTitleFontSize intValue]];
    }
    
    if ([fm fileExistsAtPath:GETCOLOR]) //判断存储颜色的文件是否存在
    {          
        NSArray *colorArr = [NSArray arrayWithContentsOfFile:GETCOLOR];
        float alpha =  [[colorArr objectAtIndex:0]floatValue]; 
        float red = [[colorArr objectAtIndex:1]floatValue]; 
        float green = [[colorArr objectAtIndex:2]floatValue]; 
        float blue = [[colorArr objectAtIndex:3]floatValue];  
        ColorLabel.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    
    if ([fm fileExistsAtPath:GETFONTNAME])  //判断存储字体的文件是否存在
    {
        font.text = [NSString stringWithContentsOfFile:GETFONTNAME encoding:NSUTF8StringEncoding error:nil];        
    }
    
    if ([fm fileExistsAtPath:GETBACKGROUND]) //判断存储背景图片的文件是否存在
    {
        
        pickImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:GETBACKGROUND]];

    }
    
}


#pragma mark 设置字体大小

- (IBAction)setTitleFontSizeSmaller:(id)sender //标题字体变小
{
    
    int size = [titleFontSize.text intValue];
    size--;
    NSString *tempFontSize = [NSString stringWithFormat:@"%d",size];
    titleFontSize.text = tempFontSize;
    titleFontSize.font = [UIFont fontWithName:@"Arial" size:[tempFontSize intValue]];
    [tempFontSize writeToFile:GETTITLEFONTSIZE atomically:YES encoding:NSUTF8StringEncoding error:nil]; //存储
}

- (IBAction)setTitleFontSizeBigger:(id)sender //标题字体变大
{

    int size = [titleFontSize.text intValue];
    size++;
    NSString *tempFontSize = [NSString stringWithFormat:@"%d",size];
    titleFontSize.text = tempFontSize;
    titleFontSize.font = [UIFont fontWithName:@"Arial" size:[tempFontSize intValue]];
    [tempFontSize writeToFile:GETTITLEFONTSIZE atomically:YES encoding:NSUTF8StringEncoding error:nil]; //存储
}

- (IBAction)setFontSizeSmaller:(id)sender   //设置内容字体变小
{
    int size = [fontSize.text intValue];
    size--;
    NSString *tempFontSize = [NSString stringWithFormat:@"%d",size];
    fontSize.text = tempFontSize;
    fontSize.font = [UIFont fontWithName:@"Arial" size:[tempFontSize intValue]];
    [tempFontSize writeToFile:GETFONTSIZE atomically:YES encoding:NSUTF8StringEncoding error:nil];  //存储
}

- (IBAction)setFontSizeBigger:(id)sender  //设置内容字体变大
{

    int size = [fontSize.text intValue];
    size++;
    NSString *tempFontSize = [NSString stringWithFormat:@"%d",size];
    fontSize.text = tempFontSize;
    fontSize.font = [UIFont fontWithName:@"Arial" size:[tempFontSize intValue]];
    [tempFontSize writeToFile:GETFONTSIZE atomically:YES encoding:NSUTF8StringEncoding error:nil]; //存储
}

#pragma mark 代理方法

- (void)setFontName:(NSString *)name
{

    self.font.font = [UIFont fontWithName:name size:15];
    self.font.text = name;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info //当选择图片完成后
{
    [picker dismissModalViewControllerAnimated:YES];
    //NSLog(@"%@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.pickImage.image = image;
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:GETBACKGROUND atomically:YES];  //存储
}

#pragma mark DataSource代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  //设置section的个数
{
    
    return 2;
}

#pragma mark Delegate代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && indexPath.row == 0) {  //当选中选择这图片的cell时
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    
}

#pragma mark 将要推到下个界面


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"setFont"]) {
        
        if ([segue.destinationViewController isKindOfClass:[FontViewController class]]) {  
            
            FontViewController *fontView = (FontViewController *)segue.destinationViewController;
            fontView.delegate = self;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    
    [font release];
    [fontSize release];
    [titleFontSize release];
    [pickImage release];
    [ColorLabel release];
    [super dealloc];
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
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    
    // Release any cached data, images, etc that aren't in use.
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
