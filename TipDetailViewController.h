//
//  TipDetailViewController.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipDetailViewController : UIViewController

@property(nonatomic,retain)NSString *content;  //显示的内容
@property (retain, nonatomic) IBOutlet UITextView *detailContent;
@property (retain, nonatomic) IBOutlet UIImageView *backImageView;
@property(retain,nonatomic)NSArray *tipArr; //上个页面的内容数组
@property(assign,nonatomic)int selectNum;  //选中数组的第几个

@end
