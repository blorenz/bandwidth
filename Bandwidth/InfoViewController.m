//
//  InfoViewController.m
//  cannon.fm
//
//  Created by Adam Bergman on 5/29/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import "InfoViewController.h"

#import "UINavigationControlleriPhone.h"
#import "PlayerViewControlleriPhone.h"
#import "CNAPI.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

@synthesize web, tabs, bar;

@synthesize titleLabel, titleView, artistLabel, albumLabel;

-(IBAction)segmentChanged:(id)sender
{
    if([tabs selectedSegmentIndex] == 0)
    {
        
        
        NSURL *artistURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/artist/%@/?song=%@", [[CNAPI instance] serverAddress], [[[CNClient currentTrack] artist] identifier], [[[CNClient currentTrack] song] identifier]]];
        //NSLog(@"The URL is %@", artistURL);
        [web loadRequest:[NSURLRequest requestWithURL:artistURL]];
         
       /* 
        
        LOCAL HTML LOADING
        
        NSString *artistId = [[[CNClient currentTrack] artist] identifier];
        NSURL *artistURL = [[NSBundle mainBundle] URLForResource:artistId withExtension:@"html"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:artistId ofType:@"html"]])
        {
           artistURL = [[NSBundle mainBundle] URLForResource:@"artist_error" withExtension:@"html"];
        }
         [web loadRequest:[NSURLRequest requestWithURL:artistURL]];
        */
    }
    
    if([tabs selectedSegmentIndex] == 1)
    {
        
        NSURL *lyricsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/lyrics/%@", [[CNAPI instance] serverAddress], [[[CNClient currentTrack] song] identifier]]];
        [web loadRequest:[NSURLRequest requestWithURL:lyricsURL]];
         
        
        // LOCAL HTML LOADING
        //NSURL *lyricsURL = [[NSBundle mainBundle] URLForResource:@"lyrics" withExtension:@"html"];
        //[web loadRequest:[NSURLRequest requestWithURL:lyricsURL]];
    }
    
    if([tabs selectedSegmentIndex] == 2)
    {
        
        NSURL *gigsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/gigs/%@/?song=%@", [[CNAPI instance] serverAddress], [[[CNClient currentTrack] artist] identifier], [[[CNClient currentTrack] song] identifier]]];
        [web loadRequest:[NSURLRequest requestWithURL:gigsURL]];
        
        
        // LOCAL HTML LOADING
        //NSURL *gigsURL = [[NSBundle mainBundle] URLForResource:@"gigs" withExtension:@"html"];
        //[web loadRequest:[NSURLRequest requestWithURL:gigsURL]];
    }   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)refresh
{
    [web setBackgroundColor:[UIColor colorWithRed:153.0f green:153.0f blue:153.0f alpha:1.0f]];
    
    float labelWidth = 175.0f;
    
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
        titleView = [[UIView alloc] initWithFrame:CGRectMake(75.0f, -7.0f, labelWidth, 60)];
        [titleView addSubview:titleLabel];
        [titleView addSubview:artistLabel];
        [titleView addSubview:albumLabel];
        [self.view addSubview:titleView];
        [self.view bringSubviewToFront:titleView];
    }
    
    [titleLabel setText:[[[CNClient currentTrack] song] name]];
    [artistLabel setText:[[[CNClient currentTrack] artist] name]];
    [albumLabel setText:[[[CNClient currentTrack] song] albumName]];
    
    
    NSURL *artistURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/artist/%@", [[CNAPI instance] serverAddress], [[[CNClient currentTrack] artist] identifier]]];
    [web loadRequest:[NSURLRequest requestWithURL:artistURL]];
    
    [tabs setSelectedSegmentIndex:0];
}

-(IBAction)closedModal:(id)sender
{
    [((UINavigationControlleriPhone *)self.parentViewController).playerViewController setArtistInfo:FALSE];
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
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
