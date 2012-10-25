//
//  Tips.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tips : UITableViewController


@property(nonatomic,retain)NSMutableArray *tipArr; //窍门数组
@property(nonatomic,retain)NSArray *filteredArr,*keyCollection;  //filteredArr为搜索后的数组  keyCollection为用于cell显示的数组
@property(nonatomic,retain)NSString *isFirstLoad; //窍门文件的路径  是否第一次加载
@property(nonatomic,retain)UISearchBar *searchBar;
@property(nonatomic,retain)UISearchDisplayController *searchDC;

@end
