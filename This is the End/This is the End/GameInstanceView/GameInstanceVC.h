//
//  GameInstanceVC.h
//  This is the End
//
//  Created by Ilhan Raja on 7/16/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>

@class GameData;

@interface GameInstanceVC : UIViewController

@property (strong, nonatomic) SKView *view;

- (GameData *)gameData;

@end
