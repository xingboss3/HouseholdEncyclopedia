//
//  FoodKnowledge.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FoodKnowledge.h"

@implementation FoodKnowledge

@synthesize ID,title,content;

+ (id)foodKnowledgeWithID:(int)ID title:(NSString *)title content:(NSString *)content
{
    FoodKnowledge *fook = [[FoodKnowledge alloc]init];
    
    if (fook != nil) {
        
        fook.ID = ID;
        fook.title = title;
        fook.content = content;
    }
    
    return [fook autorelease];
}

- (void)dealloc {
    
    self.title = nil;
    self.content = nil;
    [super dealloc];

}
@end
