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

#import "JSONKit.h"
#import "ASIFormDataRequest.h"

@interface CNAPI()

+(NSString *)generateServerURL;

@end

@implementation CNAPI

@synthesize serverAddress, useSSL;

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
            [instance setServerAddress:@"adambergman.com/cannon.fm"];
		}
	}
	return instance;
}

+(NSString *)generateServerURL
{
    NSString *url = @"http://";
    if([[CNAPI instance] useSSL]){ url = @"https://"; }
    url = [url stringByAppendingFormat:@"%@", [[CNAPI instance] serverAddress]];
    return url;
}


+(void)submitRequest:(CNRequestType)requestType 
            withData:(NSDictionary *)postVariables 
           onSuccess:(CNRequestSuccessful)success 
           onFailure:(CNRequestFailed)failed
{
    
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc] init];
    __weak ASIFormDataRequest *request = _request;
    
    
    NSString *userAgentString = [NSString stringWithFormat:@"cannon.fm iOS Client %@ Build: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    [ASIFormDataRequest setDefaultUserAgentString:userAgentString];
    
    
    NSString *serviceLocation = [[CNAPI generateServerURL] stringByAppendingFormat:@"/api_v1/%@", ""];
    switch(requestType)
    {
        case CNRequestTypeLocations:
            serviceLocation = [serviceLocation stringByAppendingString:@"locations/"];
            break;
        case CNRequestTypeFeedback:
            serviceLocation = [serviceLocation stringByAppendingString:@"feedback/"];
            [request addPostValue:[CNClient currentLocation] forKey:@"location"];
            [request addPostValue:[CNClient currentLocation] forKey:@"genre"];
            break;
        case CNRequestTypeSong:
            serviceLocation = [serviceLocation stringByAppendingString:@"song/"];
            [request addPostValue:[CNClient currentLocation] forKey:@"location"];
            [request addPostValue:[CNClient currentLocation] forKey:@"genre"];
            break;
        case CNRequestTypeGenres:
            serviceLocation = [serviceLocation stringByAppendingString:@"genres/"];
            [request addPostValue:[CNClient currentLocation] forKey:@"location"];
            break;
        default:
            serviceLocation = [serviceLocation stringByAppendingString:@"/"];
            break;
    }
    
    [request addPostValue:[CNClient deviceIdentifier] forKey:@"client"];
 
    NSURL *url = [NSURL URLWithString:serviceLocation];     
    [request setURL:url];
    
    for(id key in postVariables)
    {
        [request addPostValue:[postVariables objectForKey:key] forKey:key];
    }

    [request setCompletionBlock:^{
        //completion code
        NSDictionary *response = [[request responseString] objectFromJSONString];  
        
        if(![response objectForKey:@"status"])
        {
            failed(@"Service returned unknown response.", @"601");
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
    
}

@end
