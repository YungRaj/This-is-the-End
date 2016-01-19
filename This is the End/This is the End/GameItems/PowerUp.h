//
//  PowerUp.h
//  This is the End
//
//  Created by Ilhan Raja on 10/27/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

/*
 Power ups so far
 Coins
 Health restore
 Attack increase
 Defense increase
 Jump
 Run
 
 */

#import <SpriteKit/SpriteKit.h>
#import "MovingObject.h"
#import "CollectableItem.h"

#define numberOfPowerUps 8

typedef enum{
    Coin,
    God,
    Health,
    Attack,
    Defense,
    Jump,
    Run,
    Portal,
} PowerUpType;

static NSString *powerUps[] = {@"Coin",
                               @"God",
                               @"Health"
                               @"Attack",
                               @"Defense",
                               @"Jump",
                               @"Run"};

@interface PowerUp : SKSpriteNode <CollectableItem>

@property (assign,nonatomic) PowerUpType type;

-(instancetype)initWithType:(PowerUpType)type;
-(void)spawnNewItemAtPoint:(CGPoint)point;
-(void)activate;
-(void)deactivate;

@end
