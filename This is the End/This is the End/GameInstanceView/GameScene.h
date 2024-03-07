//
//  GameScene.h
//  This is the End
//
//  Created by Ilhan Raja on 7/17/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameInfoPanel;
@class SKButton;
@class GameData;
@class Player;

@interface GameScene : SKScene

@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) GameData *state;
@property (strong, nonatomic) GameInfoPanel *score;
@property (strong, nonatomic) GameInfoPanel *world;
@property (strong, nonatomic) GameInfoPanel *lives;
@property (strong, nonatomic) GameInfoPanel *coins;
@property (strong, nonatomic) GameInfoPanel *health;
@property (strong, nonatomic) GameInfoPanel *currentLevel;
@property (strong, nonatomic) SKSpriteNode *level;
@property (strong, nonatomic) SKButton *pause;
@property (strong, nonatomic) SKButton *left;
@property (strong, nonatomic) SKButton *right;
@property (strong, nonatomic) SKButton *fire;
@property (strong, nonatomic) SKButton *jump;
@property (strong, nonatomic) NSMutableArray *rectangles;

- (instancetype)initWithSize:(CGSize)size gameStateData:(GameData *)state;
- (void)pauseGame;
- (void)gameOver;

@end
