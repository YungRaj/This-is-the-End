//
//  UserPlayer.h
//  This is the End
//
//  Created by Ilhan Raja on 7/7/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "BulletDelegate.h"
#import "MovingObject.h"

typedef enum {
    PlayerStateStanding,
    PlayerStateIdle,
    PlayerStateWalking,
    PlayerStateFire,
    PlayerStateFireAndWalking,
    PlayerStateJumping,
} PlayerState;


static const float kPlayerMiddle = 0.35;

extern NSString *kPlayerActionJump;
extern NSString *kPlayerActionWalk;
extern NSString *kPlayerActionFire;
extern NSString *kPlayerActionWalkAndFire;
extern NSString *kPlayerActionReturnToOriginalPosition;
extern NSString *kPlayerActionDeath;


@class Achievement;
@class PowerUp;
@class Badge;

@interface Player : SKSpriteNode <MovingObject, BulletDelegate, NSCoding>


@property (weak, nonatomic) GameData *state;
@property (assign, nonatomic) PlayerState currentState;
@property (assign, nonatomic) int64_t highScore;
@property (strong, nonatomic) NSMutableArray *bullets;
@property (assign, nonatomic) BOOL isStanding;
@property (assign, nonatomic) BOOL shouldExitMoveAndAttack;

+ (instancetype)loadPlayerInstance;
- (void)addAchievement:(Achievement *)achievment;

@end
