//
//  GameData.m
//  This is the End
//
//  Created by Ilhan Raja on 6/19/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import "GameData.h"
#import "GameAPI.h"

@interface GameData () {
}


@property (strong, nonatomic) NSMutableArray *powerUps;
@property (strong, nonatomic) NSMutableArray *badges;

@end

@implementation GameData

static NSString *const worldsKey = @"worlds";
static NSString *const levelsKey = @"levels";
static NSString *const healthKey = @"health";
static NSString *const scoreKey = @"score";
static NSString *const coinsKey = @"coins";
static NSString *const killsKey = @"kills";
static NSString *const shotsFiredKey = @"shotsFired";
static NSString *const powerUpsKey = @"powerUps";
static NSString *const badgesKey = @"badges";

- (NSMutableArray *)powerUps
{
    if (!_powerUps) {
        _powerUps = [[NSMutableArray alloc] init];
    }

    return _powerUps;
}

- (NSMutableArray *)badges
{
    if (!_badges) {
        _badges = [[NSMutableArray alloc] init];
    }

    return _badges;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];

    if (self) {
        _worlds = [decoder decodeInt32ForKey:worldsKey];
        _levels = [decoder decodeInt32ForKey:levelsKey];
        _health = [decoder decodeInt32ForKey:healthKey];
        _score = [decoder decodeInt32ForKey:scoreKey];
        _coins = [decoder decodeInt32ForKey:coinsKey];
        _kills = [decoder decodeInt32ForKey:killsKey];
        _shotsFired = [decoder decodeInt32ForKey:shotsFiredKey];
        _powerUps = [decoder decodeObjectForKey:powerUpsKey];
        _badges = [decoder decodeObjectForKey:badgesKey];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt32:self.worlds forKey:worldsKey];
    [encoder encodeInt32:self.levels forKey:levelsKey];
    [encoder encodeInt32:self.health forKey:healthKey];
    [encoder encodeInt32:self.score forKey:scoreKey];
    [encoder encodeInt32:self.coins forKey:coinsKey];
    [encoder encodeInt32:self.kills forKey:killsKey];
    [encoder encodeInt32:self.shotsFired forKey:shotsFiredKey];
    [encoder encodeObject:self.powerUps forKey:powerUpsKey];
    [encoder encodeObject:self.badges forKey:badgesKey];
}

+ (instancetype)loadInstanceWithState:(int32_t)state
{
    if (state < -1 || state > 4)
        return nil;

    NSData *decodedData = [NSData dataWithContentsOfFile:[self filePathForState:state]];

    GameData *gameData;

    if (decodedData) {
        gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        gameData.filePathExists = YES;
        gameData.state = state;

        return gameData;
    }

    gameData = [[self alloc] init];

    gameData.state = state;
    gameData.filePathExists = NO;

    [gameData reset];

    return gameData;
}

+ (NSString *)filePathForState:(int32_t)state
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
        stringByAppendingPathComponent:[NSString stringWithFormat:@"GameData%d", state]];
}

+ (BOOL)filePathExistsForState:(int32_t)state
{
    return [NSData dataWithContentsOfFile:[self filePathForState:state]] != nil;
}


- (void)setWorlds:(int32_t)worlds
{
    _worlds = worlds;

    [[NSNotificationCenter defaultCenter] postNotificationName:kGameNotificationWorld
                                                        object:[NSNumber numberWithInteger:_worlds]];
}

- (void)setScore:(int32_t)score
{
    _score = score;

    [[NSNotificationCenter defaultCenter] postNotificationName:kGameNotificationScore
                                                        object:[NSNumber numberWithInteger:_score]];
}

- (void)setLives:(int32_t)lives
{
    _lives = lives;

    [[NSNotificationCenter defaultCenter] postNotificationName:kGameNotificationLives
                                                        object:[NSNumber numberWithInteger:_lives]];
}

- (void)setCoins:(int32_t)coins
{
    _coins = coins;

    [[NSNotificationCenter defaultCenter] postNotificationName:kGameNotificationCoins
                                                        object:[NSNumber numberWithInteger:_coins]];
}


- (void)addPowerUp:(PowerUp *)powerUp
{
    [self.powerUps addObject:powerUp];
}

- (void)addBadge:(Badge *)badge
{
    [self.badges addObject:badge];
}

- (void)removePowerUp:(PowerUp *)powerUp
{
    [self.powerUps removeObject:powerUp];

    [powerUp removeFromParent];
}

- (void)removeBadge:(Badge *)badge
{
    [self.badges removeObject:badge];
    [badge removeFromParent];
}

- (unsigned long)numItems
{
    return ([self.powerUps count] + [self.badges count]);
}

- (unsigned long)numBadges
{
    return [self.badges count];
}

- (unsigned long)numPowerUps
{
    return [self.powerUps count];
}

- (unsigned long)numBadgesFromType:(BadgeType)badgeType
{
    unsigned long foundBadges = 0;
    for (Badge *badge in self.badges) {
        if (badge.type == badgeType) {
            foundBadges++;
        }
    }
    return foundBadges;
}

- (unsigned long)numPowerUpsFromType:(PowerUpType)powerUpType
{
    unsigned long foundPowerUps = 0;
    for (PowerUp *powerUp in self.powerUps) {
        if (powerUp.type == powerUpType) {
            foundPowerUps++;
        }
    }
    return foundPowerUps;
}


- (void)reset
{
    self.worlds = 1;
    self.lives = 5;
    self.levels = 1;
    self.health = 100;
    self.score = 0;
    self.coins = 0;
    self.kills = 0;
    self.shotsFired = 0;
    self.badges = [[NSMutableArray alloc] init];
    self.powerUps = [[NSMutableArray alloc] init];
}


- (void)saveToState:(int32_t)state
{
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[GameData filePathForState:state] atomically:YES];
    self.filePathExists = YES;
}

- (void)removefilePathAtState:(int32_t)state
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:[GameData filePathForState:state] error:&error];
    if (success) {
        self.filePathExists = NO;
        [self reset];
    }
}


@end
