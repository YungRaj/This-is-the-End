//
//  Player.m
//  This is the End
//
//  Created by Ilhan Raja on 7/7/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "GameAPI.h"
#import "Achievement.h"
#import "GameData.h"
#import "MovingObject.h"
#import "Player.h"
#import "GameScene.h"
#import "Bullet.h"
#import "SKButton.h"

NSString *kPlayerActionJump = @"jump";
NSString *kPlayerActionWalk = @"walk";
NSString *kPlayerActionFire = @"fire";
NSString *kPlayerActionWalkAndFire = @"walkAndFire";
NSString *kPlayerActionReturnToOriginalPosition = @"returnToOriginalPosition";
NSString *kPlayerActionDeath = @"death";

@interface Player ()
{
    
}

@property (strong,nonatomic) NSMutableArray *achievements;

@end

@implementation Player



static NSString* const highScoreKey = @"highScore";
static NSString* const achievementsKey = @"achievements";

-(instancetype)init
{
    self = [super
            initWithTexture:[SKTexture textureWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"stormSix_standing_1" ofType:@"png"]]]
            color:[SKColor whiteColor]
            size:CGSizeMake(0,0)];
    
    if(self)
    {
        _achievements = [[NSMutableArray alloc] init];
        _bullets = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [super
            initWithTexture:[SKTexture textureWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"stormSix_standing_1" ofType:@"png"]]]
            color:[SKColor whiteColor]
            size:CGSizeMake(0,0)];
    
    if(self)
    {
        _highScore = [decoder decodeInt64ForKey:highScoreKey];
        _achievements = [decoder decodeObjectForKey:achievementsKey];
    }
    
    return self;
}


+(instancetype)loadPlayerInstance
{
    Player *playerInstance;
    
    NSData *decodedData = [NSData dataWithContentsOfFile:[self filePath]];
    
    if (decodedData)
    {
        playerInstance = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        playerInstance.name = @"stormSix";
        return playerInstance;
    }
    
    playerInstance = [[self alloc] init];
    playerInstance.name = @"stormSix";
    
    return playerInstance;
}

+(NSString*)filePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ]stringByAppendingPathComponent:@"player"];
}

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInt64:self.highScore forKey:highScoreKey];
    [encoder encodeObject:self.achievements forKey:achievementsKey];
}

-(void)savePlayer
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[Player filePath] atomically:YES];
}

-(void)addAchievement:(Achievement *)achievment
{
    [self.achievements addObject:achievment];
    
    [GKAchievement reportAchievements:[NSArray arrayWithArray:self.achievements] withCompletionHandler:^(NSError *error) {
        
    }];
}


