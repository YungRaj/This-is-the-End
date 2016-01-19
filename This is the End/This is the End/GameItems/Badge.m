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
    [self removeFromParent];
    
    
}



@end
