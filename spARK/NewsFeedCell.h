//
//  NewsFeedCell.h
//  spARK
//
//  Created by Brenna on 11/4/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *userpicImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *eventLabel;
@property (nonatomic, strong) IBOutlet UILabel *timePostedLabel;
@property (nonatomic, strong) IBOutlet UILabel *rateLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;

@property (nonatomic, strong) IBOutlet UIButton *voteUpButton;
@property (nonatomic, strong) IBOutlet UIButton *voteDownButton;
@property (nonatomic, strong) IBOutlet UIButton *commentsButton;
@property (nonatomic, strong) IBOutlet UIButton *favoriteButton;
@property (nonatomic, strong) IBOutlet UIButton *trashButton;

@end