//
//  Color.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setColor <NSObject>

- (void)setColor:(UIColor *)color;  

@end

@interface Color : UIView

@property(nonatomic,assign)id<setColor>delegate;  //设置代理 当在选择颜色的图片上滑动时让代理运行代理方法
@property(nonatomic,retain)UIImageView *imageView;
@end
