//
//  GameScene.m
//  This is the End
//
//  Created by Ilhan Raja on 7/17/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//


#import "GameAPI.h"
#import "GameScene.h"
#import "SKButton.h"
#import "GameInfoPanel.h"
#import "AppDelegate.h"
#import "GameInstanceVC.h"
#import "Player.h"
#import "Enemy.h"
#import "GameData.h"
#import "Bullet.h"
#import "Block.h"
#import "Platform.h"
#import "PowerUp.h"
#import "Badge.h"
#import "InterruptGameMenuVC.h"



@interface GameScene () <SKPhysicsContactDelegate> {
}

@end

@implementation GameScene


-(instancetype)initWithSize:(CGSize)size gameStateData:(GameData*)state{
    self = [super initWithSize:size];
    if(self){
        _state = state;
        _player = [Player loadPlayerInstance];
        _player.state = state;
        self.anchorPoint = CGPointMake(0.5,0.5);
        CGSize level = size;
        level.width*=20;
        _level = [SKSpriteNode node];
        _level.size = level;
        _level.position = CGPointMake(-size.width/2,0);
        CGSize buttonSize = CGSizeMake(size.width/8,
                                       size.height/6);
        CGSize childSize = CGSizeMake(buttonSize.width*.7,
                                      buttonSize.height*.7);
        CGSize pauseButtonSize = CGSizeMake(size.width/12,
                                            size.height/8);
        CGSize pauseSymbolSize = CGSizeMake(pauseButtonSize.width*2/3,
                                            pauseButtonSize.height*2/3);

        SKTexture *squareButton = [SKTexture textureWithImageNamed:@"squarebutton.png"];
        SKTexture *pause = [SKTexture textureWithImageNamed:@"pausesymbol.png"];
        SKTexture *arrow = [SKTexture textureWithImageNamed:@"arrow.png"];
        SKTexture *fireText = [SKTexture textureWithImageNamed:@"stormSix_fire.png"];
        SKTexture *jumpText = [SKTexture textureWithImageNamed:@"stormSix_jump.png"];
        _pause = [SKButton buttonWithTexture:squareButton
                                    withSize:pauseButtonSize
                                childTexture:pause
                                    withSize:pauseSymbolSize];
        _left = [SKButton buttonWithTexture:squareButton
                                   withSize:buttonSize
                               childTexture:arrow
                                   withSize:childSize];
        _right = [SKButton buttonWithTexture:squareButton
                                    withSize:buttonSize
                                childTexture:arrow
                                    withSize:childSize];
        _fire = [SKButton buttonWithTexture:squareButton
                                   withSize:buttonSize
                               childTexture:fireText
                                   withSize:childSize];
        _jump = [SKButton buttonWithTexture:squareButton
                                   withSize:buttonSize
                               childTexture:jumpText
                                   withSize:childSize];
        
    }
    return self;
}




-(void)didMoveToView:(SKView *)view{
    //view.showsPhysics = YES;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = delegate.window.rootViewController;
    if([[rootViewController.childViewControllers
        objectAtIndex:[rootViewController.childViewControllers count]-1]
        isKindOfClass:[GameInstanceVC class]]){
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            [self setUpPadScene];
        }else{
            [self setUpPhoneScene];
        }
    }
}

-(void)setUpPadScene{
    
}

#pragma mark Temporary Code for the levels while the plist is being worked on

