//
//  AppDelegate.h
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerViewController;
@class LocationSelectionViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) PlayerViewController *playView;
@property (nonatomic, retain) LocationSelectionViewController *locationView;

-(void)showPlayer;

@end
