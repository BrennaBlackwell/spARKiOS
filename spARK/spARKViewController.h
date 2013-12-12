//
//  spARKViewController.h
//  spARK
//
//  Created by Brenna Blackwell on 10/24/13.
//  Copyright (c) 2013 brennablackwell.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "NewsFeedViewController.h"

#define kLoginInfo @"Login.plist"

@interface spARKViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *logInButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

- (IBAction)logInButtonPressed;

@end