//
//  PlayerViewController.m
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "AudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "SVProgressHUD.h"

@interface PlayerViewController ()
{
 	NSTimer *progressUpdateTimer;
    AudioStreamer *streamer;
}
@end

@implementation PlayerViewController

@synthesize buttonPlayPause;
@synthesize buttonThumbsUp;
@synthesize buttonNextTrack;
@synthesize buttonThumbsDown;
@synthesize imagePlay, imagePause;
@synthesize imageCarrot;
@synthesize isPlaying;
@synthesize slider;
@synthesize crowdImage;
@synthesize buttonCarrot;
@synthesize buttonLastTrack;

-(IBAction)sliderChanged:(id)sender
{
    [crowdImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"crowd_%i.png", (int)slider.value]]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isPlaying = FALSE;
    }
    return self;
}

-(IBAction)buttonPlayPauseTouched:(id)sender 
{ 
    // /*DEBUG*/ NSLog(@"PlayPauseTouched %@.", isPlaying ? @"music is playing" : @"music is paused.");
	if (!isPlaying)
	{	
        [SVProgressHUD showWithStatus:@"Buffering"];
        NSLog(@"creating streamer.");
		[self createStreamer];
        NSLog(@"setting image.");
        //[imagePlayPause setImage:[UIImage imageNamed:@"buttonPause.png"]];
        NSLog(@"starting streamer.");
		[streamer start];
	}
	else
	{
        //[imagePlayPause setImage:[UIImage imageNamed:@"buttonPlay.png"]];
		[streamer stop];
	}
}

-(IBAction)buttonNextTrackTouched:(id)sender 
{ 

}

-(IBAction)buttonThumbsUpTouched:(id)sender 
{ 

}

-(IBAction)buttonThumbsDownTouched:(id)sender 
{ 

}


//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		//[progressUpdateTimer invalidate];
		//progressUpdateTimer = nil;
		
		[streamer stop];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
    NSLog(@"Create streamer");
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
	NSString *escapedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                        nil,
                                                        (CFStringRef)@"http://dl.dropbox.com/u/23944715/butcher.mp3",
                                                        NULL,
                                                        NULL,
                                                        kCFStringEncodingUTF8);
    
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		//[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
	}
	else if ([streamer isPlaying])
	{
		//[self setButtonImage:[UIImage imageNamed:@"stopbutton.png"]];
        [SVProgressHUD dismissWithSuccess:@"Playing"];
        imagePause.hidden = FALSE;
        imagePlay.hidden = TRUE;
        isPlaying = TRUE;
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		//[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
        imagePause.hidden = TRUE;
        imagePlay.hidden = FALSE;
        isPlaying = FALSE;
	}
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (streamer.bitRate != 0.0)
	{
		//double progress = streamer.progress;
		double duration = streamer.duration;
		
		if (duration > 0)
		{
			//[positionLabel setText:
            // [NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
            //  progress,
            //  duration]];
			//[progressSlider setEnabled:YES];
			//[progressSlider setValue:100 * progress / duration];
		}
		else
		{
			//[progressSlider setEnabled:NO];
		}
	}
	else
	{
		//positionLabel.text = @"Time Played:";
	}
}

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
