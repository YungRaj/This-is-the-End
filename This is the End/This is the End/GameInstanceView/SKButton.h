//
//  SKButton.h
//  This is the End
//
//  Created by Ilhan Raja on 7/19/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Player;

@interface SKButton : SKSpriteNode


@property (strong,nonatomic) SKSpriteNode *contents;
@property (assign,nonatomic) BOOL isSelected;

+(instancetype)buttonWithTexture:(SKTexture*)texture
                        withSize:(CGSize)size
                    childTexture:(SKTexture*)childTexture
                        withSize:(CGSize)childSize;

@end
