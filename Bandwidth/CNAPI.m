//
//  CNAPI.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNAPI.h"
#import "CNClient.h"
#import "CNTrackListing.h"
#import "CNLocation.h"
#import "CNGenre.h"

#import "ASIFormDataRequest.h"

@interface CNAPI()

-(NSString *)generateServerURL;

@end

@implementation CNAPI

@synthesize serverAddress, useSSL;

-(NSArray *)getLocations { return nil; }

-(NSArray *)getGenresForLocation:(CNLocation *)location { return nil; }

-(CNTrackListing *)getNextTrackListingForLocation:(CNLocation *)location withGenre:(CNGenre *)genre { return nil; }

-(NSString *)generateServerURL
{
    NSString *url = @"http://";
    if(useSSL){ url = @"https://"; }
    url = [url stringByAppendingFormat:@"%@", serverAddress];
    return url;
}

@end
