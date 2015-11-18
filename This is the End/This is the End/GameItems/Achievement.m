//
//  Achievement.m
//  This is the End
//
//  Created by Ilhan Raja on 7/13/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "Achievement.h"

@implementation Achievement

-(instancetype)initWithIdentifier:(NSString *)identifier{
    self = [super initWithIdentifier:identifier];
    
    if(self) {
        [self setUpAchievementWithIdentifier:identifier];
    }
    return self;
}

-(void)setUpAchievementWithIdentifier:(NSString*)identifier{
    if([identifier isEqualToString:@"OneHundredCoins"]){
        _achievement = GameAchievementOneHundredCoins;
    }else if([identifier isEqualToString:@"OneThousandCoins"]){
        _achievement = GameAchievementOneThousandCoins;
    }else if([identifier isEqualToString:@"TenThousandCoins"]){
        _achievement = GameAchievementTenThousandCoins;
    }else if([identifier isEqualToString:@"FiftyKills"]){
        _achievement = GameAchievementFiftyKills;
    }else if([identifier isEqualToString:@"TwoHundredFiftyKills"]){
        _achievement = GameAchievementTwoHundredFiftyKills;
    }else if([identifier isEqualToString:@"OneThousandKills"]){
        _achievement = GameAchievementOneThousandKills;
    }else if([identifier isEqualToString:@"TenThousandKills"]){
        _achievement = GameAchievementTenThousandKills;
    }else if([identifier isEqualToString:@"OneThousandShotsFired"]){
        _achievement = GameAchievementOneThousandShotsFired;
    }else if([identifier isEqualToString:@"TenThousandShotsFired"]){
        _achievement = GameAchievementTenThousandShotsFired;
    }else if([identifier isEqualToString:@"OneHundredThousandShotsFired"]){
        _achievement = GameAchievementOneHundredThousandShotsFired;
    }else if([identifier isEqualToString:@"OneMillionShotsFired"]){
        _achievement = GameAchievementOneMillionShotsFired;
    }else if([identifier isEqualToString:@"TenBadgesUsed"]){
        _achievement = GameAchievementTenBadgesUsed;
    }else if([identifier isEqualToString:@"TwentyFiveBadgesUsed"]){
        _achievement = GameAchievementTwentyFiveBadgesUsed;
    }else if([identifier isEqualToString:@"OneHundredBadgesUsed"]){
        _achievement = GameAchievementOneHundredBadgesUsed;
    }
}

+(instancetype)achievementWithIdentifier:(NSString *)identifier{
    return [[self alloc] initWithIdentifier:identifier];
}

@end
