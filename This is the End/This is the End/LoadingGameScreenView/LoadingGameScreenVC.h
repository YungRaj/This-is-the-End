//
//  LoadingGameScreenVC.h
//  This is the End
//
//  Created by Ilhan Raja on 7/1/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameData;

@interface LoadingGameScreenVC : UIViewController

@property (strong,nonatomic) GameData *state;

-(void)setUpLoadingGameScreen;
-(void)cleanUpLoadingGameScreen;

@end
