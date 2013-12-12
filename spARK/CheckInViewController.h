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
//#import "MapTag.h"

#define kGOOGLE_API_KEY @"API Google Key here"

@interface CheckInViewController : UIViewController
<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end