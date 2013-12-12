//
//  MapTag.h
//  WeedPrototype
//
//  Copyright (c) 2012 University of Arkansas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapTag : NSObject <MKAnnotation>
{
	NSString *name;
    NSString *address;
	CLLocationCoordinate2D	coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D	coordinate;

- (id)initWithName:(NSString*)_name address:(NSString*)_address coordinate:(CLLocationCoordinate2D)_coordinate;

@end