-(void)setUpPhoneScene{
    self.physicsWorld.contactDelegate = self;
    int x = -self.size.width/2;
    SKTexture *first = [SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"background%d-1",self.state.worlds]ofType:@"png"]];
    SKTexture *second = [SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"background%d-2",self.state.worlds] ofType:@"png"]];
    SKTexture *third = [SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"background%d-3",self.state.worlds] ofType:@"png"]];
    for(int i=0; i<=21; i++){
        SKSpriteNode *background = [[SKSpriteNode alloc]
                                    initWithTexture:nil
                                    color:nil
                                    size:self.size];
        switch(i%3){
            case 0: background.texture = first; break;
            case 1: background.texture = second; break;
            case 2: background.texture = third; break;
        }
        background.position = CGPointMake(x,self.position.x);
        x+=self.size.width;
        [self.level addChild:background];
    }
    [self addChild:self.level];
    int numPlatforms = 0;
    CGRect platformFrame;
    platformFrame.size = CGSizeMake(self.size.width/6, self.size.height/16);
    x = self.size.width/12;
    for(int i=0; x<=self.level.size.width; i++){
        
        Enemy *enemy;
        switch(numPlatforms%8){
            case 3:
                enemy = [[Enemy alloc] initWithName:@"taserBot" size:CGSizeMake(self.size.width/6,
                                                                                self.size.height/5)
                                                                type:EnemyAlien];
                enemy.canMove = YES;
                enemy.canAttack = YES;
                break;
            case 7:
                enemy = [[Enemy alloc] initWithName:@"missileBot" size:CGSizeMake(self.size.width/6,
                                                                                  self.size.height/5)
                                                                  type:EnemyAlien];
                enemy.canMove = YES;
                enemy.canAttack = YES;
            // difference of number of platforms times the alien count minus one to get it on the last platform
                break;
            default: break;
        }
        numPlatforms++;
        if(numPlatforms%4==3){
            Block *mysteryBlock = [Block spriteNodeWithTexture:
                                          [SKTexture textureWithImageNamed:@"mysteryblock"]];
            mysteryBlock.type = BlockTypeMystery;
            mysteryBlock.size = CGSizeMake(self.size.height/8,self.size.height/8);
            CGPoint mysteryBlockPoint;
            mysteryBlockPoint.y = self.size.height/4+self.player.size.height*2;
            mysteryBlockPoint.x = x;
            mysteryBlock.position = mysteryBlockPoint;
            mysteryBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:mysteryBlock.size];
            mysteryBlock.physicsBody.categoryBitMask = blockMask;
           // mysteryBlock.physicsBody.collisionBitMask = playerMask;
           // mysteryBlock.physicsBody.contactTestBitMask = playerMask;
            mysteryBlock.physicsBody.mass = 3.0;
            mysteryBlock.physicsBody.dynamic = NO;
            mysteryBlock.physicsBody.allowsRotation = NO;
            [self.level addChild:mysteryBlock];
            
        }
        SKSpriteNode *platform = [Platform spriteNodeWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"platform%d",self.state.worlds]]];
        platform.position = CGPointMake(x+platformFrame.size.width/2,
                                        0-self.size.height/8-platformFrame.size.height/2);
        platform.size = platformFrame.size;
        platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(platformFrame.size.width,
                                                                                 platformFrame.size.height)];
        platform.physicsBody.categoryBitMask = platformMask;
        //platform.physicsBody.collisionBitMask = playerMask;
        //platform.physicsBody.contactTestBitMask = playerMask;
        platform.physicsBody.mass = 3.0;
        platform.physicsBody.dynamic = NO;
        platform.physicsBody.allowsRotation = NO;
        [self.level addChild:platform];
        if(enemy){
            enemy.physicsBody.categoryBitMask = enemyMask;
            //enemy.physicsBody.collisionBitMask = playerMask | platformMask;
            //enemy.physicsBody.contactTestBitMask = playerMask | platformMask;
            enemy.position = CGPointMake(platform.position.x,self.player.position.y);
            [self.level addChild:enemy];
        }
        if(numPlatforms%4==0)
            x+=self.size.width/3;
        else
            x+=platformFrame.size.width;
        
    }
    
    NSMutableArray *rectangles = [[NSMutableArray alloc] init];
    for(SKNode *node in self.level.children){
        uint32_t category = node.physicsBody.categoryBitMask;
        if(category==platformMask ||
           category==blockMask){
            [rectangles addObject:node];
        }
    }
    self.rectangles = rectangles;
    
    // temporary code to add platforms while levels are being worked on
    self.world = [[GameInfoPanel alloc] initWithType:GameInfoPanelTypeWorld
                                            position:CGPointMake(self.size.width/4-self.size.width/2,
                                                                 self.size.height/2-self.size.height/24)
                                                size:CGSizeMake(self.size.width/6,self.size.height/24)
                                               state:self.state];
    self.currentLevel = [[GameInfoPanel alloc] initWithType:GameInfoPanelTypeLevel
                                                position:CGPointMake(self.size.width/4-self.size.width/2,
                                                                     self.size.height/2-self.size.height/8)
                                                size:CGSizeMake(self.size.width/6,self.size.height/24)
                                               state:self.state];
    self.lives = [[GameInfoPanel alloc] initWithType:GameInfoPanelTypeLives
                                                position:CGPointMake(self.size.width*.45-self.size.width/2,
                                                                     self.size.height/2-self.size.height/24)
                                                size:CGSizeMake(self.size.width/5.5,self.size.height/24)
                                               state:self.state];
    self.health = [[GameInfoPanel alloc] initWithType:GameInfoPanelTypeHealth
                                                position:CGPointMake(self.size.width*.45-self.size.width/2,
                                                                     self.size.height/2-self.size.height/8)
                                                 size:CGSizeMake(self.size.width/5,self.size.height/24)
                                                state:self.state];
    self.score = [[GameInfoPanel alloc] initWithType:GameInfoPanelTypeScore
                                                position:CGPointMake(self.size.width/2-self.size.width/3.85,
                                                                     self.size.height/2-self.size.height/24)
                                                size:CGSizeMake(self.size.width/2.5,self.size.height/24)
                                               state:self.state];
    self.coins = [[GameInfoPanel alloc] initWithType:GameInfoPanelTypeCoins
                                                position:CGPointMake(self.size.width/2-self.size.width/5,
                                                                     self.size.height/2-self.size.height/8)
                                                size:CGSizeMake(self.size.width/4,self.size.height/24)
                                               state:self.state];
    // this is used to test the automatic sizing in the GameInfoPanels
    
    /*self.world.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.world.size];
    self.world.physicsBody.affectedByGravity = NO;
    self.world.physicsBody.collisionBitMask = 0;
    
    self.score.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.score.size];
    self.score.physicsBody.affectedByGravity = NO;
    self.score.physicsBody.collisionBitMask = 0;
    
    self.lives.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.lives.size];
    self.lives.physicsBody.affectedByGravity = NO;
    self.lives.physicsBody.collisionBitMask = 0;
    
    self.coins.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.coins.size];
    self.coins.physicsBody.affectedByGravity = NO;
    self.coins.physicsBody.collisionBitMask = 0;
    
    self.level.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.level.size];
    self.level.physicsBody.affectedByGravity = NO;
    self.level.physicsBody.collisionBitMask = 0;
    
    self.health.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.health.size];
    self.health.physicsBody.affectedByGravity = NO;
    self.health.physicsBody.collisionBitMask = 0;
    self.view.showsPhysics = YES;*/
    
    self.physicsWorld.gravity = CGVectorMake(0, -self.size.height/187.5);
    
    CGSize size = self.frame.size;
    
    self.player.size = CGSizeMake(size.width/6,
                                  size.height/4);
    
    self.player.position = [self.level
                            convertPoint:CGPointMake(self.player.size.width*.175,.05)
                                fromNode:self];
    
    [self.level addChild:self.player];
    
    self.left.contents.zRotation = M_PI/2;
    self.right.contents.zRotation = 3*M_PI/2;
    
    self.pause.position = CGPointMake(size.width/12-size.width/2,
                                      size.height/1.1-size.height/2);
    self.left.position = CGPointMake(size.width/1.5-size.width/2,
                                     size.height/12-size.height/2);
    self.right.position = CGPointMake((size.width/1.5)+self.left.size.width*1.5-self.size.width/2,
                                      size.height/12-size.height/2);
    self.fire.position = CGPointMake(size.width/8-size.width/2,
                                     size.height/12-size.height/2);
    self.jump.position = CGPointMake(size.width/3.5-size.width/2,
                                     size.height/12-size.height/2);
    
    self.left.alpha = 0.6;
    self.right.alpha = 0.6;
    self.fire.alpha = 0.6;
    self.jump.alpha = 0.6;
    
    [self addChild:self.pause];
    [self addChild:self.left];
    [self addChild:self.right];
    [self addChild:self.fire];
    [self addChild:self.jump];
    [self addChild:self.world];
    [self addChild:self.currentLevel];
    [self addChild:self.lives];
    [self addChild:self.health];
    [self addChild:self.score];
    [self addChild:self.coins];
    
    self.player.physicsBody =
    [SKPhysicsBody
     bodyWithRectangleOfSize:CGSizeMake(self.player.size.width*.3,
                                        self.player.size.height)
     center:[self.level convertPoint:CGPointMake(self.player.position.x-self.player.size.width*.175,
                                           self.player.position.y)
                        toNode:self.player]];
    
    self.player.physicsBody.categoryBitMask = playerMask;
    self.player.physicsBody.collisionBitMask = platformMask | levelMask | enemyMask | blockMask;
    self.player.physicsBody.contactTestBitMask = platformMask | levelMask | enemyMask | blockMask;
    self.player.physicsBody.allowsRotation = NO;
    self.player.physicsBody.mass = 1.0;
    
}

