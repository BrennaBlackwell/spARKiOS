//
//  PostViewController.h
//  spARK
//
//  Created by Brenna on 12/10/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kDiscussion @"Discussion"
#define kBulletin @"Bulletin"
#define kGroup @"Group"
#define kPublic @"1"
#define kLoginInfo @"Login.plist"

@interface PostViewController : UIViewController
<CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *titleField;
@property (nonatomic, weak) IBOutlet UITextField *messageField;
@property (nonatomic, weak) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *privacySegmentedControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *viewableSegmentedControl;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;

- (IBAction)backgroundTouched;
- (IBAction)textFieldReturn:(UITextField *)sender;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)typeSegmentedControllerValueChanged:(UISegmentedControl *)sender;

@end