-(void)action
{
    GameScene *scene = (GameScene*)self.scene;
    
    if(![self intersectsNode:scene])
    {
        [scene gameOver];
    }
    
    CGFloat playerVelocityY = self.physicsBody.velocity.dy;
    // CGFloat playerVelocityX = self.physicsBody.velocity.dx;

    if(!(fabs(playerVelocityY) > 0.000005))
    {
        // due to floating point precision this type of check is necessary 
        self.isStanding = YES;
        
        if(self.currentState==PlayerStateIdle)
        {
            self.currentState = PlayerStateStanding;
        }
        
    }else if(playerVelocityY)
    {
        self.isStanding = NO;
        
        if(self.currentState==PlayerStateStanding)
        {
            self.currentState = PlayerStateIdle;
        }
    }
    
    BOOL isRightSelected = scene.right.isSelected;
    BOOL isLeftSelected = scene.left.isSelected;
    
    CGFloat currentXScale = scene.player.xScale;
   
    if(isRightSelected && !isLeftSelected)
    {
        if(currentXScale != 1.0)
        {
            self.xScale = 1.0;
        } else
        {
            CGVector velocity = CGVectorMake(self.size.width*(18*FRAME_RATE/667),playerVelocityY);
            
            if(checkAllCollisions(self))
            {
                self.physicsBody.velocity = CGVectorMake(0,playerVelocityY);
            } else
            {
                self.physicsBody.velocity = velocity;
            }
        }
    }else if(isLeftSelected && !isRightSelected)
    {
        if(currentXScale != -1.0)
        {
            self.xScale = -1.0;
        } else
        {
            CGVector velocity =
                CGVectorMake(self.size.width*(18*FRAME_RATE/667)*xScaleNegativeDirectionFromIOSVersion(),
                             playerVelocityY);
            
            if(checkAllCollisions(self))
            {
                self.physicsBody.velocity = CGVectorMake(0,playerVelocityY);
            } else
            {
                self.physicsBody.velocity = velocity;
            }
        }
    }else if(!isLeftSelected && !isRightSelected)
    {
        self.physicsBody.velocity = CGVectorMake(0,playerVelocityY);
    }
    
    BOOL wantsToMove = scene.left.isSelected ^ scene.right.isSelected;
    
    BOOL fire = scene.fire.isSelected;
    BOOL jump = scene.jump.isSelected;
    
    BOOL isPlayerStanding = self.isStanding;
    // //printf("Player State %d\n",self.currentState);
    switch(self.currentState)
    {
        case PlayerStateStanding:
            if(wantsToMove && fire)
            {
                [self moveAndAttack];
                
                self.currentState = PlayerStateFireAndWalking;
            } else if(wantsToMove)
            {
                [self move];
                
                self.currentState = PlayerStateWalking;
            } else if(fire)
            {
                [self attack];
                
                self.currentState = PlayerStateFire;
            } else if(jump)
            {
                [self jump];
                
                self.currentState = PlayerStateJumping;
            }
            
            break;
        case PlayerStateIdle:
            if(wantsToMove && fire)
            {
                [self moveAndAttack];
                
                self.currentState = PlayerStateFireAndWalking;
            } else if(wantsToMove)
            {
                [self move];
                
                self.currentState = PlayerStateWalking;
            } else if(!wantsToMove && !fire)
            {
                self.texture = [SKTexture textureWithImageNamed:@"stormSix_standing_1.png"];
            } else if(fire)
            {
                [self attack];
                
                self.currentState = PlayerStateFire;
            }
            
            break;
        case PlayerStateFire:
            if(wantsToMove && fire)
            {
                [self moveAndAttack];
                
                self.currentState = PlayerStateFireAndWalking;
            } else if(wantsToMove && !fire)
            {
                [self move];
                
                self.currentState = PlayerStateWalking;
            } else if(jump && isPlayerStanding && !fire)
            {
                [self jump];
                
                self.currentState = PlayerStateJumping;
            }
            
            break;
        case PlayerStateFireAndWalking:
            if(!wantsToMove && fire)
            {
                [self attack];
                self.currentState = PlayerStateFire;
            } else if(wantsToMove && !fire)
            {
                self.shouldExitMoveAndAttack = YES;
                
                [self move];
                
                self.currentState = PlayerStateWalking;
            } else if(!wantsToMove && !fire)
            {
                [self removeActionForKey:kPlayerActionWalkAndFire];
                [self updateState];
                self.texture = [SKTexture textureWithImageNamed:@"stormSix_standing_1.png"];
            } else if(jump && isPlayerStanding)
            {
                [self jump];
                
                self.currentState = PlayerStateJumping;
            }
            
            break;
        case PlayerStateWalking:
            if(wantsToMove && fire)
            {
                [self moveAndAttack];
                
                self.currentState = PlayerStateFireAndWalking;
            }else if(!wantsToMove && fire)
            {
                [self attack];
                
                self.currentState = PlayerStateFire;
            }else if(!wantsToMove && !fire)
            {
                [self removeActionForKey:kPlayerActionWalk];
                
                [self updateState];
                
                self.texture = [SKTexture textureWithImageNamed:@"stormSix_standing_1.png"];
            }else if(jump && isPlayerStanding)
            {
                [self jump];
                
                self.currentState = PlayerStateJumping;
            }
            
            break;
        case PlayerStateJumping:
            if(wantsToMove && fire)
            {
                [self moveAndAttack];
                
                self.currentState = PlayerStateFireAndWalking;
            }else if(!wantsToMove && fire)
            {
                [self attack];
                
                self.currentState = PlayerStateFire;
            }
            
            break;
    }
    
    [self trashBullets];
    
    // this is fucking bullshit down here lmaoo
    
    /*if(![self actionForKey:kPlayerActionReturnToOriginalPosition]
     && ([self actionForKey:kPlayerActionWalk] || [self actionForKey:kPlayerActionWalkAndFire])
     && [scene isPlayerStanding]){
     if(self.xScale==1.0f && self.position.x!=scene.size.width/2+self.size.width*.175){
     previousPoint  = self.position;
     SKAction *action = [SKAction moveToX:scene.size.width/2+self.size.width*.175 duration:1.5];
     [self runAction:action withKey:kPlayerActionReturnToOriginalPosition];
     }else if(self.xScale==-1.0f && self.position.x!=scene.size.width/2-self.size.width*.175){
     previousPoint = self.position;
     SKAction *action = [SKAction moveToX:scene.size.width/2-self.size.width*.175 duration:1.5];
     [self runAction:action withKey:kPlayerActionReturnToOriginalPosition];
     }
     }if(!CGRectIntersectsRect(scene.frame, self.frame)){
     [scene gameOver];
     }if((![self actionForKey:kPlayerActionWalk] || [self actionForKey:kPlayerActionWalk].speed)
     && ([self actionForKey:kPlayerActionWalkAndFire]
     || [self actionForKey:kPlayerActionReturnToOriginalPosition])
     && (!scene.fire.isSelected || (!scene.right.isSelected && !scene.left.isSelected))){
     if([self actionForKey:kPlayerActionWalkAndFire]
     && !scene.fire.isSelected && (scene.right.isSelected || scene.left.isSelected)){
     //////printf("Action walk is initialized\n");
     self.shouldExitMoveAndAttack = YES;
     } else if(!scene.right.isSelected && !scene.left.isSelected){
     //////printf("Action walk and fire removed, walk is initialized %d\n",self.shouldExitMoveAndAttack);
     self.shouldExitMoveAndAttack = NO;
     [self removeActionForKey:kPlayerActionWalkAndFire];
     [self removeActionForKey:kPlayerActionReturnToOriginalPosition];
     }
     }if(!self.shouldExitMoveAndAttack
     && [self actionForKey:kPlayerActionWalk].speed==0.0
     && ([self actionForKey:kPlayerActionWalk] ||
     (!scene.fire.isSelected &&
     (scene.right.isSelected || scene.left.isSelected)))){
     SKAction *walk = [self actionForKey:kPlayerActionWalk];
     walk.speed = 1.0;
     }if(![self actionForKey:kPlayerActionJump] && scene.jump.isSelected && [scene isPlayerStanding]){
     [self removeAllActions];
     [self jump];
     }else if(scene.fire.isSelected &&
     (scene.right.isSelected || scene.left.isSelected) &&
     ![self actionForKey:kPlayerActionJump] &&
     (![self actionForKey:kPlayerActionWalkAndFire] ^
     (![self actionForKey:kPlayerActionWalkAndFire] &&
     [self actionForKey:kPlayerActionWalk] &&
     ([self actionForKey:kPlayerActionWalk].speed==0.0)))){
     //////printf("MOVE AND ATTACK\n\n\n");
     [self moveAndAttack];
     }else if(scene.fire.isSelected &&
     ![self actionForKey:kPlayerActionFire] &&
     ![self actionForKey:kPlayerActionWalkAndFire] &&
     ![self actionForKey:kPlayerActionJump]){
     //////printf("ATTACK\n\n");
     [self attack];
     }else if((scene.right.isSelected || scene.left.isSelected) &&
     ![self actionForKey:kPlayerActionWalk] &&
     ![self actionForKey:kPlayerActionWalkAndFire] &&
     ![self actionForKey:kPlayerActionJump]){
     [self move];
     }if(!scene.fire.isSelected && !scene.right.isSelected && !scene.left.isSelected){
     [self removeActionForKey:kPlayerActionReturnToOriginalPosition];
     [self removeActionForKey:kPlayerActionWalk];
     self.texture = [SKTexture textureWithImageNamed:@"stormSix_standing_1"];
     }
     [self trashBullets];*/
}

