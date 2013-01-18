//
//  PlayerViewControlleriPhone.h
//  Bandwidth
//
//  Created by Bergman, Adam on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"

@class MPVolumeView;

@interface PlayerViewControlleriPhone : PlayerViewController 

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) UILabel *albumLabel;
@property (nonatomic, retain) UIView *titleView;
@property (nonatomic, retain) MPVolumeView *volumeView ;
@property (nonatomic, assign) BOOL artistInfo;

@end
