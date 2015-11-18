//
//  Player.h
//  This is the End
//
//  Created by Ilhan Raja on 6/20/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import "Foundation/Foundation.h"

@protocol MovingObject <NSObject>


-(void)action;

@optional
-(void)move;
-(void)attack;
-(void)moveAndAttack;
-(void)jump;
-(void)death;

@end
