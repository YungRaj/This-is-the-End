//
//  Bullet.m
//  This is the End
//
//  Created by Ilhan Raja on 9/2/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "Bullet.h"
#import "GameAPI.h"
#import "GameScene.h"

@implementation Bullet

- (instancetype)initWithName:(NSString *)name size:(CGSize)size
{
    SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@.png", name]];

    self = [super initWithTexture:texture color:[SKColor clearColor] size:size];

    self.physicsBody = [SKPhysicsBody bodyWithTexture:texture size:size];

    self.physicsBody.allowsRotation = NO;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.mass = 0.5;

    if (self) {
        self.name = name;
    }

    return self;
}

- (void)shootAtPoint:(CGPoint)point
{
    SKPhysicsBody *body = [self.scene.physicsWorld bodyAtPoint:point];

    if (!body || (body.categoryBitMask | enemyMask)) {
        self.position = point;
        self.physicsBody.velocity = CGVectorMake(400 * self.xScale, 0);
    } else {
        self.physicsBody = nil;
        self.texture = nil;
        self.position = point;
        [self explode];
    }
}

- (void)explode
{
    NSMutableArray *death = [[NSMutableArray alloc] init];

    for (int i = 1; i <= 6; i++) {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion_%d", i]];

        [death addObject:texture];
    }

    GameScene *scene = (GameScene *)self.scene;

    SKSpriteNode *explode = [SKSpriteNode node];

    explode.position = [scene convertPoint:self.position toNode:scene.level];
    explode.size = CGSizeMake(self.size.width, self.size.width);

    self.physicsBody = nil;

    SKAction *explosionSprite = [SKAction runBlock:^{
      [scene.level addChild:explode];

      SKAction *deathAnimation = [SKAction animateWithTextures:death timePerFrame:0.2];

      SKAction *removeExplosion = [SKAction runBlock:^{
        [explode performSelector:@selector(removeFromParent) withObject:nil];
      }];

      SKAction *explosion = [SKAction sequence:@[ deathAnimation, removeExplosion ]];

      [explode runAction:explosion];
    }];

    SKAction *removeFromParent = [SKAction runBlock:^{
      [self performSelector:@selector(removeFromParent) withObject:nil];
      [self.delegate removeBullet:self];
    }];

    SKAction *explosionSequence = [SKAction sequence:@[ explosionSprite, removeFromParent ]];

    [self runAction:explosionSequence];
}

@end
