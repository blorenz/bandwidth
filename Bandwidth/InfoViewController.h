//
//  InfoViewController.h
//  cannon.fm
//
//  Created by Adam Bergman on 5/29/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

@property (nonatomic, retain) IBOutlet UISegmentedControl *tabs;
@property (nonatomic, retain) IBOutlet UIWebView *web;


@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) UILabel *albumLabel;
@property (nonatomic, retain) UIView *titleView;

@property (nonatomic, retain) UINavigationBar *bar;


-(IBAction)segmentChanged:(id)sender;
-(IBAction)closedModal:(id)sender;
- (void)refresh;

@end
