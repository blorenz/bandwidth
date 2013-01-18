//
//  UINavigationControlleriPhone.h
//  cannon.fm
//
//  Created by Adam Bergman on 5/29/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerViewControlleriPhone;
@class IntroLocationViewController;
@class LocationSelectionViewController;
@class GenreSelectionViewController;
@class InfoViewController;


@interface UINavigationControlleriPhone : UINavigationController

@property (nonatomic, retain) PlayerViewControlleriPhone *playerViewController;

@property (nonatomic, retain) IntroLocationViewController *introLocationViewController;
@property (nonatomic, retain) LocationSelectionViewController *locationSelectionViewController;

@property (nonatomic, retain) GenreSelectionViewController *genreSelectionViewController;

@property (nonatomic, retain) InfoViewController *infoViewController;

- (void)pushPlayerViewController:(BOOL)changeTrack;
- (void)pushIntroLocationViewController;
- (void)pushLocationViewController;
- (void)pushGenreViewController;
- (void)pushInfoViewController;

@end
