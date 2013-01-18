//
//  GenreSelectionViewController.h
//  cannon.fm
//
//  Created by Adam Bergman on 5/29/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenreSelectionViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *genres;

-(id)initWithGenres:(NSArray *)genresArray;

-(void)loadGenres;

-(void)gotoNowPlaying;
@end
