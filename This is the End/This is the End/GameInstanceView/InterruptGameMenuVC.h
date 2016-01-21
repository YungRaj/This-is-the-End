//
//  PauseMenuVC.h
//  This is the End
//
//  Created by Ilhan Raja on 7/24/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    InterruptedGamePaused,
    InterruptedGameOver,
    InterruptedGameRetrievedItem,
    InterruptedGameLevelCompleted,
    InterruptedGameWorldCompleted,
} InterruptedGameMode;

@interface InterruptGameMenuVC : UIViewController

-(instancetype)initWithType:(InterruptedGameMode)mode;

@end
