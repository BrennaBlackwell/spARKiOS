//
//  NewsFeedObect.h
//  spARK
//
//  Created by Brenna on 11/7/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsFeedObject : NSObject

@property (nonatomic, strong) NSString *idString;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *eventString;
@property (nonatomic, strong) NSString *timePostedString;
@property (nonatomic, strong) NSString *usernameString;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *messageString;
@property (nonatomic, strong) NSString *userPicString;
@property (nonatomic, strong) NSString *latitudeString;
@property (nonatomic, strong) NSString *longitudeString;
@property (nonatomic, strong) NSString *ratingString;
@property (nonatomic, strong) NSString *ratingFlagString;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *numberOfComments;


+ (NewsFeedObject *)newNewsFeedObjectWithID:(NSString *)identification withTitle:(NSString *)title withPostTime:(NSString *)timePosted withUser:(NSString *)username withUserID:(NSString *)userIdentification withMessage:(NSString *)message withUserImage:(NSString *)userImage withLatitude:(NSString *)latitude withLongitude:(NSString *)longitude withRating:(NSString *)rating withRatingFlag:(NSString *)ratingFlag;

@end