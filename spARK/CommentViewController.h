//
//  CommentViewController.h
//  spARK
//
//  Created by Brenna on 12/9/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SWRevealViewController.h"
#import "NewsFeedCell.h"
#import "NewsFeedObject.h"

#define kLoginInfo @"Login.plist"

@interface CommentViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *eventLabel;
@property (nonatomic, strong) IBOutlet UILabel *timePostedLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;
@property (nonatomic, strong) IBOutlet UITextField *submitCommentTextField;
@property (nonatomic, strong) NewsFeedObject *originalDiscussion;
@property (nonatomic, strong) NSMutableArray *commentsArray;

- (IBAction)backgroundTouched;
- (IBAction)textFieldReturn:(UITextField *)sender;
- (IBAction)submitButtonPressed:(id)sender;

@end