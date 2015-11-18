//
//  GameInfoPanel.h
//  This is the End
//
//  Created by Ilhan Raja on 10/1/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum{
    GameInfoPanelTypeScore,
    GameInfoPanelTypeWorld,
    GameInfoPanelTypeCoins,
    GameInfoPanelTypeLives,
    GameInfoPanelTypeLevel,
    GameInfoPanelTypeHealth,
} GameInfoPanelType;

@class GameData;

@interface GameInfoPanel : SKSpriteNode


-(instancetype)initWithType:(GameInfoPanelType)type
                   position:(CGPoint)position
                       size:(CGSize)size
                      state:(GameData*)state;
+(NSString*)getNotificationNameFromType:(GameInfoPanelType)type;


@end
