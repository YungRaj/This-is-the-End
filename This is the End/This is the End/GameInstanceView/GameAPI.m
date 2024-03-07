//
//  GameAPI.m
//  This is the End
//
//  Created by Ilhan Raja on 9/16/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "GameAPI.h"
#import "Badge.h"
#import "Coin.h"
#import "GameScene.h"
#import "PowerUp.h"

const NSString *kPowerUpGod = @"God";
const NSString *kPowerUpCoin = @"Coin";
const NSString *kPowerUpAttack = @"Attack";
const NSString *kPowerUpRun = @"Run";
const NSString *kPowerUpPortal = @"Portal";
const NSString *kPowerUpJump = @"Jump";
const NSString *kPowerUpDefense = @"Defense";
const NSString *kPowerUpHealth = @"Health";

const NSString *kBadgeAttack = @"Attack";
const NSString *kBadgeAUpDDown = @"AUpDDown";
const NSString *kBadgeDUpADown = @"DUpADown";
const NSString *kBadgeCloseCall = @"CloseCall";
const NSString *kBadgeDodgeAttack = @"DodgeAttack";
const NSString *kBadgeLastStand = @"LastStand";
const NSString *kBadgeHealth = @"Health";
const NSString *kBadgeRestoreHealth = @"RestoreHealth";
const NSString *kBadgeCoin = @"Coin";
const NSString *kBadgePlusPUpTime = @"PlusPUpTime";
const NSString *kBadgeDownEnemyA = @"DownEnemyA";
const NSString *kBadgeRun = @"Run";
const NSString *kBadgeJump = @"Jump";
const NSString *kBadgeJumpAttack = @"JumpAttack";
const NSString *kBadgeGod = @"God";

const NSString *kGameNotificationPlayerState = @"playerState";
const NSString *kGameNotificationScore = @"score";
const NSString *kGameNotificationWorld = @"world";
const NSString *kGameNotificationLives = @"lives";
const NSString *kGameNotificationCoins = @"coins";
const NSString *kGameNotificationLevel = @"level";
const NSString *kGameNotificationHealth = @"health";
const NSString *kGameNotificationResume = @"resumeGame";
const NSString *kGameNotificationOver = @"gameOver";
const NSString *kGameNotificationPause = @"pauseGame";
const NSString *kGameNotificationSave = @"saveGame";
const NSString *kMainMenuPauseFrame = @"mainMenuPauseFrame";
const NSString *kMainMenuResumeFrame = @"mainMenuResumeFrame";


BOOL checkAllCollisions(SKNode *node)
{
    if ([node.scene isKindOfClass:[GameScene class]]) {
        GameScene *scene = (GameScene *)node.scene;
        for (SKNode *rectangle in scene.rectangles) {
            BOOL isColliding = checkCollision(node, rectangle);
            if (isColliding) {
                return true;
            }
        }
    }
    return false;
}

BOOL checkCollision(SKNode *a, SKNode *b)
{
    CGFloat aTopLeftX = a.position.x - a.frame.size.width * .15;
    CGFloat aTopLeftY = a.position.y + a.frame.size.height / 2;
    CGFloat aBottomRightX = a.position.x + a.frame.size.width * .15;
    CGFloat aBottomRightY = a.position.y - a.frame.size.height / 2;
    CGFloat bTopLeftX = b.position.x - b.frame.size.width / 2;
    CGFloat bTopLeftY = b.position.y + b.frame.size.height / 2;
    CGFloat bBottomRightX = b.position.x + b.frame.size.width / 2;
    CGFloat bBottomRightY = b.position.y - b.frame.size.height / 2;

    return !(bTopLeftX >= aBottomRightX || aTopLeftX >= bBottomRightX || aBottomRightY >= bTopLeftY ||
             bBottomRightY >= aTopLeftY);
}

// doesn't work....

/*BOOL checkCollision(SKNode *a, CGVector vectorA, SKNode *b, CGVector vectorB){
    CGFloat aTopLeftX = (a.position.x+vectorA.dx/FRAME_RATE)-a.frame.size.width*.15;
    CGFloat aTopLeftY = (a.position.y+vectorA.dy/FRAME_RATE)+a.frame.size.height/2;
    CGFloat aBottomRightX = (a.position.x+vectorA.dx/FRAME_RATE)+a.frame.size.width*.15;
    CGFloat aBottomRightY = (a.position.y+vectorA.dy/FRAME_RATE)-a.frame.size.height/2;
    CGFloat bTopLeftX = (b.position.x+vectorB.dx/FRAME_RATE)-b.frame.size.width/2;
    CGFloat bTopLeftY = (b.position.y+vectorB.dy/FRAME_RATE)+b.frame.size.height/2;
    CGFloat bBottomRightX = (b.position.x+vectorB.dx/FRAME_RATE)+b.frame.size.width/2;
    CGFloat bBottomRightY = (b.position.y+vectorB.dy/FRAME_RATE)-b.frame.size.height/2;
    return !(bTopLeftX>=aBottomRightX || aTopLeftX>=bBottomRightX ||
             aBottomRightY>=bTopLeftY || bBottomRightY>=aTopLeftY);
}*/

// not needed anymore

NSInteger xScaleNegativeDirectionFromIOSVersion()
{
    return -1;
}

SKSpriteNode<CollectableItem> *randomItem()
{
    NSInteger random = arc4random() % ((numberOfBadges + numberOfPowerUps) * 2);

    if (random == 10) {
        return randomBadge();
    } else if (random % 2 == 0) {
        return randomPowerUp();
    } else {
        return newCoin();
    }
    return nil;
}

PowerUp *randomPowerUp()
{
    return [[PowerUp alloc] initWithType:arc4random() % numberOfPowerUps];
}

Badge *randomBadge()
{
    return [[Badge alloc] initWithType:arc4random() % numberOfBadges];
}

Coin *newCoin()
{
    return [[Coin alloc] init];
}
