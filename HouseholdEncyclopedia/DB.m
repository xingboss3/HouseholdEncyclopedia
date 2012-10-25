//
//  DB.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DB.h"

@implementation DB

static sqlite3 *db = nil;;

+(sqlite3 *)openDB
{
    if (db) {
        
        return db;
    }
    
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"HouseholdEncyclopedia.sqlite"];
        
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:filePath] == NO) {
        
        NSError *err = nil;
        NSString *sqlitePath = [[NSBundle mainBundle]pathForResource:@"HouseholdEncyclopedia" ofType:@"sqlite"];
        
        if([fm copyItemAtPath:sqlitePath toPath:filePath error:&err] == NO)
        {
            NSLog(@"%@",[err localizedDescription]);
        }
    }
    
    sqlite3_open([filePath UTF8String], &db);
    
    return db;
}
+(void)closeDB
{
    if (db) {
        
        sqlite3_close(db);
        db = nil;
    }
}
@end
