//
//  FontViewController.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetFontName <NSObject>

- (void)setFontName:(NSString *)name;

@end

@interface FontViewController : UITableViewController


@property(nonatomic,retain)NSMutableDictionary *fontDic;
@property(nonatomic,assign)id<SetFontName>delegate;  //代理用来显示选中的字体

@end
