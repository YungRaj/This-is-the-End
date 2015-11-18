//
//  Badge.m
//  This is the End
//
//  Created by Ilhan Raja on 7/13/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "Badge.h"
#import "GameScene.h"
#import "Player.h"

@interface Badge () {

}

@property (strong,nonatomic) NSArray *images;

@end

@implementation Badge

-(instancetype)initWithType:(BadgeType)type{
    self = [super init];
    
    if(self){
        _type = type;
    }
    
    return self;
}

-(NSString*)getBadgeNameFromType{
    BadgeType type = self.type;
    return badges[type];
}

-(void)setImages{
    BadgeType type = self.type;
    NSString *badgeName = badges[type];
    NSMutableArray *textures = [NSMutableArray array];
    for(int i=1; i<=4; i++){
        NSString *imageName = [NSString stringWithFormat:@"%@%d",badgeName,i];
        [textures addObject:[SKTexture textureWithImageNamed:imageName]];
    }
    self.images = textures;
}

-(void)activate{
    GameScene *scene = (GameScene*)self.scene;
    GameData *state = scene.state;
    Player *player = scene.player;
    
}

-(void)deactivate{
    
}



@end
