//
//  CNClient.h
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class CNLocation;
@class CNGenre;
@class CNTrackListing;

typedef void (^CNClientLocationUpdated)(CLLocation *location);

@interface CNClient : NSObject <CLLocationManagerDelegate>


// Public Properties

+(NSString *)deviceIdentifier;
+(CLLocation *)deviceLocation;

+(CNGenre *)currentGenre;
+(void)setCurrentGenre:(CNGenre *)genre;

+(CNLocation *)currentLocation;
+(void)setCurrentLocation:(CNLocation *)location;

+(CNTrackListing *)currentTrack;
+(void)setCurrentTrack:(CNTrackListing *)track;

+(CNTrackListing *)previousTrack;
+(void)setPreviousTrack:(CNTrackListing *)track;

// Methods

+(void)startLocationServices:(CNClientLocationUpdated)updatedBlock;

@end
