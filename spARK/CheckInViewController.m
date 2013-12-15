//
//  CheckInViewController.m
//  spARK
//
//  Created by Brenna on 11/14/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "CheckInViewController.h"

@interface CheckInViewController ()
{
    CLLocationManager *locationManager;
}

@end


@implementation CheckInViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [_mapView setDelegate:self];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];

    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _discussionArray = [[NSMutableArray alloc] init];
    _bulletinArray = [[NSMutableArray alloc] init];
    
    [self loadDataFromServer];
    [self addDiscussionsToMap];
    [self addBulletinsToMap];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)loadDataFromServer
{
    NSArray *logInArray = [[NSMutableArray alloc] initWithContentsOfFile:[self dataFilePath:(kLoginInfo)]];
    NSString *username = [logInArray objectAtIndex:0];
    
    NSString *discussionURLString = @"http://csce.uark.edu/~mmmcclel/spark/loadnewsfeed.php?value1=";
    discussionURLString = [discussionURLString stringByAppendingFormat:@"%@&value2=%@", username, kDiscussion];
    NSURL *discussionURL = [NSURL URLWithString:discussionURLString];
    NSData *discussionData = [NSData dataWithContentsOfURL:discussionURL];
    NSError *discussionError = nil;
    NSDictionary *discussionJSON = [NSJSONSerialization JSONObjectWithData:discussionData options:kNilOptions error:&discussionError];
    
    [_discussionArray removeAllObjects];
    [_bulletinArray removeAllObjects];
    
    NSArray *discussionArray = [discussionJSON objectForKey:@"contents"];
    for (int i = 0; i < [discussionArray count]; i++)
    {
        NSDictionary *discussion = [discussionArray objectAtIndex:i];
        
        [_discussionArray addObject:[NewsFeedObject
                                     newNewsFeedObjectWithID:[discussion objectForKey:@"id"]
                                     withTitle:[discussion objectForKey:@"title"]
                                     withPostTime:[discussion objectForKey:@"timestamp"]
                                     withUser:[discussion objectForKey:@"username"]
                                     withUserID:[discussion objectForKey:@"userid"]
                                     withMessage:[discussion objectForKey:@"body"]
                                     withUserImage:[discussion objectForKey:@""]
                                     withLatitude:[discussion objectForKey:@"latitude"]
                                     withLongitude:[discussion objectForKey:@"longitude"]
                                     withRating:[discussion objectForKey:@"rating_total"]
                                     withRatingFlag:[discussion objectForKey:@"user_rating"]]];
        
        NSArray *commentsArray = [discussion objectForKey:@"comments"];
        
        [[_discussionArray objectAtIndex:i] setComments:commentsArray];
        [[_discussionArray objectAtIndex:i] setNumberOfComments:[NSString stringWithFormat:@"%lu", (unsigned long)[commentsArray count]]];
    }
    
    NSString *bulletinURLString = @"http://csce.uark.edu/~mmmcclel/spark/loadnewsfeed.php?value1=";
    bulletinURLString = [discussionURLString stringByAppendingFormat:@"%@&value2=%@", username, kBulletin];
    NSURL *bulletinURL = [NSURL URLWithString:bulletinURLString];
    NSData *bulletinData = [NSData dataWithContentsOfURL:bulletinURL];
    NSError *bulletinError = nil;
    NSDictionary *bulletinJSON = [NSJSONSerialization JSONObjectWithData:bulletinData options:kNilOptions error:&bulletinError];
    
    NSArray *bulletinArray = [bulletinJSON objectForKey:@"contents"];
    
    for (int i = 0; i < [bulletinArray count]; i++)
    {
        NSDictionary *bulletin = [bulletinArray objectAtIndex:i];
        
        [_bulletinArray addObject:[NewsFeedObject
                                   newNewsFeedObjectWithID:[bulletin objectForKey:@"id"]
                                   withTitle:[bulletin objectForKey:@"title"]
                                   withPostTime:[bulletin objectForKey:@"timestamp"]
                                   withUser:[bulletin objectForKey:@"username"]
                                   withUserID:[bulletin objectForKey:@"userid"]
                                   withMessage:[bulletin objectForKey:@"body"]
                                   withUserImage:[bulletin objectForKey:@""]
                                   withLatitude:[bulletin objectForKey:@"latitude"]
                                   withLongitude:[bulletin objectForKey:@"longitude"]
                                   withRating:[bulletin objectForKey:@"rating_total"]
                                   withRatingFlag:[bulletin objectForKey:@"user_rating"]]];
    }
}


- (void)addDiscussionsToMap
{
    for (NewsFeedObject *object in _discussionArray)
    {
        double latitude = [object.latitudeString floatValue];
        double longitude = [object.longitudeString floatValue];
        NSString *title = object.titleString;
        CLLocationCoordinate2D coordinate;
        
        if ((latitude < 90.0) && (latitude > -90.0))
        {
            coordinate.latitude = latitude;
            coordinate.longitude = longitude;
        }
        
        else
        {
            coordinate.latitude = longitude;
            coordinate.longitude = latitude;
        }
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coordinate];
        [annotation setTitle:title];
        [annotation setSubtitle:@"View Comments"];
        
        [self.mapView addAnnotation:annotation];
    }

}


- (void)addBulletinsToMap
{
    for (NewsFeedObject *object in _bulletinArray)
    {
        double latitude = [object.latitudeString floatValue];
        double longitude = [object.longitudeString floatValue];
        NSString *title = object.titleString;
        CLLocationCoordinate2D coordinate;
        
        if ((latitude < 90.0) && (latitude > -90.0))
        {
            coordinate.latitude = latitude;
            coordinate.longitude = longitude;
        }
        
        else
        {
            coordinate.latitude = longitude;
            coordinate.longitude = latitude;
        }
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coordinate];
        [annotation setTitle:title];
        [annotation setSubtitle:@"Bulletin"];
        
        [self.mapView addAnnotation:annotation];
    }
}


- (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
    }
    
    else
    {
        pinView.annotation = annotation;
    }
    
    return pinView;
}


@end