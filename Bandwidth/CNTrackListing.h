//
//  CNTrackListing.h
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNArtist;
@class CNSong;

@interface CNTrackListing : NSObject

@property (nonatomic, retain) CNArtist *artist;
@property (nonatomic, retain) CNSong *song;
@property (nonatomic) BOOL thumbsedUp;
@property (nonatomic) BOOL submittedPlayed;


-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
