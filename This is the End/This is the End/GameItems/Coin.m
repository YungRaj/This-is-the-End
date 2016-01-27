//
//  Coin.m
//  This is the End
//
//  Created by Ilhan Raja on 1/27/16.
//  Copyright © 2016 Ilhan-Parker. All rights reserved.
//

#import "Coin.h"
#import "GameScene.h"
#import "GameData.h"
NSString *kCoinActionAnimation = @"coinAnimation";
NSString *kCoinActionDisappear = @"coinDisappear";


@implementation Coin


-(instancetype)init{
    self = [super init];
    if(self){
        [self setImages];
    }
    return self;
}

-(void)setImages{
    NSMutableArray *textures = [NSMutableArray array];
    for(int i=1; i<=4; i++){
        NSString *imageName = [NSString stringWithFormat:@"Coin%d",i];
        [textures addObject:[SKTexture textureWithImageNamed:imageName]];
    }
    SKAction *action = [SKAction animateWithTextures:textures timePerFrame:0.2];
    action = [SKAction repeatActionForever:action];
    [self runAction:action withKey:kCoinActionAnimation];
    
}

-(void)activate{
    GameScene *scene = (GameScene*)self.scene;
    GameData *state = scene.state;
    state.coins = state.coins + 1;
    [self removeAllActions];
    self.physicsBody = nil;
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"sparkle1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"sparkle2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"sparkle3"];
    NSArray *textures = @[texture1, texture2, texture3];
    SKAction *disappear = [SKAction animateWithTextures:textures timePerFrame:0.2];
    SKAction *block = [SKAction runBlock:^{
        [self removeFromParent];
    }];
    SKAction *action = [SKAction sequence:@[disappear,block]];
    [self runAction:action withKey:kCoinActionDisappear];
}

@end
