//
//  NewsFeedObect.m
//  spARK
//
//  Created by Brenna on 11/7/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "NewsFeedObject.h"

@implementation NewsFeedObject


+ (NewsFeedObject *)newNewsFeedObjectWithID:(NSString *)identification withTitle:(NSString *)title withPostTime:(NSString *)timePosted withUser:(NSString *)username withUserID:(NSString *)userIdentification withMessage:(NSString *)message withUserImage:(NSString *)userImage withLatitude:(NSString *)latitude withLongitude:(NSString *)longitude withRating:(NSString *)rating withRatingFlag:(NSString *)ratingFlag withGroup:(NSString *)group
{
    NewsFeedObject *newsFeedObject = [[NewsFeedObject alloc]init];
    
    newsFeedObject.idString = identification;
    newsFeedObject.titleString = title;
    newsFeedObject.timePostedString = timePosted;
    newsFeedObject.usernameString = username;
    newsFeedObject.userID = userIdentification;
    newsFeedObject.messageString = message;
    newsFeedObject.userPicString = userImage;
    newsFeedObject.latitudeString = latitude;
    newsFeedObject.longitudeString = longitude;
    newsFeedObject.ratingString = rating;
    newsFeedObject.ratingFlagString = ratingFlag;
    newsFeedObject.group = group;
    
    return newsFeedObject;
}

@end