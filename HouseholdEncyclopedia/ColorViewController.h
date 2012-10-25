//
//  ColorViewController.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Color.h"




@interface ColorViewController : UIViewController<setColor> 

@property (retain, nonatomic) IBOutlet UIView *selectColor;  //用来显示选中的颜色

@end