-(void)willMoveFromView:(SKView *)view{
    [self cleanUpGameScene];
}


-(void)didFinishUpdate{
    [self centerOnNode:[self.level childNodeWithName:@"stormSix"]];
}

-(void)didSimulatePhysics{
    [self centerOnNode:[self.level childNodeWithName:@"stormSix"]];
}

-(void)centerOnNode:(SKNode *) node{
    CGPoint cameraPositionInScene =
                     [node.scene convertPoint:CGPointMake(node.position.x-(node.xScale*node.frame.size.width*.175),
                                                          node.position.y)
                                     fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x-cameraPositionInScene.x,
                                       node.parent.position.y);
}

-(void)update:(NSTimeInterval)currentTime{
    printf("%ld\n",[self.state numItems]);
    UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState];
    if(applicationState == UIApplicationStateBackground
       || applicationState == UIApplicationStateInactive){
        [self pauseGame];
    }if([self.player actionForKey:kPlayerActionDeath]){
        return;
    }
    [self.player action];
}



-(void)didBeginContact:(SKPhysicsContact*)contact{
    uint32_t bodyACategory = contact.bodyA.categoryBitMask;
    uint32_t bodyBCategory = contact.bodyB.categoryBitMask;
    SKNode *player;
    SKNode *platform;
    SKNode *level;
    SKNode *enemy;
    SKNode *block;
    SKNode *bullet;
    SKNode *item;
    if(bodyACategory==playerMask){
        player = contact.bodyA.node;
    }else if(bodyBCategory==playerMask){
        player = contact.bodyB.node;
    }if(bodyACategory==platformMask){
        platform = contact.bodyA.node;
    }else if(bodyBCategory==platformMask){
        platform = contact.bodyB.node;
    }if(bodyACategory==levelMask){
        level = contact.bodyA.node;
    }else if(bodyBCategory==levelMask){
        level = contact.bodyB.node;
    }if(bodyACategory==enemyMask){
        enemy = contact.bodyA.node;
    }else if(bodyBCategory==enemyMask){
        enemy = contact.bodyB.node;
    }if(bodyACategory==blockMask){
        block = contact.bodyA.node;
    }else if(bodyBCategory==blockMask){
        block = contact.bodyB.node;
    }if(bodyACategory==bulletMask){
        bullet = contact.bodyA.node;
    }else if(bodyBCategory==bulletMask){
        bullet = contact.bodyB.node;
    }if(bodyACategory==itemMask){
        item = contact.bodyA.node;
    }else if(bodyBCategory==itemMask){
        item = contact.bodyB.node;
    }
    if(player && platform){
        /*CGPoint playerPosition = CGPointMake(player.position.x-(player.frame.size.width*.175*player.xScale),
                                             player.frame.origin.y);
        CGFloat centerOfPlayer = playerPosition.x;
        CGFloat bottomOfPlayer = playerPosition.y;
        
        CGPoint platformPosition = platform.position;
        CGFloat leftOfPlatform = platformPosition.x-platform.frame.size.width/2;
        CGFloat rightOfPlatform = platformPosition.x+platform.frame.size.width/2;*/
        //printf("%f %f %f n\n\n\n",bottomOfPlayer,centerOfPlayer,leftOfPlatform);
        
    }else if(player && level){
        
    }else if(player && enemy){
        if(player.frame.origin.y >= enemy.position.y){
            if([enemy conformsToProtocol:@protocol(MovingObject)]){
                [(SKNode<MovingObject>*)enemy death];
                self.state.kills = self.state.kills+1;
            }
            self.player.isStanding = NO;
            if(self.player.currentState==PlayerStateStanding){
                self.player.currentState = PlayerStateIdle;
            }
        } else{
            [self.player death];
        }
    }else if(bullet){
        if([bullet isKindOfClass:[Bullet class]]){
            if(enemy){
                if([enemy conformsToProtocol:@protocol(MovingObject)]){
                    [(SKNode<MovingObject>*)enemy death];
                    self.state.kills = self.state.kills+1;
                    [bullet removeFromParent];
                }
            }else{
                [(Bullet*)bullet explode];
            }
            [((Bullet*)bullet).delegate removeBullet:(Bullet*)bullet];
        }
    }else if(player && block){
        CGPoint playerPosition = CGPointMake(player.position.x-(player.frame.size.width*.175*player.xScale),
                                             player.frame.origin.y);
        CGFloat centerOfPlayer = playerPosition.x;
        CGFloat bottomOfPlayer = playerPosition.y;
        
        CGPoint blockPosition = block.position;
        CGFloat bottomOfBlock = blockPosition.y-block.frame.size.height/2;
        CGFloat leftOfBlock = blockPosition.x-block.frame.size.width/2;
        CGFloat rightOfBlock = blockPosition.x+block.frame.size.width/2;
    
        
        if(centerOfPlayer>=leftOfBlock
                  && centerOfPlayer<=rightOfBlock
                  && bottomOfPlayer < bottomOfBlock){
            //printf("Activate block wherever applicable\n");
            if([block isKindOfClass:[Block class]]){
                [(Block*)block activateBlock];
            }
        }
        self.player.isStanding = NO;
        self.player.currentState = PlayerStateIdle;
        [self.player removeActionForKey:kPlayerActionJump];
    }else if(player && item){
        if([item isKindOfClass:[PowerUp class]]){
            PowerUp *powerUp = (PowerUp*)item;
            [powerUp activate];
        }else if([item isKindOfClass:[Badge class]]){
            Badge *badge = (Badge*)item;
            [badge activate];
        }
    }
}

