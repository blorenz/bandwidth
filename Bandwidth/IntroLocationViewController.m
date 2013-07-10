//
//  IntroLocationViewController.m
//  cannon.fm
//
//  Created by Adam Bergman on 5/29/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import "IntroLocationViewController.h"

#import "CNAPI.h"
#import "UINavigationControlleriPhone.h"
#import "LocationSelectionViewController.h"

@interface IntroLocationViewController ()

@property (nonatomic, retain) NSMutableArray *locations;

@end

@implementation IntroLocationViewController

@synthesize labelScene;
@synthesize labelIndicator;
@synthesize labelSceneInfo;
@synthesize labelSceneTap;
@synthesize buttonChange;
@synthesize buttonGenre;
@synthesize activityIndicator;
@synthesize infoText;

@synthesize locations;
@synthesize locationView;

-(IBAction)buttonChangeTapped:(id)sender
{
    if(!locationView)
    {
        locationView = [[LocationSelectionViewController alloc] initWithLocations:locations];
    }
    
    UINavigationController *tempNav = [[UINavigationController alloc] initWithRootViewController:locationView];
    
    locationView.finishedBlock = ^(CNLocation *selectedLocation) {
        labelScene.text = selectedLocation.locationDisplayName;
    };
    
    [self presentModalViewController:tempNav animated:TRUE];
}

-(IBAction)buttonGenreTapped:(id)sender
{
    [(UINavigationControlleriPhone *)self.navigationController pushGenreViewController];
}

- (void)setupLocationCollection
{
    activityIndicator.hidden = FALSE;
    buttonGenre.hidden = FALSE;
    /*labelIndicator.hidden = FALSE;
    labelScene.hidden = TRUE;
    labelSceneInfo.hidden = TRUE;
    labelSceneTap.hidden = TRUE;
    infoText.hidden = TRUE;
    buttonChange.hidden = TRUE;
    buttonGenre.hidden = TRUE;*/
    
    [CNClient startLocationServices:^(CLLocation *location) 
     {
         NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
         
         if(location)
         {
             CLLocationCoordinate2D coordinate = [location coordinate];
             
             float longitude=coordinate.longitude;
             float latitude=coordinate.latitude;
 
             
             
             // /*DEBUG*/ NSLog(@"IntroLocationViewController: dLongitude : %f",longitude);
             // /*DEBUG*/ NSLog(@"IntroLocationViewController: dLatitude : %f", latitude); 
             
             [post setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"long"];
             [post setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"lat"];
             
         }else{
             [post setObject:@"0.0" forKey:@"long"];
             [post setObject:@"0.0" forKey:@"lat"];
         }
         
         [CNAPI submitRequest:CNRequestTypeLocations withData:post onSuccess:^(NSDictionary *response) {
             //select columbus
             
             activityIndicator.hidden = TRUE;
             buttonGenre.hidden = FALSE;
             /*labelIndicator.hidden = TRUE;
             labelScene.hidden = FALSE;
             labelSceneInfo.hidden = FALSE;
             labelSceneTap.hidden = FALSE;
             infoText.hidden = FALSE;
             buttonChange.hidden = FALSE;
             buttonGenre.hidden = FALSE;*/
             
             locations = [[NSMutableArray alloc] init];
             
             for(NSDictionary *serverLocation in  [response objectForKey:@"locations"])
             {
                 CNLocation *l = [[CNLocation alloc] init];
                 l.locationDisplayName = [serverLocation objectForKey:@"display-name"];
                 l.locationId = [serverLocation objectForKey:@"id"];
                 [locations addObject:l];
             }
             
         } onFailure:^(NSString *message, NSString *code) {
             NSLog(@"Message: %@ with Code: %@", message, code);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error connecting to the cannon.fm servers." delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil];
             [alert setDelegate:self];
             [alert show];             
         }];
     }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setupLocationCollection];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlackOpaque];
    self.navigationController.navigationBar.hidden = NO;
     self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 30)];
	[titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
	[titleLabel setText:@"launch your scene"];
    [self.navigationItem setTitleView:titleLabel];
    
    /*
    if([[CNAPI instance] hasNowPlaying])
    {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(gotoNowPlaying)];
        
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    */
    
    buttonGenre.hidden = FALSE;
}

-(void)gotoNowPlaying
{
    [(UINavigationControlleriPhone *)self.navigationController pushGenreViewController];
    [(UINavigationControlleriPhone *)self.navigationController pushPlayerViewController:FALSE];
}

- (void)viewDidLoad
{
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlackOpaque];
    self.navigationController.navigationBar.hidden = YES;
   
    [super viewDidLoad];
    
    
    
    [self.navigationItem setBackBarButtonItem:nil];
    
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Scenes"
                                                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    
    
    [self setupLocationCollection];
    
    [labelScene setText:[CNClient currentLocation].locationDisplayName];
    
    buttonGenre.hidden = FALSE;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
