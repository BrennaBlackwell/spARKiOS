//
//  ProfileViewController.h
//  spARK
//
//  Created by Brenna on 11/3/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "EditProfileViewController.h"

#define kLoginInfo @"Login.plist"

@interface ProfileViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fullnameLabel;
@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;

- (IBAction)editAccountButtonPressed:(id)sender;

@end