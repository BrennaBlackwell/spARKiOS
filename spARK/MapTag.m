//
//  MapTag.m
//  WeedPrototype
//
//  Copyright (c) 2012 University of Arkansas. All rights reserved.
//

#import "MapTag.h"

@implementation MapTag

@synthesize name;
@synthesize address;
@synthesize coordinate;

- (id)initWithName:(NSString*)_name address:(NSString*)_address coordinate:(CLLocationCoordinate2D)_coordinate
{
	if(self = [super init])
	{
		name = [_name copy];
		address = [_address copy];
		coordinate = _coordinate;
	}
	
	return self;
}

- (NSString *)title
{
	return name;
}

- (NSString *)subtitle
{
	return address;
}

@end