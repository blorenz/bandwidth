//
//  PlayerViewController.h
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNJukeBox.h"

@class AudioStreamer;

@interface PlayerViewController : UIViewController <CNJukeboxDelegate,UIActionSheetDelegate>
{

}

// Interface Builder UI Items
@property (nonatomic, retain) IBOutlet UIButton *buttonPlayPause;
@property (nonatomic, retain) IBOutlet UIButton *buttonNextTrack;
@property (nonatomic, retain) IBOutlet UIButton *buttonThumbsUp;
@property (nonatomic, retain) IBOutlet UIButton *buttonThumbsDown;
@property (nonatomic, retain) IBOutlet UIButton *buttonLastTrack;
@property (nonatomic, retain) IBOutlet UIButton *buttonCarrot;

@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UIImageView *crowdImage;

@property (nonatomic, retain) IBOutlet UIImageView *imagePlay;
@property (nonatomic, retain) IBOutlet UIImageView *imagePause;
@property (nonatomic, retain) IBOutlet UIImageView *imageCarrot;
@property (nonatomic, retain) IBOutlet UIImageView *imageAlbumArt;

@property (nonatomic, retain) IBOutlet UILabel *labelCountLeft;
@property (nonatomic, retain) IBOutlet UILabel *labelCountRight;
@property (nonatomic, retain) IBOutlet UILabel *labelStationName;
@property (nonatomic, retain) IBOutlet UIView  *viewStatus;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) IBOutlet UIButton *buttonShowStatus;

// Public Properties
@property (nonatomic, assign) BOOL isPlaying;

// Interface Builder Actions
-(IBAction)buttonPlayPauseTouched:(id)sender;
-(IBAction)buttonNextTrackTouched:(id)sender;
-(IBAction)buttonPreviousTrackTouched:(id)sender;
-(IBAction)buttonThumbsUpTouched:(id)sender;
-(IBAction)buttonThumbsDownTouched:(id)sender;
-(IBAction)buttonCarrotTouched:(id)sender;

@end
