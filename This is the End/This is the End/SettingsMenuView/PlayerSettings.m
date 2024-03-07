//
//  PlayerSettings.m
//  This is the End
//
//  Created by Ilhan Raja on 8/4/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "PlayerSettings.h"

@interface PlayerSettings () {
}

@end
;

@implementation PlayerSettings

- (instancetype)init
{
    self = [super init];

    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];

    if (self) {
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
}

+ (instancetype)loadPlayerSettings
{
    NSData *decodedData = [NSData dataWithContentsOfFile:[self filePathForPlayerSettings]];

    PlayerSettings *playerSettings;

    if (decodedData) {
        playerSettings = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return playerSettings;
    }

    playerSettings = [[self alloc] init];

    return playerSettings;
}

+ (NSString *)filePathForPlayerSettings
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
        stringByAppendingPathComponent:@"PlayerSettings"];
}

- (void)savePlayerSettings
{
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];

    [encodedData writeToFile:[[self class] filePathForPlayerSettings] atomically:YES];
}

- (void)removePlayerSettings
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;

    BOOL success = [fileManager removeItemAtPath:[[self class] filePathForPlayerSettings] error:&error];

    if (success) {
        [self resetSettings];
    }
}

- (void)resetSettings
{
}

@end
