////
////  FolkDetailViewController.m
////  HouseholdEncyclopedia
////
////  Created by Ibokan on 12-9-25.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//#import "FolkDetailViewController.h"
//
//#define GETFONTNAME [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"font.txt"]
//#define GETFONTSIZE [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"fontsize.txt"]
//#define GETBACKGROUND [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"background.png"]
//
//@implementation FolkDetailViewController
//@synthesize backImageView;
//@synthesize detaiContent,content;
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}
//
//#pragma mark - View lifecycle
//
///*
//// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//}
//*/
//
//
//// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    backImageView.image = [UIImage imageNamed:@"11.jpg"];
//    //self.detailTitle.text = self.contentTitle;
//    self.detaiContent.backgroundColor = [UIColor clearColor];
//    self.detaiContent.text = self.content;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSString *fontName = [NSString stringWithContentsOfFile:GETFONTNAME encoding:NSUTF8StringEncoding error:nil];
//    int fontSize = [[NSString stringWithContentsOfFile:GETFONTSIZE encoding:NSUTF8StringEncoding error:nil]intValue];
//    self.detaiContent.font = [UIFont fontWithName:fontName size:fontSize];
//    
//    self.backImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:GETBACKGROUND]];
//    
//}
//
//- (IBAction)backTo:(id)sender //横扫的手势 回到上个界面
//{
//    NSLog(@"dsfsd");
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)viewDidUnload
//{
//    [self setDetaiContent:nil];
//    //[self setDetailTitle:nil];
//    [self setBackImageView:nil];
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (void)dealloc {
//    
//    //self.contentTitle = nil;
//    self.content = nil;
//    [detaiContent release];
//    //[detailTitle release];
//    [backImageView release];
//    [super dealloc];
//}
//@end
