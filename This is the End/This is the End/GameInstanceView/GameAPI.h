//
//  GameAPI.h
//  This is the End
//
//  Created by Ilhan Raja on 9/16/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PowerUp;
@class Badge;
@class SKSpriteNode;
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
extern NSString *kBadgeAttackUpDefenseDown;
extern NSString *kBadgeDefenseUpAttackDown;
extern NSString *kBadgeCloseCall;
extern NSString *kBadgeDodgeAttack;
extern NSString *kBadgeLastStand;
extern NSString *kBadgeHealth;
extern NSString *kBadgeRestoreHealth;
extern NSString *kBadgeCoin;
extern NSString *kBadgeIncreasePowerUpTime;
extern NSString *kBadgeDecreaseEnemyAttack;
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


SKSpriteNode<CollectableItem>* randomItem();
PowerUp* randomPowerUp();
Badge* randomBadge();
NSInteger xScaleNegativeDirectionFromIOSVersion();

