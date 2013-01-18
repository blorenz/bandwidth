//
//  LocationSelectionViewController.h
//  cannon.fm
//
//  Created by Adam Bergman on 5/29/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CNLocation;

typedef void (^LocationSelected)(CNLocation *selectedLocation);

@interface LocationSelectionViewController : UITableViewController

@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) CNLocation *selectedLocation;
@property (nonatomic, copy) LocationSelected finishedBlock;

-(id)initWithLocations:(NSArray *)locationsArray;

@end
