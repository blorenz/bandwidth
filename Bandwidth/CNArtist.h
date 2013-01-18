//
//  CNArtist.h
//  Bandwidth
//
//  Created by Bergman, Adam on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNArtist : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *identifier;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
