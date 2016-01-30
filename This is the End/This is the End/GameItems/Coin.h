//
//  Coin.h
//  This is the End
//
//  Created by Ilhan Raja on 1/27/16.
//  Copyright © 2016 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CollectableItem.h"

static NSString *coinStoreItems[] = {@"CoinOneHundred",
                                      @"CoinOneThousand",
                                      @"CoinTenThousand",
                                      @"CoinInfinity"};

static uint32_t coinStoreQuantity[] = {100,
                                       1000,
                                       10000,
                                       UINT32_MAX};

@interface Coin : SKSpriteNode <CollectableItem>


-(void)activate;

@end
