//
//  FoodDetailViewController.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontViewController.h"

@interface FoodDetailViewController : UIViewController

@property(nonatomic,retain)NSString *foodTitle,*foodContent;

@property (retain, nonatomic) IBOutlet UIImageView *backImageView;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property(retain,nonatomic)NSMutableArray *foodArr;  //内容的数组
@property(assign,nonatomic)int selectNum;  //上个界面选内容数组中的第几个
@property(retain,nonatomic)NSDictionary *keyDic;  //folk所有内容的字典


@end
