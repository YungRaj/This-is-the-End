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

@interface PowerUp () {
    
}

@property (strong,nonatomic) NSArray *images;

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
    self.images = textures;
}

-(void)spawnNewItemAtPoint:(CGPoint)point{
    self.position = point;
    
}

-(void)activate{
    GameScene *scene = (GameScene*)self.scene;
    Player *player = scene.player;
    GameData *state = scene.state;
    if(self.type==Coin){
        state.coins = state.coins + 1;
        return;
    }
    
    
}

-(void)deactivate{
    
}

@end
