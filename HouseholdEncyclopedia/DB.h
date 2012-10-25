//
//  DB.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DB : NSObject

+(sqlite3 *)openDB;
+(void)closeDB;

@end
