//
//  CheckInViewController.h
//  spARK
//
//  Created by Brenna on 11/14/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SWRevealViewController.h"
#import "CommentViewController.h"
#import "NewsFeedObject.h"

#define kDiscussion @"Discussion"
#define kBulletin @"Bulletin"
#define kGroup @"Group"
#define kLoginInfo @"Login.plist"

@interface CheckInViewController : UIViewController
<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *discussionArray;
@property (nonatomic, strong) NSMutableArray *bulletinArray;

@end