//
//  CNClient.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNClient.h"

#import "UIDevice+IdentifierAddition.h"
#import "ASIFormDataRequest.h"

#import "CNLocation.h"
#import "CNGenre.h"

@interface CNClient()

@property (nonatomic, retain) NSString *deviceIdentifier;
@property (nonatomic, retain) CNLocation *currentLocation;
@property (nonatomic, retain) CNGenre *currentGenre;

+(CNClient *)instance;

@end

@implementation CNClient

@synthesize currentGenre, currentLocation, deviceIdentifier;

#pragma mark - Public Methods

+(NSString *)deviceIdentifier
{
    return [[CNClient instance] deviceIdentifier];
}

+(CNLocation *)currentLocation
{
    return [[CNClient instance] currentLocation];    
}

+(CNGenre *)currentGenre
{
    return [[CNClient instance] currentGenre];
}

+(void)setCurrentGenre:(CNGenre *)genre
{
    [[CNClient instance] setCurrentGenre:genre];
}

+(void)setCurrentLocation:(CNLocation *)location
{
    [[CNClient instance] setCurrentLocation:location];    
}

#pragma mark - Private Methods

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
