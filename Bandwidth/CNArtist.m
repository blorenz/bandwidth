//
//  CNArtist.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNArtist.h"

@implementation CNArtist

@synthesize name;
@synthesize identifier;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        if([dictionary objectForKey:@"artist-id"])
        {
            self.identifier = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"artist-id"]];
        }
        
        if([dictionary objectForKey:@"artist-name"])
        {
            self.name = [dictionary objectForKey:@"artist-name"];
        }
        
    }
    return self;
}
    

@end
