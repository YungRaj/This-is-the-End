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

#define numberOfPowerUps 5



typedef enum{
    Health,
    Attack,
    Defense,
    Jump,
    Run,
} PowerUpType;

static NSString *powerUps[] = {@"Health",
                               @"Attack",
                               @"Defense",
                               @"Jump",
                               @"Run"};

@interface PowerUp : SKSpriteNode <CollectableItem>

@property (assign,nonatomic) PowerUpType type;

-(instancetype)initWithType:(PowerUpType)type;
-(void)activate;

@end
