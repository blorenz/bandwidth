//
//  AppDelegate.m
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "UINavigationControlleriPhone.h"
#import "CNAPI.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
/*    [TestFlight takeOff:@"78720f6fba01ee7846a480c4ff016790_OTE5MjYyMDEyLTA1LTI0IDIxOjM1OjA1LjY4NzEzNA"];
    
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif */
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        navigationController = [[UINavigationControlleriPhone alloc] init];
        [self.window addSubview:navigationController.view];
        
        [navigationController pushIntroLocationViewController];
    }
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if ([CNJukebox instance].status == CNJukeboxStatusPlaying)
                {	
                    [[CNJukebox instance] pauseStreamer];
                }else{
                    [[CNJukebox instance] createStreamerWithTrack:[CNClient currentTrack]];
                }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                if([CNJukebox instance].status == CNJukeboxStatusPaused || [CNJukebox instance].status == CNJukeboxStatusPlaying)
                {
                    [[CNJukebox instance] previousTrack];
                }
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [[CNJukebox instance] nextTrackListing];
                break;
                
            default:
                break;
        }
    }
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
    
    [[CNJukebox instance] prepareForBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[CNJukebox instance] prepareForForeground];
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
