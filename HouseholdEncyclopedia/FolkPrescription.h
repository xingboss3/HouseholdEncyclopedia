//
//  FolkPrescription.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolkPrescription : UITableViewController

@property(nonatomic,retain)NSMutableDictionary *folkDic,*folkDicToFilter; //偏方字典 一个用于搜索
@property(nonatomic,retain)NSMutableArray *folkArr; //所有偏方的数组
@property(nonatomic,retain)NSArray *filteredArr;  //搜索后的偏方数组
@property(nonatomic,retain)NSString *isFirstLoad; //偏方文件的路径  是否第一次加载
@property(nonatomic,retain)UISearchBar *searchBar;
@property(nonatomic,retain)UISearchDisplayController *searchDC;

@end
