//
//  Block.m
//  This is the End
//
//  Created by Ilhan Raja on 9/11/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "Block.h"
#import "PowerUp.h"
#import "Badge.h"

NSString *kBlockActionActivate = @"activate";

@implementation Block

-(void)activateBlock{
    if(!self.isActivated){
        self.isActivated = YES;
        if(self.type==BlockTypeMystery){
            SKTexture *texture1 = [SKTexture textureWithImageNamed:@"mysteryblock1"];
            SKTexture *texture2 = [SKTexture textureWithImageNamed:@"mysteryblock2"];
            SKTexture *texture3 = [SKTexture textureWithImageNamed:@"mysteryblock3"];
            SKAction *activateBlock = [SKAction animateWithTextures:@[texture1,texture2,texture3]
                                                       timePerFrame:.1];
            [self runAction:activateBlock withKey:kBlockActionActivate];
            
            CGPoint currentPosition = self.position;
            CGSize sceneSize = self.scene.size;
            CGSize powerUpSize = CGSizeMake(sceneSize.width/10,
                                            sceneSize.height/10);
            CGPoint itemPosition = CGPointMake(currentPosition.x,
                                               currentPosition.y+self.size.width/2+powerUpSize.height/2);
        }
        
        
    }
}


@end
