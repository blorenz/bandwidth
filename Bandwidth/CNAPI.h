//
//  CNAPI.h
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CNClient.h"
#import "CNTrackListing.h"
#import "CNLocation.h"
#import "CNGenre.h"
#import "CNJukebox.h"
#import "CNArtist.h"
#import "CNSong.h"

typedef void (^CNRequestSuccessful)(NSDictionary *response);
typedef void (^CNRequestFailed)(NSString *message, NSString *code);

typedef enum {
    CNRequestTypeLocations,
    CNRequestTypeGenres,
    CNRequestTypeSong,
    CNRequestTypeFeedback,
    CNRequestTypePlayed
} CNRequestType;

NSDictionary *endpoints;


@interface CNAPI : NSObject

@property (nonatomic, retain) NSString *serverAddress;
@property (nonatomic, assign) BOOL useSSL;
@property (nonatomic, assign) BOOL hasNowPlaying;

+(CNAPI *) instance;

+(void)submitRequest:(CNRequestType)requestType 
            withData:(NSDictionary *)postVariables 
           onSuccess:(CNRequestSuccessful)success 
           onFailure:(CNRequestFailed)failed;

@end
