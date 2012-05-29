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

typedef void (^CNRequestSuccessful)(NSDictionary *response);
typedef void (^CNRequestFailed)(NSString *message, NSString *code);

typedef enum {
    CNRequestTypeLocations,
    CNRequestTypeGenres,
    CNRequestTypeSong,
    CNRequestTypeFeedback
} CNRequestType;

@interface CNAPI : NSObject

@property (nonatomic, retain) NSString *serverAddress;
@property (nonatomic, assign) BOOL useSSL;

+(CNAPI *) instance;

+(void)submitRequest:(CNRequestType)requestType 
            withData:(NSDictionary *)postVariables 
           onSuccess:(CNRequestSuccessful)success 
           onFailure:(CNRequestFailed)failed;

@end
