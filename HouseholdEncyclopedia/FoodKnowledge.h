//
//  FoodKnowledge.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodKnowledge : NSObject

@property(nonatomic,assign)int ID;
@property(nonatomic,retain)NSString *title,*content;

+ (id)foodKnowledgeWithID:(int)ID title:(NSString *)title content:(NSString *)content;

@end
