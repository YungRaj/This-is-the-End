//
//  GameData.h
//  This is the End
//
//  Created by Ilhan Raja on 6/19/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Badge.h"
#import "PowerUp.h"

@interface GameData : NSObject <NSCoding>

@property (assign,nonatomic) BOOL filePathExists;
@property (assign,nonatomic) int32_t state;
@property (assign,nonatomic) int32_t worlds;
@property (assign,nonatomic) int32_t levels;
@property (assign,nonatomic) int32_t lives;
@property (assign,nonatomic) int32_t health;
@property (assign,nonatomic) int32_t score;
@property (assign,nonatomic) int32_t coins;
@property (assign,nonatomic) int32_t kills;
@property (assign,nonatomic) int32_t shotsFired;


+(instancetype)loadInstanceWithState:(int32_t)state;
-(void)reset;
-(void)saveToState:(int32_t)state;
-(void)removefilePathAtState:(int32_t)state;
-(void)addPowerUp:(PowerUp*)powerUp;
-(void)addBadge:(Badge*)badge;
-(void)removePowerUp:(PowerUp *)powerUp;
-(void)removeBadge:(Badge*)badge;
-(unsigned long)numItems;
-(unsigned long)numBadges;
-(unsigned long)numPowerUps;
-(unsigned long)numBadgesFromType:(BadgeType)badgeType;
-(unsigned long)numPowerUpsFromType:(PowerUpType)powerUpType;

@end
