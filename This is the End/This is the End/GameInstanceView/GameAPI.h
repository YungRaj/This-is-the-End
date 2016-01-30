//
//  GameAPI.h
//  This is the End
//
//  Created by Ilhan Raja on 9/16/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <CoreGraphics/CoreGraphics.h>

#define FRAME_RATE 60.0

@class PowerUp;
@class Badge;
@class Coin;
@protocol CollectableItem;

static const uint32_t playerMask = 0x1 << 0;
static const uint32_t platformMask = 0x1 << 1;
static const uint32_t levelMask = 0x1 << 2;
static const uint32_t enemyMask = 0x1 << 3;
static const uint32_t blockMask = 0x1 << 4;
static const uint32_t itemMask = 0x1 << 5;
static const uint32_t bulletMask = 0x1 << 6;


extern NSString *kPowerUpGod;
extern NSString *kPowerUpCoin;
extern NSString *kPowerUpAttack;
extern NSString *kPowerUpRun;
extern NSString *kPowerUpPortal;
extern NSString *kPowerUpJump;
extern NSString *kPowerUpDefense;
extern NSString *kPowerUpHealth;

extern NSString *kBadgeAttack;
extern NSString *kBadgeAUpDDown;
extern NSString *kBadgeDUpADown;
extern NSString *kBadgeCloseCall;
extern NSString *kBadgeDodgeAttack;
extern NSString *kBadgeLastStand;
extern NSString *kBadgeHealth;
extern NSString *kBadgeRestoreHealth;
extern NSString *kBadgeCoin;
extern NSString *kBadgePlusPUpTime;
extern NSString *kBadgeDownEnemyA;
extern NSString *kBadgeRun;
extern NSString *kBadgeJump;
extern NSString *kBadgeJumpAttack;
extern NSString *kBadgeGod;

extern NSString *kGameNotificationPlayerState;
extern NSString *kGameNotificationScore;
extern NSString *kGameNotificationWorld;
extern NSString *kGameNotificationLives;
extern NSString *kGameNotificationCoins;
extern NSString *kGameNotificationLevel;
extern NSString *kGameNotificationHealth;
extern NSString *kGameNotificationResume;
extern NSString *kGameNotificationOver;
extern NSString *kGameNotificationPause;
extern NSString *kGameNotificationSave;
extern NSString *kMainMenuPauseFrame;
extern NSString *kMainMenuResumeFrame;

BOOL checkAllCollisions(SKNode *node);
BOOL checkCollision(SKNode *a, SKNode *b);

SKSpriteNode<CollectableItem>* randomItem();
PowerUp* randomPowerUp();
Badge* randomBadge();
Coin* newCoin();
NSInteger xScaleNegativeDirectionFromIOSVersion();

