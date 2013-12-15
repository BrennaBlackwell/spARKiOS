//
//  EditProfileViewController.h
//  spARK
//
//  Created by Brenna on 12/15/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoginInfo @"Login.plist"

@interface EditProfileViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UITextField *fullNameField;
@property (nonatomic, weak) IBOutlet UITextField *aboutField;

- (IBAction)backgroundTouched;
- (IBAction)textFieldReturn:(UITextField *)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end