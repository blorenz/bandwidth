//
//  CNClient.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNClient.h"

#import "UIDevice+IdentifierAddition.h"

#import "CNLocation.h"
#import "CNGenre.h"

@implementation CNClient

@synthesize currentGenre, currentLocation, deviceIdentifier;

+(CNClient *)instance  
{
	static CNClient *instance;
	@synchronized(self) 
    {
		if(!instance) 
        {
			instance = [[CNClient alloc] init];
            instance.deviceIdentifier = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            instance.currentLocation = [defaults objectForKey:@"location"];
            
            
            instance.currentGenre = [defaults objectForKey:@"genre"];
		}
	}
	return instance;
}

-(void)setCurrentGenre:(CNGenre *)currentGenreValue
{
    currentGenre = currentGenreValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentGenreValue forKey:@"genre"];
}

-(void)setCurrentLocation:(CNLocation *)currentLocationValue
{
    currentLocation = currentLocationValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentLocationValue forKey:@"location"];
}

@end
