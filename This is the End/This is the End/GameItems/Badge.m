//
//  Badge.m
//  This is the End
//
//  Created by Ilhan Raja on 7/13/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "Badge.h"
#import "GameScene.h"
#import "GameData.h"
#import "Player.h"

NSString *kBadgeActionDisappear = @"badgeDisappear";

@interface Badge () {

}


@end

@implementation Badge

-(instancetype)initWithType:(BadgeType)type{
    self = [super init];
    
    if(self){
        _type = type;
        NSString *badgeName = badges[type];
        self.texture = [SKTexture textureWithImageNamed:badgeName];
    }
    
    return self;
}

-(NSString*)getBadgeNameFromType{
    BadgeType type = self.type;
    return badges[type];
}


-(void)activate{
    GameScene *scene = (GameScene*)self.scene;
    GameData *state = scene.state;
    [state addBadge:self];
    [self removeAllActions];
    self.physicsBody = nil;
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"sparkle1"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"sparkle2"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"sparkle3"];
    NSArray *textures = @[texture1, texture2, texture3];
    SKAction *disappear = [SKAction animateWithTextures:textures timePerFrame:0.125];
    SKAction *block = [SKAction runBlock:^{
        [self removeFromParent];
    }];
    SKAction *action = [SKAction sequence:@[disappear,block]];
    [self runAction:action withKey:kBadgeActionDisappear];
}



@end
