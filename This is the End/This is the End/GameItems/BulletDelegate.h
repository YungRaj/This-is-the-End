//
//  BulletDelegate.h
//  This is the End
//
//  Created by Ilhan Raja on 9/21/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bullet;

@protocol BulletDelegate <NSObject>

@property (strong, nonatomic) NSMutableArray *bullets;

- (void)removeBullet:(Bullet *)bullet;

@end
