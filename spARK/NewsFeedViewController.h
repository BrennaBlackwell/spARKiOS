//
//  NewsFeedViewController.h
//  spARK
//
//  Created by Brenna on 11/3/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedObject.h"
#import "NewsFeedCell.h"
#import "SWRevealViewController.h"
#import "CommentViewController.h"
#import "PostNewContentViewController.h"

#define kLoginInfo @"Login.plist"
#define kDiscussion @"Discussion"
#define kBulletin @"Bulletin"
#define kGroup @"Group"

@interface NewsFeedViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *addContentButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *discussionArray;
@property (nonatomic, strong) NSMutableArray *bulletinArray;

- (IBAction)segmentedControllerValueChanged:(UISegmentedControl *)sender;
- (IBAction)commentButtonPressed:(id)sender;
- (IBAction)ratingUpButtonPressed:(id)sender;
- (IBAction)ratingDownButtonPressed:(id)sender;
- (IBAction)trashButtonPressed:(id)sender;
- (IBAction)postButtonPressed:(id)sender;

@end