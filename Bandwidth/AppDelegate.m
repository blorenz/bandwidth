//
//  AppDelegate.m
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerViewControlleriPhone.h"
#import "LocationSelectionViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize playView;
@synthesize locationView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [TestFlight takeOff:@"78720f6fba01ee7846a480c4ff016790_OTE5MjYyMDEyLTA1LTI0IDIxOjM1OjA1LjY4NzEzNA"];
    
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    
    locationView = [[LocationSelectionViewController alloc] initWithNibName:@"LocationSelectionViewController" bundle:nil];
    [locationView.view setFrame:CGRectMake(0.0f, 20.0f, locationView.view.frame.size.width, locationView.view.frame.size.height)];
    [self.window addSubview:locationView.view];
     
     
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)showPlayer
{
    [locationView.view removeFromSuperview];
    
    playView = [[PlayerViewControlleriPhone alloc] initWithNibName:@"PlayerViewControlleriPhone" bundle:nil];
    [playView.view setFrame:CGRectMake(0.0f, 20.0f, playView.view.frame.size.width, playView.view.frame.size.height)];
    [self.window addSubview:playView.view];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
