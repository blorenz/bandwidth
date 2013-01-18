//
//  IntroLocationViewController.h
//  cannon.fm
//
//  Created by Adam Bergman on 5/29/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationSelectionViewController;
@class CNLocation;

@interface IntroLocationViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *labelIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) IBOutlet UILabel *labelScene;
@property (nonatomic, retain) IBOutlet UILabel *labelSceneInfo;
@property (nonatomic, retain) IBOutlet UILabel *labelSceneTap;
@property (nonatomic, retain) IBOutlet UITextView *infoText;
@property (nonatomic, retain) IBOutlet UIButton *buttonChange;
@property (nonatomic, retain) IBOutlet UIButton *buttonGenre;

@property (nonatomic, retain) LocationSelectionViewController *locationView;

-(void)setupLocationCollection;

-(IBAction)buttonChangeTapped:(id)sender;
-(IBAction)buttonGenreTapped:(id)sender;

@end
