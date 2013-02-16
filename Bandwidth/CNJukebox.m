//
//  CNJukeBox.m
//  cannon.fm
//
//  Created by Adam Bergman on 6/7/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import "CNJukebox.h"

#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "AudioStreamer.h"
#import "CNAPI.h"

@interface CNJukebox ()
{
 	NSTimer *progressUpdateTimer;
    BOOL isSearchingForTrack;
    BOOL isBackgrounded;
    int retry;
}

@property (nonatomic, retain) AudioStreamer *streamer;

- (void)updateProgress:(NSTimer *)aNotification;

@end

@implementation CNJukebox

@synthesize delegate;
@synthesize status;
@synthesize streamer;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.status = CNJukeboxStatusIdle;
        isSearchingForTrack = FALSE;
        retry = 0;
    }
    return self;
}

+(CNJukebox *)instance  
{
	static CNJukebox *instance;
	@synchronized(self) 
    {
		if(!instance) 
        {
			instance = [[CNJukebox alloc] init];
		}
	}
	return instance;
}

-(void)nextTrackListing
{
    if(status == CNJukeboxStatusWaiting){ return; }
    
    if([self streamer])
    {
        [self destroyStreamer];
        self.streamer = nil;
    }
    
    isSearchingForTrack = TRUE;
    
    [CNAPI submitRequest:CNRequestTypeSong withData:nil onSuccess:^(NSDictionary *response) {
        
        retry = 0;
        
        CNTrackListing *track = [[CNTrackListing alloc] initWithDictionary:response];
        
        if([CNClient currentTrack])
        {
            if([[[track song] name] isEqualToString:[[[CNClient currentTrack] song] name]])
            {
                NSLog(@"Same Track retrying to get new song.");
                [self nextTrackListing];
                return;
            }
        }
        
        [CNClient setCurrentTrack:track];    
        
        [self createStreamerWithTrack:[CNClient currentTrack]];
        
        isSearchingForTrack = FALSE;
        
    } onFailure:^(NSString *message, NSString *code) {
        NSLog(@"Failure with message %@ and code %@", message, code);
        if(retry < 3)
        {
            retry++;
            [self nextTrackListing];
        }else{
            retry = 0;
        }
        
    }];
}

-(void)previousTrack
{
    if(![CNClient previousTrack])
    {
        [self restartStreamer];
    }
    
    if( [self streamer].progress < 2 )
    {
        [self playTrack:[CNClient previousTrack]];
    }else{
        [self restartStreamer];
    }
}

-(void)playTrack:(CNTrackListing *)track
{
    [CNClient setCurrentTrack:track];    
    
    if([self streamer])
    {
        [self destroyStreamer];
        self.streamer = nil;
    }
    
    [self createStreamerWithTrack:[CNClient currentTrack]];
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (self.streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:self.streamer];
        
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[[self streamer] stop];
		self.streamer = nil;
	}
}

- (void)pauseStreamer
{
    [[self streamer] pause];
}

- (void)stopStreamer
{
    [self destroyStreamer];
}

-(void)restartStreamer
{
    if([self streamer] && (status == CNJukeboxStatusPaused || status == CNJukeboxStatusPlaying))
    {
        [[self streamer] seekToTime:0.1f];
        [[self streamer] start];        
    }
}

-(void)prepareForBackground
{
    NSLog(@"CNJukeBox Preparing for Background");
    
    isBackgrounded = TRUE;
    
    if([delegate respondsToSelector:@selector(jukeboxEnteredBackground)])
    {
        [delegate jukeboxEnteredBackground];
    }
    
    if(progressUpdateTimer)
    {
        [progressUpdateTimer invalidate];
        progressUpdateTimer = nil;
    }
}

-(void)prepareForForeground
{
    NSLog(@"CNJukeBox Preparing for Foreground");
    
    isBackgrounded = FALSE;
    
    if([delegate respondsToSelector:@selector(jukeboxResumedFromBackground)])
    {
        [delegate jukeboxResumedFromBackground];
    }
    
    if(progressUpdateTimer)
    {
        [progressUpdateTimer invalidate];
        progressUpdateTimer = nil;
    }
    
    progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
                                                           target:self
                                                         selector:@selector(updateProgress:)
                                                         userInfo:nil
                                                          repeats:YES];
    
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamerWithTrack:(CNTrackListing *)track
{
    if(![CNClient currentTrack])
    {
        return;
    }
    
	if ([self streamer] && status == CNJukeboxStatusPaused)
	{
        [[self streamer] start];
		return;
	}
    
	[self destroyStreamer];
	
    if([self streamer])
    {
        NSLog(@"Streamer exists, return.");
        return;
    }
    
    CNSong *song = [[CNClient currentTrack] song];
    
    NSLog(@"Creating streamer with song url %@", song.url);
    
	self.streamer = [[AudioStreamer alloc] initWithURL:song.url];
	
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
     object:[self streamer]];
    
    [[self streamer] start];
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([[self streamer] isWaiting])
	{
		//[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
//        NSLog(@"CNJukebox %@ State Changed: CNJukeboxStatusWaiting", [self streamer]);
        self.status = CNJukeboxStatusWaiting;
	}
	else if ([[self streamer] isPlaying])
	{
      

        //NSLog(@"CNJukebox %@ State Changed: CNJukeboxStatusPlaying", [self streamer]);
        if (![[CNClient currentTrack] submittedPlayed] ) {
              [CNClient currentTrack].submittedPlayed = YES;
        
            [CNAPI submitRequest:CNRequestTypePlayed withData:nil onSuccess:^(NSDictionary *response) {
                // Success
                            
            } onFailure:^(NSString *message, NSString *code) {
                //  Failure
                
            }];

            
        }
        self.status = CNJukeboxStatusPlaying;
	}
	else if ([[self streamer] isIdle])
	{
//        NSLog(@"CNJukebox %@ State Changed: CNJukeboxStatusIdle", [self streamer]);
        self.status = CNJukeboxStatusIdle;
        
        if([self streamer].duration > 0)
        {
            if(!isSearchingForTrack)
            {
//                NSLog(@"MOVING TO NEXT TRACK...");
                [self nextTrackListing];
            }
        }
	}else if([[self streamer] isPaused])
    {
//        NSLog(@"CNJukebox State Changed: CNJukeboxStatusPaused");
        self.status = CNJukeboxStatusPaused;
    }
    
    if(!isBackgrounded)
    {
        // /*DEBUG*/NSLog(@"Dispatching Playstate change");
        [delegate jukeboxPlayBackStateChanged:self.status];
    }else{
        // /*DEBUG*/NSLog(@"App in Background Will not Dispatch Playstate change.");
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
    
	if ([self streamer].bitRate != 0.0)
	{
		double progress = [self streamer].progress;
		double duration = [self streamer].duration;
		
        if(!isBackgrounded)
        {
            if([delegate respondsToSelector:@selector(jukeboxProgressUpdated:totalDuration:)])
            {
                [delegate jukeboxProgressUpdated:progress totalDuration:duration];
            }
        }
        
		if (duration > 0)
		{
			//[positionLabel setText:
            // [NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
            //  progress,
            //  duration]];
			//[progressSlider setEnabled:YES];
			//[progressSlider setValue:100 * progress / duration];
            
            // /*DEBUG*/NSLog(@"Time Played: %.1f/%.1f seconds", progress, duration);
            
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

@end
