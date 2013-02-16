//
//  CNAPI.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.

//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNAPI.h"

#import "JSONKit.h"
#import "ASIFormDataRequest.h"

@interface CNAPI()

@end

@implementation CNAPI

@synthesize serverAddress, useSSL, hasNowPlaying;




-(id)init
{
    if((self = [super init]))
    {
    }
    return self;
}

+(CNAPI *)instance  
{
	static CNAPI *instance;
	@synchronized(self) 
    {
		if(!instance) 
        {
			instance = [[CNAPI alloc] init];
            [instance setUseSSL:FALSE];
            [instance setHasNowPlaying:FALSE];
            
            endpoints = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"value1", @"key1", @"value2", @"key2", nil];
		}
	}
	return instance;
}

+(void)submitRequest:(CNRequestType)requestType 
            withData:(NSDictionary *)postVariables 
           onSuccess:(CNRequestSuccessful)success 
           onFailure:(CNRequestFailed)failed
{
    
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://google.com"]];
    __weak ASIFormDataRequest *request = _request;
    
    
    NSString *userAgentString = [NSString stringWithFormat:@"cannon.fm iOS Client %@ Build: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    [ASIFormDataRequest setDefaultUserAgentString:userAgentString];
    
    
    //NSString *serviceLocation = @"http://fewdalism.com:9040";
    NSString *serviceLocation = @"http://cannon.fm";
    
    
    [[CNAPI instance] setServerAddress:serviceLocation];
    
    switch(requestType)
    {
        case CNRequestTypeLocations:
            serviceLocation = [serviceLocation stringByAppendingString:@"/api/v1/locations/"];
            break;
        case CNRequestTypeFeedback:
            serviceLocation = [serviceLocation stringByAppendingString:@"/api/v1.1/feedback/"];
            [request addPostValue:[[CNClient currentLocation] locationId] forKey:@"location"];
            [request addPostValue:[[CNClient currentGenre] identifier] forKey:@"genre"];
            [request addPostValue:[[[CNClient currentTrack] song] identifier ] forKey:@"song-id"];
            break;
        case CNRequestTypeSong:
            serviceLocation = [serviceLocation stringByAppendingString:@"/api/v1/song/"];
            NSLog(@"submitting song request with location: %@ and genre: %@", [[CNClient currentLocation] locationId], [[CNClient currentGenre] identifier]);
            [request addPostValue:[[CNClient currentLocation] locationId]forKey:@"location"];
            [request addPostValue:[[CNClient currentGenre] identifier] forKey:@"genre"];
            break;
        case CNRequestTypeGenres:
            serviceLocation = [serviceLocation stringByAppendingString:@"/api/v1/genres/"];
            [request addPostValue:[[CNClient currentLocation] locationId] forKey:@"location"];
            break;
        case CNRequestTypePlayed:
            serviceLocation = [serviceLocation stringByAppendingString:@"/api/v1.1/played/"];
            [request addPostValue:[[CNClient currentLocation] locationId] forKey:@"location"];
            [request addPostValue:[[CNClient currentGenre] identifier] forKey:@"genre"];
            [request addPostValue:[[[CNClient currentTrack] song] identifier ] forKey:@"song-id"];
            break;
        default:
            serviceLocation = [serviceLocation stringByAppendingString:@"/"];
            break;
    }
    
    [request addPostValue:[CNClient deviceIdentifier] forKey:@"client"];
 
    NSURL *url = [NSURL URLWithString:serviceLocation];
    //NSLog(@"The URL was %@", url);
    [request setURL:url];
    
    for(id key in postVariables)
    {
        [request addPostValue:[postVariables objectForKey:key] forKey:key];
    }

    [request setCompletionBlock:^{
        //completion code
        int limit = 15000;
        NSLog(@"submitRequest Reponse for %@: \n%@", serviceLocation, [[request responseString] substringToIndex:[[request responseString] length] > limit + 1 ? limit : [[request responseString] length]]);
        
        NSDictionary *response = [[request responseString] objectFromJSONString];  
        
        if(![response objectForKey:@"status"])
        {
            failed(@"CNAPI Error: Service did not return a 'status' key.", @"9999");
            return;
        }
        
        if([[response objectForKey:@"status"] isEqualToString:@"success"])
        {
            success(response);
            return;
        }
        
        if([[response objectForKey:@"status"] isEqualToString:@"error"])
        {
            failed([response objectForKey:@"message"], [response objectForKey:@"code"]);
            return;
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        failed([error description], [NSString stringWithFormat:@"%i", [error code]]);
        return;
    }];
    
    [request startAsynchronous];
    
}

@end
