//
//  CNSong.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNSong.h"

#import "CNAPI.h"

@implementation CNSong

@synthesize name;
@synthesize identifier;
@synthesize url;
@synthesize albumName;
@synthesize artworkUrl;
@synthesize rating;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        if([dictionary objectForKey:@"song-id"])
        {
            self.identifier = [dictionary objectForKey:@"song-id"];
        }
        
        if([dictionary objectForKey:@"song-name"])
        {
            self.name = [dictionary objectForKey:@"song-name"];
        }
        
        if([dictionary objectForKey:@"song-url"])
        {
            NSString *urlString = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"song-url"]];
            self.url = [NSURL URLWithString:urlString];
        }
    
        if([dictionary objectForKey:@"album-name"])
        {
            self.albumName = [dictionary objectForKey:@"album-name"];
        }
    
        if([dictionary objectForKey:@"artwork-url"])
        {
            NSString *artworkUrlString = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"artwork-url"]];
            self.artworkUrl = [NSURL URLWithString:artworkUrlString];
        }    
    
    
        if([dictionary objectForKey:@"rating"])
        {
            self.rating = [[dictionary objectForKey:@"rating"] floatValue];
        }        
    }
    return self;
}

-(NSString *)crowdImage
{
    float percent = rating / 5;
    double rounded = round(6 * percent);
    int index = (int)rounded;
    if(index == 0){ index = 1; }
    return [NSString stringWithFormat:@"crowd_%i.png", index];
}

@end