-(void)didEndContact:(SKPhysicsContact*)contact{
    uint32_t bodyACategory = contact.bodyA.categoryBitMask;
    uint32_t bodyBCategory = contact.bodyB.categoryBitMask;
    SKNode *player;
    SKNode *platform;
    SKNode *level;
    SKNode *enemy;
    SKNode *block;
    SKNode *bullet;
    SKNode *item;
    if(bodyACategory==playerMask){
        player = contact.bodyA.node;
    }else if(bodyBCategory==playerMask){
        player = contact.bodyB.node;
    }if(bodyACategory==platformMask){
        platform = contact.bodyA.node;
    }else if(bodyBCategory==platformMask){
        platform = contact.bodyB.node;
    }if(bodyACategory==levelMask){
        level = contact.bodyA.node;
    }else if(bodyBCategory==levelMask){
        level = contact.bodyB.node;
    }if(bodyACategory==enemyMask){
        enemy = contact.bodyA.node;
    }else if(bodyBCategory==enemyMask){
        enemy = contact.bodyB.node;
    }if(bodyACategory==blockMask){
        block = contact.bodyA.node;
    }else if(bodyBCategory==blockMask){
        block = contact.bodyB.node;
    }if(bodyACategory==bulletMask){
        bullet = contact.bodyA.node;
    }else if(bodyBCategory==bulletMask){
        bullet = contact.bodyB.node;
    }if(bodyACategory==itemMask){
        item = contact.bodyA.node;
    }else if(bodyBCategory==itemMask){
        item = contact.bodyB.node;
    }/*
    if(player && platform){
        CGPoint playerPosition = CGPointMake(player.position.x-(player.frame.size.width*.175*player.xScale),
                                             player.frame.origin.y);
        CGFloat centerOfPlayer = playerPosition.x;
        CGFloat bottomOfPlayer = playerPosition.y;
        
        CGPoint topOfPlatform =
        [self.level convertPoint:CGPointMake(platform.position.x,platform.position.y+platform.frame.size.height/2)
                          toNode:self];
    
        
        SKNode *node = [self nodeAtPoint:CGPointMake(centerOfPlayer,platform.position.y)];
        if((bottomOfPlayer >= topOfPlatform.y
            && [player actionForKey:kPlayerActionJump])
           || node.physicsBody.categoryBitMask!=platformMask){
            //printf("Player is not standing\n\n\n");
            isPlayerStanding = NO;
            if(self.player.currentState==PlayerStateStanding){
                self.player.currentState = PlayerStateIdle;
            }
        }
    } else*/ if(player && level){
        self.player.isStanding = NO;
        if(self.player.currentState==PlayerStateStanding){
            self.player.currentState = PlayerStateIdle;
        }
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        CGPoint point = [touch locationInNode:self];
        if(CGRectContainsPoint(self.pause.frame,point)){
            [self performSelector:@selector(pauseGame) withObject:nil afterDelay:1/FRAME_RATE];
        }
    }
}

-(void)gameOver{
    self.view.paused = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGameNotificationOver object:nil];
}

-(void)pauseGame{
    self.view.paused = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGameNotificationPause object:nil];
}


-(void)cleanUpGameScene{
    [self.children makeObjectsPerformSelector:@selector(removeAllActions)];
    [self removeAllChildren];
    [self removeFromParent];
}

-(void)dealloc{
    [self cleanUpGameScene];
}


@end
