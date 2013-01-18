//
//  UINavigationControlleriPhone.m
//  cannon.fm
//
//  Created by Adam Bergman on 5/29/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import "UINavigationControlleriPhone.h"

#import "PlayerViewControlleriPhone.h"
#import "IntroLocationViewController.h"
#import "LocationSelectionViewController.h"
#import "GenreSelectionViewController.h"
#import "InfoViewController.h"

#import "CNAPI.h"

@interface UINavigationControlleriPhone ()

@end

@implementation UINavigationControlleriPhone

@synthesize playerViewController;
@synthesize locationSelectionViewController;
@synthesize genreSelectionViewController;
@synthesize introLocationViewController;
@synthesize infoViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}


- (void)pushPlayerViewController:(BOOL)changeTrack
{
    if(!playerViewController)
    {
        playerViewController = [[PlayerViewControlleriPhone alloc] initWithNibName:@"PlayerViewControlleriPhone" bundle:nil];
    }
    
    if(playerViewController.navigationController)
    {
        [self popToViewController:playerViewController animated:TRUE];
    }else{
        [self pushViewController:playerViewController animated:TRUE];
    }
    
    if(changeTrack)
    {
        [[CNJukebox instance] nextTrackListing];
    }
}

- (void)pushInfoViewController
{
    if(!infoViewController)
    {
        infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
        [infoViewController.view setFrame:playerViewController.view.frame];
    }
    
    infoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [playerViewController presentModalViewController:infoViewController animated:YES];
}


- (void)pushIntroLocationViewController
{
    if(!introLocationViewController)
    {
        introLocationViewController = [[IntroLocationViewController alloc] initWithNibName:@"IntroLocationViewController" bundle:nil];
    }
    
    if(introLocationViewController.navigationController)
    {
        [self popToViewController:introLocationViewController animated:TRUE];
    }else{
        [self pushViewController:introLocationViewController animated:TRUE];
    }
}

- (void)pushLocationViewController
{
    /*NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self viewControllers]];
    [viewControllers removeLastObject];
    [self setViewControllers:viewControllers animated:YES];
    */
    
    if(!locationSelectionViewController)
    {
        locationSelectionViewController = [[LocationSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    
    if(locationSelectionViewController.navigationController)
    {
        [self popToViewController:locationSelectionViewController animated:TRUE];
    }else{
        [self pushViewController:locationSelectionViewController animated:TRUE];
    }
}

- (void)pushGenreViewController
{
    if(!genreSelectionViewController)
    {
        genreSelectionViewController = [[GenreSelectionViewController alloc] init];
    }
    
    if(genreSelectionViewController.navigationController)
    {
        [self popToViewController:genreSelectionViewController animated:TRUE];
    }else{
        [self pushViewController:genreSelectionViewController animated:TRUE];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationBar] setBarStyle:UIBarStyleBlackOpaque];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
