//
//  PowerUp.m
//  This is the End
//
//  Created by Ilhan Raja on 10/27/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import "PowerUp.h"
#import "GameScene.h"
#import "Player.h"
#import "GameData.h"

NSString *kPowerUpActionAnimation = @"powerUpAnimation";

@interface PowerUp () {
    
}


@end

@implementation PowerUp


-(instancetype)initWithType:(PowerUpType)type{
    self = [super init];
    if(self){
        _type = type;
        [self setImages];
    }
    return self;
}

-(void)setImages{
    PowerUpType type = self.type;
    NSString *powerUpName = powerUps[type];
    NSMutableArray *textures = [NSMutableArray array];
    for(int i=1; i<=4; i++){
        NSString *imageName = [NSString stringWithFormat:@"%@%d",powerUpName,i];
        [textures addObject:[SKTexture textureWithImageNamed:imageName]];
    }
    SKAction *action = [SKAction animateWithTextures:textures timePerFrame:0.2];
    action = [SKAction repeatActionForever:action];
    [self runAction:action withKey:kPowerUpActionAnimation];
    
}



-(void)activate{
    GameScene *scene = (GameScene*)self.scene;
    GameData *state = scene.state;
    if(self.type==Coin){
        state.coins = state.coins + 1;
    } else {
        [state addPowerUp:self];
    }
    [self removeAllActions];
    [self removeFromParent];
}



@end
