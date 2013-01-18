//
//  CNSong.h
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNSong : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *albumName;
@property (nonatomic, retain) NSURL *artworkUrl;
@property (nonatomic, assign) float rating;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(NSString *)crowdImage;

@end
