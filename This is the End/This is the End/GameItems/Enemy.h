//
//  Enemy.h
//  This is the End
//
//  Created by Ilhan Raja on 8/21/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MovingObject.h"

typedef enum {
    EnemyAlien,
    EnemyRobot,
    EnemyCyborg,
} EnemyType;

typedef enum {
    EnemyStateIdle,
    EnemyStateDefend,
    EnemyStateAttack,
} EnemyState;

@interface Enemy : SKSpriteNode <MovingObject>

@property (assign, nonatomic) EnemyType enemyType;
@property (assign, nonatomic) EnemyState state;
@property (assign, nonatomic) int32_t health;
@property (assign, nonatomic) int32_t attackPower;
@property (assign, nonatomic) BOOL canMove;
@property (assign, nonatomic) BOOL canAttack;
@property (assign, nonatomic) BOOL canJump;

- (instancetype)initWithName:(NSString *)name size:(CGSize)size type:(EnemyType)type;


@end
