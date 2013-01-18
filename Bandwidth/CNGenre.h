//
//  CNGenre.h
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNGenre : NSObject

@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, assign) BOOL populated;
@property (nonatomic, assign) BOOL featured;

-(id)initWithDisplayName:(NSString *)name;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
