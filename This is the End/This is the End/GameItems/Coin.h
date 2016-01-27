//
//  Coin.h
//  This is the End
//
//  Created by Ilhan Raja on 1/27/16.
//  Copyright © 2016 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CollectableItem.h"

@interface Coin : SKSpriteNode <CollectableItem>

-(void)activate;

@end
