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
    
    self.mapView.showsUserLocation = YES;
    [_mapView setDelegate:self];
    //_mapView.mapType = MKMapTypeHybrid;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];

    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - MKMapViewDelegate methods.
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 1000, 1000);
    
    [mv setRegion:region animated:YES];
}


@end