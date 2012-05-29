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

+(NSString *)deviceIdentifier;
+(CNLocation *)currentLocation;
+(CNGenre *)currentGenre;
+(void)setCurrentGenre:(CNGenre *)genre;
+(void)setCurrentLocation:(CNLocation *)location;

@end
