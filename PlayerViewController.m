//
//  PlayerViewController.m
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "SVProgressHUD.h"
#import <Twitter/Twitter.h>
#import <QuartzCore/QuartzCore.h>

#import "CNAPI.h"

@interface PlayerViewController ()

@property (nonatomic, retain) NSString *lastAlbumArtURL;

- (void)loadAlbumArt;


@end

@implementation PlayerViewController

@synthesize buttonPlayPause;
@synthesize buttonThumbsUp;
@synthesize buttonNextTrack;
@synthesize buttonThumbsDown;
@synthesize imagePlay, imagePause;
@synthesize imageCarrot;
@synthesize slider;
@synthesize crowdImage;
@synthesize buttonCarrot;
@synthesize buttonLastTrack;
@synthesize imageAlbumArt;
@synthesize labelCountLeft;
@synthesize labelCountRight;
@synthesize labelStationName;
@synthesize viewStatus;
@synthesize buttonShowStatus;
@synthesize progressBar;

@synthesize isPlaying;

@synthesize lastAlbumArtURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isPlaying = FALSE;
        [[CNJukebox instance] setDelegate:self];
        self.lastAlbumArtURL = @"";
    }
    return self;
}

#pragma mark - CNJukebox Delegate Methods

-(void)jukeboxPlayBackStateChanged:(CNJukeboxStatus)status
{
    switch(status)
    {
        case CNJukeboxStatusIdle:
            imagePause.hidden = TRUE;
            imagePlay.hidden = FALSE;
            //[SVProgressHUD dismiss];
            [[CNJukebox instance] nextTrackListing];
            break;
            
        case CNJukeboxStatusPlaying:
            imagePause.hidden = FALSE;
            imagePlay.hidden = TRUE;
            [[CNAPI instance] setHasNowPlaying:TRUE];            
            [self loadAlbumArt];
            
            break;
            
        case CNJukeboxStatusWaiting:
            //[SVProgressHUD showWithStatus:@"Buffering" maskType:SVProgressHUDMaskTypeBlack];
            break;
            
        case CNJukeboxStatusPaused:
            //[SVProgressHUD dismiss];
            imagePause.hidden = TRUE;
            imagePlay.hidden = FALSE;
            break;
            
        default:
            break;
    }
}

-(void)jukeboxProgressUpdated:(double)progress totalDuration:(double)duration
{
    //NSLog(@"Progress Update %f of %f", progress, duration);
    if (duration > 0)
    {
        [self.progressBar setProgress:(progress / duration)];
        int minPlayed = floor(progress / 60.0f);
        int secPlayed = (int)progress % 60;
        labelCountLeft.text = [NSString stringWithFormat:@"%02i:%02i", minPlayed, secPlayed];
        
        int min = duration - progress;
        int minLeft = floor(min / 60.0f);
        int secLeft = (int)min % 60;
        labelCountRight.text = [NSString stringWithFormat:@"-%02i:%02i", minLeft, secLeft];
    
    }
}

-(void)jukeboxResumedFromBackground
{
    [self loadAlbumArt];
}


- (void)loadAlbumArt
{
    //NSLog(@"Serveraddress: %@", [[CNAPI instance] serverAddress]);
    NSString *albumUrlString = [NSString stringWithFormat:@"%@", [[[CNClient currentTrack] song] artworkUrl]];
    
    //NSLog(@"Loading Album artwork from: %@", albumUrlString);
    
    if([self.lastAlbumArtURL isEqualToString:albumUrlString])
    {
        //NSLog(@"Not loading ALbum art.");
        return;
    }
    self.lastAlbumArtURL = albumUrlString;
    
    NSURL * imageURL = [NSURL URLWithString:albumUrlString];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [self.imageAlbumArt setImage:image];
    
    [self.imageAlbumArt.layer setBorderColor: [[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:0.75] CGColor]];
    [self.imageAlbumArt.layer setBorderWidth: 1.0];
    
    [crowdImage setImage:[UIImage imageNamed:[[[CNClient currentTrack] song] crowdImage]]];
    
    
}

#pragma mark - Interface Builder Actions

-(IBAction)buttonPlayPauseTouched:(id)sender 
{ 
    // /*DEBUG*/ NSLog(@"PlayPauseTouched %@.", isPlaying ? @"music is playing" : @"music is paused.");
	if ([CNJukebox instance].status == CNJukeboxStatusPlaying)
	{	
        [[CNJukebox instance] pauseStreamer];
    }else{
        [[CNJukebox instance] createStreamerWithTrack:[CNClient currentTrack]];
	}
}

-(IBAction)buttonNextTrackTouched:(id)sender 
{ 
    [[CNJukebox instance] nextTrackListing];
}

-(IBAction)buttonPreviousTrackTouched:(id)sender
{
    if([CNJukebox instance].status == CNJukeboxStatusPaused || [CNJukebox instance].status == CNJukeboxStatusPlaying)
    {
        [[CNJukebox instance] previousTrack];
    }
}

-(IBAction)buttonThumbsUpTouched:(id)sender 
{
    if ([[CNClient currentTrack] thumbsedUp])
        return;
    
    NSLog(@"Thumbs up!");
    [SVProgressHUD showSuccessWithStatus:@"Rock On"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"1", @"thumbs", nil];
    

    [CNAPI submitRequest:CNRequestTypeFeedback withData:dict onSuccess:^(NSDictionary *response) {
       // Success
        CNTrackListing *currentTrack = [CNClient currentTrack];
        
        currentTrack.thumbsedUp = YES;
        
        
    } onFailure:^(NSString *message, NSString *code) {
      //  Failure
        
    }];
    
}

-(IBAction)buttonThumbsDownTouched:(id)sender 
{
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"-1", @"thumbs", nil];
    
      [CNAPI submitRequest:CNRequestTypeFeedback withData:dict onSuccess:^(NSDictionary *response) {
        // Success
        [[CNJukebox instance] nextTrackListing];
        
    } onFailure:^(NSString *message, NSString *code) {
        //  Failure
        
    }];
    
    
}

-(IBAction)buttonCarrotTouched:(id)sender
{
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Tell Your Friends" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share with Facebook", @"Share with Twitter", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
}

-(IBAction)buttonStatusTouched:(id)sender
{
    if(viewStatus.isHidden)
    {
        viewStatus.alpha = 0.0f;
        [UIView animateWithDuration:0.2f animations:^{
            viewStatus.hidden = FALSE;
            viewStatus.alpha = 1.0f;
        }];
    }else{
        [UIView animateWithDuration:0.2f animations:^{
            viewStatus.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if(finished)
            {
                viewStatus.hidden = TRUE;
            }
        }];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if(buttonIndex == 0)
    {
        NSString *status = [[NSString stringWithFormat:@"fb://publish/?text=I'm listening to '%@' by %@ on cannon.fm - http://cannon.fm", [[[CNClient currentTrack] song] name], [[[CNClient currentTrack] artist] name]] stringByAddingPercentEscapesUsingEncoding:
                            NSASCIIStringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:status]];
    }
    if(buttonIndex == 1)
    {
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
        NSString *tweet = [NSString stringWithFormat:@"I'm listening to '%@' by %@ on @cannondotfm", [[[CNClient currentTrack] song] name], [[[CNClient currentTrack] artist] name]];
        [controller setInitialText:tweet];
        [self presentModalViewController:controller animated:YES];
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    imagePause.hidden = TRUE;
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