-(void)move
{
    if(self.shouldExitMoveAndAttack || [self actionForKey:kPlayerActionWalk])
    {
        return;
    }
    
    [self removeAllActions];
    
    NSMutableArray *walkTextures = [[NSMutableArray alloc] init];
    
    for(int i = 1; i <= 8; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_walkP_%d",i]];
        
        [walkTextures addObject:texture];
    }
    
    SKAction *walk1 = [SKAction animateWithTextures:walkTextures timePerFrame:.2];
    SKAction *walk2 = [SKAction runBlock:^{
        [self updateState];
    }];
    
    SKAction *sequence = [SKAction sequence:@[walk1,walk2]];
    
    [self runAction:sequence withKey:kPlayerActionWalk];
}

-(void)attack
{
    if([self actionForKey:kPlayerActionFire])
    {
        return;
    }
    
    [self removeAllActions];
    
    NSMutableArray *fireTextures = [[NSMutableArray alloc] init];
    
    for(int i = 1; i <= 2; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_standing_%d",i]];
        
        [fireTextures addObject:texture];
    }
    
    SKAction *bullet = [SKAction runBlock:^{
        Bullet *bullet = [[Bullet alloc] initWithName:@"player_bullet" size:
                          CGSizeMake(self.size.height/4,self.size.height/6)];
        
        bullet.delegate = self;
        
        bullet.xScale = self.xScale;
        bullet.physicsBody.categoryBitMask = bulletMask;
        bullet.physicsBody.collisionBitMask = platformMask | enemyMask | playerMask | blockMask;
        bullet.physicsBody.contactTestBitMask = platformMask | enemyMask | playerMask | blockMask;
        
        CGPoint shootPoint;
        
        if(xScaleNegativeDirectionFromIOSVersion() == 1)
        {
            shootPoint = CGPointMake(self.position.x+self.size.width*.35,
                                     self.position.y);
        } else
        {
            shootPoint = CGPointMake(self.position.x+(self.xScale*self.size.width*.35),
                                         self.position.y);
        }
        
        shootPoint = [self.parent convertPoint:shootPoint
                                        toNode:self.parent.parent];
        [self.bullets addObject:bullet];
        [self.parent.parent addChild:bullet];
        
        [bullet shootAtPoint:shootPoint];
        
        self.state.shotsFired = self.state.shotsFired + 1;
    }];
    
    SKAction *fire1 = [SKAction animateWithTextures:fireTextures timePerFrame:.2];
    SKAction *fire2 = [SKAction runBlock:^{
        self.texture = [SKTexture textureWithImageNamed:@"stormSix_standing_1.png"];
        [self updateState];
    }];
    
    SKAction *fire = [SKAction sequence:@[fire1,bullet,fire2]];
    
    [self runAction:fire withKey:kPlayerActionFire];
}

