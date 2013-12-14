//
//  PostViewController.m
//  spARK
//
//  Created by Brenna on 12/10/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end


@implementation PostViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _privacySegmentedControl.hidden = YES;
    _viewableSegmentedControl.hidden = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
	_locationManager.delegate = self;
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[_locationManager startUpdatingLocation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)backgroundTouched
{
    if ([_titleField isFirstResponder])
    {
        [_titleField resignFirstResponder];
    }
    
    else if ([_messageField isFirstResponder])
    {
        [_messageField resignFirstResponder];
    }
}


- (IBAction)textFieldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
}


- (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


- (IBAction)submitButtonPressed:(id)sender
{
    NSString *baseURLString = @"http://csce.uark.edu/~mmmcclel/spark/createcontent.php?value1=";
    NSArray *userInfoArray = [[NSMutableArray alloc] initWithContentsOfFile:[self dataFilePath:(kLoginInfo)]];
    NSString *userID = [userInfoArray objectAtIndex:2];
    NSString *titleString = _titleField.text;
    NSString *messageString = _messageField.text;
    double userLatitude = _userLocation.coordinate.latitude;
    double userLongitude = _userLocation.coordinate.longitude;
    
    if (![titleString isEqualToString:@""])
    {
        titleString = [titleString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    
    if (![messageString isEqualToString:@""])
    {
        messageString = [messageString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    
    if (_typeSegmentedControl.selectedSegmentIndex == 0)
        baseURLString = [baseURLString stringByAppendingFormat:@"%@&value2=", kBulletin];
    else if (_typeSegmentedControl.selectedSegmentIndex == 1)
        baseURLString = [baseURLString stringByAppendingFormat:@"%@&value2=", kDiscussion];
    else if (_typeSegmentedControl.selectedSegmentIndex == 2)
        baseURLString = [baseURLString stringByAppendingFormat:@"%@&value2=", kGroup];
    
    
    baseURLString = [baseURLString stringByAppendingFormat:@"%@&value3=%@&value4=%@&value5=%@&value6=%f&value7=%f", userID, titleString, messageString, kPublic, userLatitude, userLongitude];
    
    //NSLog(@"Base URL: %@", baseURLString);
    
    NSURL *commentURL = [NSURL URLWithString:baseURLString];
    NSData *urlData = [NSData dataWithContentsOfURL:commentURL];
    
    if(urlData)
    {
        NSError *errorJSON = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
        NSLog(@"%@", json);
        NSString *successString = [[json objectForKey:@"createSuccess"] stringValue];
        NSLog(@"Success String: %@", successString);
        
        if ([successString isEqualToString:@"1"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (IBAction)typeSegmentedControllerValueChanged:(UISegmentedControl *)sender
{    
    if (sender.selectedSegmentIndex == 2)
    {
        _privacySegmentedControl.hidden = NO;
        _viewableSegmentedControl.hidden = NO;
    }
    
    else
    {
        _privacySegmentedControl.hidden = YES;
        _viewableSegmentedControl.hidden = YES;
    }
}


#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(_userLocation == nil)
    {
        self.userLocation = newLocation;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *) error
{
	NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Location"
                                                    message:errorType
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
	
	[alert show];
}


@end