//
//  CNAPI.h
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNLocation;
@class CNGenre;
@class CNTrackListing;

@interface CNAPI : NSObject

@property (nonatomic, retain) NSString *serverAddress;
@property (nonatomic, assign) BOOL useSSL;

-(NSArray *)getLocations;
-(NSArray *)getGenresForLocation:(CNLocation *)location;
-(CNTrackListing *)getNextTrackListingForLocation:(CNLocation *)location withGenre:(CNGenre *)genre;


@end