-(void)moveAndAttack
{
    if([self actionForKey:kPlayerActionWalkAndFire])
    {
        return;
    }
    
    [self removeAllActions];
    
    self.shouldExitMoveAndAttack = NO;
    
    SKAction *bullet = [SKAction runBlock:^{
        Bullet *bullet = [[Bullet alloc] initWithName:@"player_bullet" size:
                          CGSizeMake(self.size.height/4,self.size.height/6)];
        
        bullet.delegate = self;
        bullet.xScale = self.xScale;
        
        bullet.physicsBody.categoryBitMask = bulletMask;
        bullet.physicsBody.collisionBitMask = platformMask | enemyMask | playerMask | blockMask;
        bullet.physicsBody.collisionBitMask = platformMask | enemyMask | playerMask | blockMask;
        bullet.physicsBody.contactTestBitMask = platformMask | enemyMask | playerMask | blockMask;
        
        CGPoint shootPoint;
        
        if(xScaleNegativeDirectionFromIOSVersion() == 1)
        {
            shootPoint = CGPointMake(self.position.x+self.size.width*.35,
                                     self.position.y);
        } else
        {
            shootPoint = CGPointMake(self.position.x+(self.xScale*self.size.width*.35),
                                     self.position.y);
        }
        
        shootPoint = [self.parent convertPoint:shootPoint
                                        toNode:self.parent.parent];
        [self.bullets addObject:bullet];
        
        [self.parent.parent addChild:bullet];
        
        [bullet shootAtPoint:shootPoint];
        
        self.state.shotsFired = self.state.shotsFired + 1;
        
        if(self.shouldExitMoveAndAttack)
        {
            //////printf("MANE!!!\n");
            [self removeActionForKey:kPlayerActionWalkAndFire];
            
            self.shouldExitMoveAndAttack = NO;
            
            [self updateState];
        }
    }];
    
    NSMutableArray *fireWalkTextures = [[NSMutableArray alloc] init];
    
    for(int i = 1; i <= 1; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_walkP_shoot_%d",i]];
        
        [fireWalkTextures addObject:texture];
    }
    
    SKAction *fireAndWalk1 = [SKAction animateWithTextures:fireWalkTextures timePerFrame:0.2];
    
    fireWalkTextures = [[NSMutableArray alloc] init];
    
    for(int i = 2; i <= 3; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_walkP_shoot_%d",i]];
        [fireWalkTextures addObject:texture];
    }
    
    SKAction *fireAndWalk2 = [SKAction animateWithTextures:fireWalkTextures timePerFrame:0.2];
    
    fireWalkTextures = [[NSMutableArray alloc] init];
    
    for(int i = 4; i <= 5; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_walkP_shoot_%d",i]];
        
        [fireWalkTextures addObject:texture];
    }
    
    SKAction *fireAndWalk3 = [SKAction animateWithTextures:fireWalkTextures timePerFrame:0.2];
    
    fireWalkTextures = [[NSMutableArray alloc] init];
    
    for(int i = 6; i <= 7; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_walkP_shoot_%d",i]];
        
        [fireWalkTextures addObject:texture];
    }
    SKAction *fireAndWalk4 = [SKAction animateWithTextures:fireWalkTextures timePerFrame:0.2];
    
    SKAction *fireAndWalk5 = [SKAction
                               animateWithTextures:@[[SKTexture textureWithImageNamed:@"stormSix_walkP_shoot_8"]]
                               timePerFrame:0.2];
    
    SKAction *fireAndWalk6 = [SKAction runBlock:^{
        [self updateState];
    }];
    
    
    SKAction *fireAndWalk =
    [SKAction sequence:@[fireAndWalk1,bullet,
                         fireAndWalk2,bullet,
                         fireAndWalk3,bullet,
                         fireAndWalk4,bullet,
                         fireAndWalk5,fireAndWalk6]];
    
    [self runAction:fireAndWalk withKey:kPlayerActionWalkAndFire];
}


