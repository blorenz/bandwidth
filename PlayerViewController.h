//
//  PlayerViewController.h
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AudioStreamer;

@interface PlayerViewController : UIViewController
{

}

@property (nonatomic, retain) IBOutlet UIButton *buttonPlayPause;
@property (nonatomic, retain) IBOutlet UIButton *buttonNextTrack;
@property (nonatomic, retain) IBOutlet UIButton *buttonThumbsUp;
@property (nonatomic, retain) IBOutlet UIButton *buttonThumbsDown;
@property (nonatomic, retain) IBOutlet UIButton *buttonLastTrack;
@property (nonatomic, retain) IBOutlet UIButton *buttonCarrot;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UIImageView *crowdImage;

@property (nonatomic, retain) IBOutlet UIImageView *imagePlay;
@property (nonatomic, retain) IBOutlet UIImageView *imagePause;
@property (nonatomic, retain) IBOutlet UIImageView *imageCarrot;

-(IBAction)sliderChanged:(id)sender;

-(IBAction)buttonPlayPauseTouched:(id)sender;
-(IBAction)buttonNextTrackTouched:(id)sender;
-(IBAction)buttonThumbsUpTouched:(id)sender;
-(IBAction)buttonThumbsDownTouched:(id)sender;

- (void)updateProgress:(NSTimer *)aNotification;

@end
