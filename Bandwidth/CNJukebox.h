//
//  CNJukeBox.h
//  cannon.fm
//
//  Created by Adam Bergman on 6/7/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNTrackListing;

typedef enum {
    CNJukeboxStatusIdle,
    CNJukeboxStatusPlaying,
    CNJukeboxStatusWaiting,
    CNJukeboxStatusPaused
} CNJukeboxStatus;

@protocol CNJukeboxDelegate <NSObject>

@required
-(void)jukeboxPlayBackStateChanged:(CNJukeboxStatus)status;

@optional
-(void)jukeboxProgressUpdated:(double)progress totalDuration:(double)duration;
-(void)jukeboxEnteredBackground;
-(void)jukeboxResumedFromBackground;

@end

@interface CNJukebox : NSObject

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) CNJukeboxStatus status;

- (void)createStreamerWithTrack:(CNTrackListing *)track;
- (void)pauseStreamer;
- (void)stopStreamer;
-(void)restartStreamer;
-(void)nextTrackListing;
-(void)previousTrack;
-(void)prepareForBackground;
-(void)prepareForForeground;

+(CNJukebox *)instance;

@end
