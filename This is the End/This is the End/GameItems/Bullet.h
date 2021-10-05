//
//  Bullet.h
//  This is the End
//
//  Created by Ilhan Raja on 9/2/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BulletDelegate.h"

@interface Bullet : SKSpriteNode

@property (weak,nonatomic) id<BulletDelegate> delegate;

-(instancetype)initWithName:(NSString*)name size:(CGSize)size;
-(void)shootAtPoint:(CGPoint)point;
-(void)explode;

@end
