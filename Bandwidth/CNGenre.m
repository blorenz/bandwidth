//
//  CNGenre.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNGenre.h"

@implementation CNGenre

@synthesize displayName;
@synthesize identifier;
@synthesize populated;
@synthesize featured;

-(id)initWithDisplayName:(NSString *)name
{
    self = [super init];
    if(self)
    {
        self.displayName = name;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        self.populated = FALSE;
        self.featured = FALSE;
        
        if([dictionary objectForKey:@"id"])
        {
            self.identifier = [dictionary objectForKey:@"id"];
        }
        
        if([dictionary objectForKey:@"display-name"])
        {
            self.displayName = [dictionary objectForKey:@"display-name"];
        }
        
        /*
        if([dictionary objectForKey:@"populated"])
        {
            NSString *populatedString = [dictionary objectForKey:@"populated"];
            if([[populatedString lowercaseString] isEqualToString:@"true"])
            {
                self.populated = TRUE;
            }
        }
        
        if([dictionary objectForKey:@"featured"])
        {
            NSString *featuredString = [dictionary objectForKey:@"featured"];
            if([[featuredString lowercaseString] isEqualToString:@"true"])
            {
                self.featured = TRUE;
            }
        }
        */
        
    }
    return self;
}

@end
