//
//  PlayerViewControlleriPhone.m
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewControlleriPhone.h"

#import <MediaPlayer/MediaPlayer.h>

#import "UINavigationControlleriPhone.h"
#import "InfoViewController.h"
#import "CNAPI.h"

@interface PlayerViewControlleriPhone ()

@end

@implementation PlayerViewControlleriPhone

@synthesize titleLabel, titleView, artistLabel, albumLabel, volumeView, artistInfo;

-(void)jukeboxPlayBackStateChanged:(CNJukeboxStatus)status
{
    [super jukeboxPlayBackStateChanged:status];
    
    if(status == CNJukeboxStatusPlaying)
    {
        if(artistInfo)
        {
            [((UINavigationControlleriPhone *)self.parentViewController).infoViewController refresh];
        }
    }
}

-(void)jukeboxProgressUpdated:(double)progress totalDuration:(double)duration
{
    [super jukeboxProgressUpdated:progress totalDuration:duration];
    
    
    if(![titleLabel.text isEqualToString:[[[CNClient currentTrack] song] name]])
    {
        [titleLabel setText:[[[CNClient currentTrack] song] name]];
        [artistLabel setText:[[[CNClient currentTrack] artist] name]];
        [albumLabel setText:[[[CNClient currentTrack] song] albumName]];
        //NSString *artistId = [[[CNClient currentTrack] artist] identifier];
        //NSString *imagePath = [NSString stringWithFormat:@"%@.jpg", artistId];
        //NSLog(@"Image Path is %@", imagePath);
        //[self.imageAlbumArt setImage:[UIImage imageNamed:imagePath]];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        artistInfo = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Now Playing"
                                                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = backButton;
    
    volumeView = [[MPVolumeView alloc] initWithFrame:self.slider.frame];
    volumeView.showsRouteButton = TRUE;
    volumeView.showsVolumeSlider = TRUE;
    [self.view addSubview:volumeView];
    [self.view bringSubviewToFront:volumeView];
    
    self.slider.hidden = TRUE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlackOpaque];
    
    float labelWidth = 175.0f;;
    float labelX = 0.0f;
        
    if(!titleLabel)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, labelWidth, 30)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];

    }
    
    if(!artistLabel)
    {
        artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, labelWidth, 30)];
        [artistLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [artistLabel setBackgroundColor:[UIColor clearColor]];
        [artistLabel setTextColor:[UIColor whiteColor]];
        [artistLabel setTextAlignment:UITextAlignmentCenter];
        
    }
    
    if(!albumLabel)
    {
        albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, labelWidth, 30)];
        [albumLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [albumLabel setBackgroundColor:[UIColor clearColor]];
        [albumLabel setTextColor:[UIColor whiteColor]];
        [albumLabel setTextAlignment:UITextAlignmentCenter];
        
    }
    
    if(!titleView)
    {
        titleView = [[UIView alloc] initWithFrame:CGRectMake(labelX, 0.0f, labelWidth, 60)];
        [titleView addSubview:titleLabel];
        [titleView addSubview:artistLabel];
        [titleView addSubview:albumLabel];
        [self.navigationItem setTitleView:titleView];
    }
   
    
    // Initialize the UIButton
    UIImage *buttonImage = [UIImage imageNamed:@"icon_flip.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [aButton addTarget:self action:@selector(showArtistInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Initialize the UIBarButtonItem
    
    UIBarButtonItem *swapButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    [swapButton setTarget:self];
    [swapButton setAction:@selector(showArtistInfo:)];
    
    [[self navigationItem] setRightBarButtonItem:swapButton];
    
    [self.labelStationName setText:[NSString stringWithFormat:@"%@ — %@", [[CNClient currentGenre] displayName], [[CNClient currentLocation] locationDisplayName]]];
}

-(void)showArtistInfo:(id)sender
{
    artistInfo = TRUE;
    [(UINavigationControlleriPhone *)self.navigationController pushInfoViewController];
    [((UINavigationControlleriPhone *)self.navigationController).infoViewController refresh];
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
