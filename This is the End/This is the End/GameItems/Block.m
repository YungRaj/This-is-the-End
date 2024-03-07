//
//  Block.m
//  This is the End
//
//  Created by Ilhan Raja on 9/11/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "Block.h"
#import "Badge.h"
#import "Coin.h"
#import "GameAPI.h"
#import "GameScene.h"
#import "PowerUp.h"

NSString *kBlockActionActivate = @"activate";

@implementation Block

- (void)activateBlock
{
    if (!self.isActivated) {
        self.isActivated = YES;

        if (self.type == BlockTypeMystery) {
            SKTexture *texture1 = [SKTexture textureWithImageNamed:@"mysteryblock1"];
            SKTexture *texture2 = [SKTexture textureWithImageNamed:@"mysteryblock2"];
            SKTexture *texture3 = [SKTexture textureWithImageNamed:@"mysteryblock3"];

            SKAction *activateBlock = [SKAction animateWithTextures:@[ texture1, texture2, texture3 ] timePerFrame:.1];

            [self runAction:activateBlock withKey:kBlockActionActivate];

            CGPoint currentPosition = self.position;
            CGSize itemSize = CGSizeMake(self.size.width / 1.475, self.size.height / 1.5);
            CGPoint itemPosition =
                CGPointMake(currentPosition.x, currentPosition.y + self.size.width / 2 + itemSize.height / 2);

            SKSpriteNode<CollectableItem> *item = randomItem();

            item.position = itemPosition;
            item.size = itemSize;

            if ([item isKindOfClass:[Badge class]]) {
                Badge *badge = (Badge *)item;

                NSString *name = badges[badge.type];

                badge.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:name]
                                                              size:badge.size];
            } else if ([item isKindOfClass:[PowerUp class]]) {
                PowerUp *powerUp = (PowerUp *)item;

                NSString *name = [NSString stringWithFormat:@"%@1", powerUps[powerUp.type]];

                powerUp.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:name]
                                                                size:powerUp.size];
            } else if ([item isKindOfClass:[Coin class]]) {
                Coin *coin = (Coin *)item;

                coin.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:@"Coin1"]
                                                             size:coin.size];
            }

            switch (arc4random() % 2) {
                case 0:
                    item.physicsBody.velocity = CGVectorMake(item.size.width * 2, 0);
                    break;
                case 1:
                    item.physicsBody.velocity = CGVectorMake(-item.size.width * 2, 0);
                    break;
            }

            item.physicsBody.dynamic = YES;
            item.physicsBody.categoryBitMask = itemMask;
            item.physicsBody.contactTestBitMask = 0xFFFFFFFF ^ itemMask;
            item.physicsBody.allowsRotation = NO;
            item.physicsBody.friction = 0;

            [((GameScene *)self.scene).level addChild:item];
        }
    }
}


@end
