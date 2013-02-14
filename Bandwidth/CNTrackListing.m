//
//  CNTrackListing.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNTrackListing.h"
#import "CNArtist.h"
#import "CNSong.h"

@implementation CNTrackListing

@synthesize artist, song, thumbsedUp;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        self.artist = [[CNArtist alloc] initWithDictionary:dictionary];
        self.song = [[CNSong alloc] initWithDictionary:dictionary];
        self.thumbsedUp = NO;
    }
    return self;   
}

@end
