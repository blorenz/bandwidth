//
//  CNClient.h
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CNLocation;
@class CNGenre;

@interface CNClient : NSObject

@property (nonatomic, retain) NSString *deviceIdentifier;
@property (nonatomic, retain) CNLocation *currentLocation;
@property (nonatomic, retain) CNGenre *currentGenre;

+(CNClient *)instance;

@end
