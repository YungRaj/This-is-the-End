//
//  SKButton.m
//  This is the End
//
//  Created by Ilhan Raja on 7/19/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "SKButton.h"
#import "GameScene.h"

@interface SKButton () {
    
}

@end

@implementation SKButton



+(instancetype)buttonWithTexture:(SKTexture*)texture
                        withSize:(CGSize)size
                    childTexture:(SKTexture*)childTexture
                        withSize:(CGSize)childSize
{
    SKButton *button = [self spriteNodeWithTexture:texture];
    
    button.size = size;
    
    button.contents = [SKSpriteNode spriteNodeWithTexture:childTexture];
    button.contents.size = childSize;
    
    button.userInteractionEnabled = YES;
    
    return button;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if(isSelected)
    {
        self.colorBlendFactor = 0.5;
    } else
    {
        self.colorBlendFactor = 0.0;
    }
}

-(void)setContents:(SKSpriteNode *)contents
{
    _contents = contents;
    
    [self addChild:contents];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint point = [touch locationInNode:self.parent];
        
        if(CGRectContainsPoint(self.frame,point))
        {
            self.isSelected = YES;
        }
    }
    
    [self.parent touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint point = [touch locationInNode:self.parent];
        
        if(CGRectContainsPoint(self.frame,point))
        {
            self.isSelected = NO;
        }
    }
    
    [self.parent touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

-(void)dealloc
{

}

@end
