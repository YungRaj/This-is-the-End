//
//  Badge.h
//  This is the End
//
//  Created by Ilhan Raja on 7/13/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "CollectableItem.h"

#define numberOfBadges 15

typedef enum {
    AttackBadge,
    AUpDDownBadge,
    DUpADownBadge,
    CloseCallBadge,
    DodgeAttackBadge,
    LastStandBadge,
    HealthBadge,
    RestoreHealthBadge,
    CoinBadge,
    PlusPUpTimeBadge,
    DownEnemyABadge,
    RunBadge,
    JumpBadge,
    JumpAttackBadge,
    GodBadge,
} BadgeType;

static NSString *badges[] = {@"Attack",
                             @"AUpDDown",
                             @"DUpADown",
                             @"CloseCall",
                             @"DodgeAttack",
                             @"LastStand",
                             @"Health",
                             @"RestoreHealth",
                             @"Coin",
                             @"PlusPUpTime",
                             @"DownEnemyA",
                             @"Run",
                             @"Jump",
                             @"JumpAttack",
                             @"God"};

@interface Badge : SKSpriteNode <CollectableItem>

@property (assign,nonatomic) BadgeType type;

-(instancetype)initWithType:(BadgeType)type;
-(void)activate;

@end
