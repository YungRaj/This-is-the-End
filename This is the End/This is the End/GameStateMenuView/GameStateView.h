//
//  GameStateView.h
//  This is the End
//
//  Created by Ilhan Raja on 6/21/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"

@interface GameStateView : UIView

@property (strong,nonatomic) GameData *data;
@property (strong,nonatomic) CALayer *stateText;
@property (strong,nonatomic) CALayer *worldText;
@property (strong,nonatomic) CALayer *worldNum;
@property (strong,nonatomic) CALayer *worldBackground;
@property (strong,nonatomic) UIButton *createGame;
@property (strong,nonatomic) CALayer *createText;
@property (strong,nonatomic) UIButton *play;
@property (strong,nonatomic) CALayer *playText;



-(instancetype)initWithFrame:(CGRect)frame gameStateData:(GameData*)data;
-(void)setUpSubViews;
-(void)cleanUpView;




@end