-(void)jump
{
    if([self actionForKey:kPlayerActionJump])
    {
        return;
    }
    
    [self removeAllActions];
    
    self.state.score = self.state.score + 2;
    
    GameScene *scene = (GameScene*)self.scene;
    
    CGVector vector = CGVectorMake(0,scene.size.height/1.5);
    
    NSMutableArray *startJump = [[NSMutableArray alloc] init];
    
    for(int i = 1; i <= 2; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_jumpingP_%d",i]];
        
        [startJump addObject:texture];
    }
    
    NSMutableArray *midJump = [[NSMutableArray alloc] init];
    
    for(int i = 3; i <= 3; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_jumpingP_%d",i]];
        
        [midJump addObject:texture];
    }
    
    NSMutableArray *endJump = [[NSMutableArray alloc] init];
    
    for(int i = 4; i <= 6; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"stormSix_jumpingP_%d",i]];
        
        [endJump addObject:texture];
    }
    
    SKAction *start = [SKAction animateWithTextures:startJump timePerFrame:.2];
    SKAction *mid = [SKAction animateWithTextures:midJump timePerFrame:.8];
    SKAction *end = [SKAction animateWithTextures:endJump timePerFrame:.2];
    
    SKAction *updateState = [SKAction runBlock:^{
        self.texture = [SKTexture textureWithImageNamed:@"stormSix_standing_1.png"];
        [self updateState];
    }];
    
    SKAction *jump = [SKAction sequence:@[start,mid,end,updateState]];
    
    [self runAction:jump withKey:kPlayerActionJump];
    
    [self.physicsBody applyImpulse:vector];
}

-(void)death
{
    GameScene *scene = (GameScene*)self.scene;
    
    [self removeAllActions];
    
    self.physicsBody.dynamic = YES;
    
    NSMutableArray *deathTextures = [[NSMutableArray alloc] init];
    
    for(int i = 1; i <= 5; i++)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:
                              [NSString stringWithFormat:@"stormSix_death_%d",i]];
        
        [deathTextures addObject:texture];
    }
    
    SKAction *deathAnimation = [SKAction animateWithTextures:
                                [NSArray arrayWithArray:deathTextures] timePerFrame:0.2];
    
    SKAction *completion = [SKAction runBlock:^{
        [scene gameOver];
    }];
    
    SKAction *death = [SKAction sequence:@[deathAnimation,completion]];
    
    [self runAction:death withKey:kPlayerActionDeath];
}

-(void)updateState
{
    if(self.isStanding)
    {
        //printf("ATTENTION: Player is standing");
        self.currentState = PlayerStateStanding;
    } else
    {
        //printf("ATTENTION: Player is not standing");
        self.currentState = PlayerStateIdle;
    }
}

-(void)trashBullets
{
    for(int i = 0; i < [self.bullets count]; i++)
    {
        Bullet *bullet = [self.bullets objectAtIndex:i];
        
        if(!CGRectContainsPoint(self.scene.frame,bullet.position))
        {
            [bullet removeFromParent];
            [bullet.delegate removeBullet:bullet];
            
            i--;
        }
    }
}

-(void)removeBullet:(Bullet*)bullet
{
    [self.bullets removeObject:bullet];
}

-(void)dealloc
{
    [self.bullets removeAllObjects];
    self.bullets = nil;
}

@end

