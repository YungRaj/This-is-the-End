//
//  ViewController.h
//  CAGame
//
//  Created by Ilhan Raja on 6/9/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>


@interface MainMenuViewController : UIViewController

@property (strong, nonatomic) UIImageView *view;

- (void)cleanUpMainMenuItems;
- (void)setUpView;
- (void)authenticateLocalPlayer;

@end
