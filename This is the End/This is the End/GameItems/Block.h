//
//  Block.h
//  This is the End
//
//  Created by Ilhan Raja on 9/11/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum{
    BlockTypeMystery,
    BlockTypeWood,
    BlockTypeMetal,
    BlockTypeCoins,
} BlockType;


extern const NSString *kBlockActionActivate;

@interface Block : SKSpriteNode

@property (assign,nonatomic) BlockType type;
@property (assign,nonatomic) BOOL isActivated;

-(void)activateBlock;

@end
