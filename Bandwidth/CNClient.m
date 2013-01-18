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
#import "JSONKit.h"

#import "CNAPI.h"

@interface CNClient()

@property (nonatomic, retain) NSString *deviceIdentifier;
@property (nonatomic, retain) CNLocation *currentLocation;
@property (nonatomic, retain) CNGenre *currentGenre;
@property (nonatomic, retain) CLLocation *deviceLocation;
@property (nonatomic, retain) CNTrackListing *currentTrack;
@property (nonatomic, retain) CNTrackListing *previousTrack;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, copy) CNClientLocationUpdated updatedBlock;

+(CNClient *)instance;

-(void)startLocationManager;

@end

@implementation CNClient

@synthesize currentGenre, currentLocation, currentTrack, deviceIdentifier, deviceLocation, locationManager, updatedBlock, previousTrack;

#pragma mark - Public Methods

#pragma mark - Public Properties

+(CLLocation *)deviceLocation
{
    return [[CNClient instance] deviceLocation];
}

+(NSString *)deviceIdentifier
{
    return [[CNClient instance] deviceIdentifier];
}


+(CNGenre *)currentGenre
{
    return [[CNClient instance] currentGenre];
}

+(void)setCurrentGenre:(CNGenre *)genre
{
    [[CNClient instance] setCurrentGenre:genre];
}


+(CNLocation *)currentLocation
{
    return [[CNClient instance] currentLocation];    
}

+(void)setCurrentLocation:(CNLocation *)location
{
    [[CNClient instance] setCurrentLocation:location];   
}

+(CNTrackListing *)currentTrack
{
    return [[CNClient instance] currentTrack];
}

+(void)setCurrentTrack:(CNTrackListing *)track
{
    if([[CNClient instance] currentTrack])
    {
        [CNClient setPreviousTrack:[[CNClient instance] currentTrack]]; 
    }
    [[CNClient instance] setCurrentTrack:track];
}

+(CNTrackListing *)previousTrack
{
    return [[CNClient instance] previousTrack];
}

+(void)setPreviousTrack:(CNTrackListing *)track
{
    [[CNClient instance] setPreviousTrack:track];
}

#pragma mark - CoreLocation LocationManager Delegate

-(void)startLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self; 
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; 
    locationManager.distanceFilter = kCLDistanceFilterNone; 
    [locationManager startUpdatingLocation];
}

+(void)startLocationServices:(CNClientLocationUpdated)updatedBlock
{
    [[CNClient instance] setUpdatedBlock:updatedBlock];
    [[CNClient instance] startLocationManager];
}    

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self setDeviceLocation:newLocation];
    
    // /*DEBUG*/ CLLocationCoordinate2D coordinate = [newLocation coordinate];
    // /*DEBUG*/ float longitude=coordinate.longitude;
    // /*DEBUG*/ float latitude=coordinate.latitude;
    // /*DEBUG*/ NSLog(@"locationManagerUpdate: dLongitude : %f",longitude);
    // /*DEBUG*/ NSLog(@"locationManagerUpdate: dLatitude : %f", latitude); 
    
    [locationManager stopUpdatingLocation];
    
    CNClientLocationUpdated updateBlock = [[CNClient instance] updatedBlock];
    
    updateBlock(newLocation);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    CNClientLocationUpdated updateBlock = [[CNClient instance] updatedBlock];
    
    updateBlock(nil);
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
            
            CNLocation *location = [[CNLocation alloc] init];
            if([defaults objectForKey:@"location-id"])
            {
                location.locationId = [defaults objectForKey:@"location-id"];
            }else{
                location.locationId = @"1";
            }
            if([defaults objectForKey:@"location-name"])
            {
                location.locationDisplayName = [defaults objectForKey:@"location-name"];
            }else{
                location.locationDisplayName = @"Columbus";
            }
            instance.currentLocation = location;
            
            
            CNGenre *genre = [[CNGenre alloc] init];
            /*if([defaults objectForKey:@"genre-name"])
            {
                genre.displayName = [defaults objectForKey:@"genre-name"];
            }
            if([defaults objectForKey:@"genre-identifier"])
            {
                genre.identifier = [defaults objectForKey:@"genre-identifier"];
            }*/
            instance.currentGenre = genre;
		}
	}
	return instance;
}

-(void)setCurrentGenre:(CNGenre *)currentGenreValue
{
    currentGenre = currentGenreValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[currentGenreValue displayName] forKey:@"genre-name"];
    [defaults setObject:[currentGenreValue identifier] forKey:@"genre-identifier"];
}

-(void)setCurrentLocation:(CNLocation *)currentLocationValue
{
    currentLocation = currentLocationValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[currentLocationValue locationId] forKey:@"location-id"];
    [defaults setObject:[currentLocationValue locationDisplayName] forKey:@"location-name"];
}

@end
