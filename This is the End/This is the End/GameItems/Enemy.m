//
//  Enemy.m
//  This is the End
//
//  Created by Ilhan Raja on 8/21/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy


-(instancetype)initWithName:(NSString*)name size:(CGSize)size type:(EnemyType)type{
    SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_stand.png",name]];
    self = [super initWithTexture:texture
                          color:[SKColor clearColor]
                          size:size];
    self.physicsBody = [SKPhysicsBody bodyWithTexture:texture size:size];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = 3.0;
    if(self){
        _enemyType = type;
        self.name = name;
    }
    return self;
}

-(void)action{
    
}

-(void)move{
    
}

-(void)attack{
    
}

-(void)moveAndAttack{
    
}

-(void)jump{
    
}

-(void)death{
    if(self.enemyType==EnemyAlien){
        NSMutableArray *death = [[NSMutableArray alloc] init];
        for(int i=1; i<=6; i++){
            SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion_%d",i]];
            [death addObject:texture];
        }
        self.size = CGSizeMake(self.size.width,self.size.width);
        self.physicsBody = nil;
        SKAction *deathAnimation = [SKAction animateWithTextures:death timePerFrame:0.2];
        SKAction *completion = [SKAction runBlock:^{
            [self performSelector:@selector(removeFromParent) withObject:nil];
        }];
        SKAction *deathSequence = [SKAction sequence:@[deathAnimation,completion]];
        [self runAction:deathSequence];
        // add a key if necessary to keep track of deaths of enemies 
    } 
}

@end
