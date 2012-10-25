//
//  FoodKnowledgeViewController.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FoodKnowledgeViewController.h"
#import "DB.h"
#import "FoodKnowledge.h"
#import <sqlite3.h>
#import "FoodDetailViewController.h"
#import <QuartzCore/QuartzCore.h>




@interface FoodKnowledgeViewController()

-(void)getData;

@end

@implementation FoodKnowledgeViewController

@synthesize foodKnowledgeArr;

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
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)dealloc {
    
    self.foodKnowledgeArr = nil;
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getData];   //从数据库中取得数据    

}


#pragma mark 初始化方法


-(void)getData   //从数据库中取得数据
{   
    sqlite3 *db = [DB openDB];    
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db,"select * from FoodKnowledge", -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        
        self.foodKnowledgeArr = [[[NSMutableArray alloc]init]autorelease];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int ID = sqlite3_column_int(stmt, 0);
            const unsigned char *title =sqlite3_column_text(stmt, 1);
            const unsigned char *content = sqlite3_column_text(stmt, 2);

            FoodKnowledge *food = [FoodKnowledge foodKnowledgeWithID:ID title:[NSString stringWithUTF8String:(const char *)title] content:[NSString stringWithUTF8String:(const char *)content]];
            [self.foodKnowledgeArr addObject:food];
            
        }
        
    }
    
    result = sqlite3_prepare_v2(db, "select * from Healthyrecipes", -1, &stmt, nil);
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int ID = sqlite3_column_int(stmt, 0);
            const unsigned char *title =sqlite3_column_text(stmt, 1);
            const unsigned char *content = sqlite3_column_text(stmt, 2);
            
            FoodKnowledge *food = [FoodKnowledge foodKnowledgeWithID:ID title:[NSString stringWithUTF8String:(const char *)title] content:[NSString stringWithUTF8String:(const char *)content]];
            [self.foodKnowledgeArr addObject:food];
            
        }
        
    }
    
    //NSLog(@"%d",[self.foodKnowledgeArr count]);
    sqlite3_finalize(stmt);
    [DB closeDB];
        
}

#pragma mark DataSource方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  //设置row的行数
{
    return [self.foodKnowledgeArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  //设置section的个数
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];    
    }
    
    FoodKnowledge *food = [self.foodKnowledgeArr objectAtIndex:indexPath.row];
    cell.textLabel.text = food.title;
    
    return cell;
}

#pragma mark Delegate方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  //当cell被选中时
{
    [self performSegueWithIdentifier:@"foodDetail" sender:nil];
}

#pragma mark 下个界面即将出现

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"foodDetail"]) {
        
        if ([segue.destinationViewController isKindOfClass:[FoodDetailViewController class]]) {
            
            FoodDetailViewController *detail = (FoodDetailViewController *)segue.destinationViewController;
            
            FoodKnowledge *food = [self.foodKnowledgeArr objectAtIndex:[self.tableView indexPathForSelectedRow].row];
            detail.foodTitle = food.title;
            detail.foodContent = food.content;
            detail.foodArr = foodKnowledgeArr;
            detail.selectNum = [self.tableView indexPathForSelectedRow].row;
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
