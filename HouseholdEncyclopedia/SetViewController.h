//
//  SetViewController.h
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontViewController.h"

@interface SetViewController : UITableViewController<SetFontName,UINavigationControllerDelegate,UIImagePickerControllerDelegate> 
@property (retain, nonatomic) IBOutlet UILabel *font;
@property (retain, nonatomic) IBOutlet UILabel *fontSize;
@property (retain, nonatomic) IBOutlet UILabel *titleFontSize;
@property (retain, nonatomic) IBOutlet UIImageView *pickImage;
@property (retain, nonatomic) IBOutlet UILabel *ColorLabel;


@end
