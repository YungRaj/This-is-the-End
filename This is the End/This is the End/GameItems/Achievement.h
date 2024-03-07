//
//  Achievement.h
//  This is the End
//
//  Created by Ilhan Raja on 7/13/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

typedef enum {
    GameAchievementOneHundredCoins,
    GameAchievementOneThousandCoins,
    GameAchievementTenThousandCoins,
    GameAchievementFiftyKills,
    GameAchievementTwoHundredFiftyKills,
    GameAchievementOneThousandKills,
    GameAchievementTenThousandKills,
    GameAchievementOneThousandShotsFired,
    GameAchievementTenThousandShotsFired,
    GameAchievementOneHundredThousandShotsFired,
    GameAchievementOneMillionShotsFired,
    GameAchievementTenBadgesUsed,
    GameAchievementTwentyFiveBadgesUsed,
    GameAchievementOneHundredBadgesUsed,

} GameAchievement;

@interface Achievement : GKAchievement

@property (assign, nonatomic) GameAchievement achievement;


+ (instancetype)achievementWithIdentifier:(NSString *)identifier;


@end
