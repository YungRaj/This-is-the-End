//
//  GameInfoPanel.m
//  This is the End
//
//  Created by Ilhan Raja on 10/1/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import "GameInfoPanel.h"
#import "GameAPI.h"
#import "GameData.h"
#import "SKNumberNode.h"


@interface GameInfoPanel () {
}

@property (assign, nonatomic) GameInfoPanelType type;
@property (strong, nonatomic) SKSpriteNode *title;
@property (strong, nonatomic) SKNumberNode *value;
@property (weak, nonatomic) GameData *state;

@end

@implementation GameInfoPanel


- (instancetype)initWithType:(GameInfoPanelType)type
                    position:(CGPoint)position
                        size:(CGSize)size
                       state:(GameData *)state
{
    self = [super init];

    if (self) {
        self.size = size;
        self.position = position;

        _type = type;
        _state = state;

        [self setUpInfoPanel];
    }

    return self;
}

- (NSInteger)getValueFromStateWithType:(GameInfoPanelType)type
{
    if (type == GameInfoPanelTypeCoins) {
        return self.state.coins;
    } else if (type == GameInfoPanelTypeLives) {
        return self.state.lives;
    } else if (type == GameInfoPanelTypeScore) {
        return self.state.score;
    } else if (type == GameInfoPanelTypeWorld) {
        return self.state.worlds;
    } else if (type == GameInfoPanelTypeLevel) {
        return self.state.levels;
    } else if (type == GameInfoPanelTypeHealth) {
        return self.state.health;
    }

    return 0;
}

+ (NSString *)getNotificationNameFromType:(GameInfoPanelType)type
{
    if (type == GameInfoPanelTypeCoins) {
        return kGameNotificationCoins;
    } else if (type == GameInfoPanelTypeLives) {
        return kGameNotificationLives;
    } else if (type == GameInfoPanelTypeScore) {
        return kGameNotificationScore;
    } else if (type == GameInfoPanelTypeWorld) {
        return kGameNotificationWorld;
    } else if (type == GameInfoPanelTypeLevel) {
        return kGameNotificationLevel;
    } else if (type == GameInfoPanelTypeHealth) {
        return kGameNotificationHealth;
    }

    return nil;
}

+ (BOOL)shouldFillEmptyDigitsWithZerosFromType:(GameInfoPanelType)type
{
    if (type == GameInfoPanelTypeCoins) {
        return false;
    } else if (type == GameInfoPanelTypeLives) {
        return false;
    } else if (type == GameInfoPanelTypeScore) {
        return true;
    } else if (type == GameInfoPanelTypeWorld) {
        return false;
    } else if (type == GameInfoPanelTypeLevel) {
        return false;
    } else if (type == GameInfoPanelTypeHealth) {
        return false;
    }

    return false;
}

- (void)setUpInfoPanel
{
    self.title = [SKSpriteNode node];

    CGSize size = self.size;

    if (self.type == GameInfoPanelTypeCoins) {
        self.title.texture = [SKTexture textureWithImageNamed:@"coinsw.png"];
    } else if (self.type == GameInfoPanelTypeLives) {
        self.title.texture = [SKTexture textureWithImageNamed:@"livesw.png"];
    } else if (self.type == GameInfoPanelTypeScore) {
        self.title.texture = [SKTexture textureWithImageNamed:@"scorew.png"];
    } else if (self.type == GameInfoPanelTypeWorld) {
        self.title.texture = [SKTexture textureWithImageNamed:@"worldw.png"];
    } else if (self.type == GameInfoPanelTypeLevel) {
        self.title.texture = [SKTexture textureWithImageNamed:@"levelw.png"];
    } else if (self.type == GameInfoPanelTypeHealth) {
        self.title.texture = [SKTexture textureWithImageNamed:@"healthw.png"];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateValue:)
                                                 name:[[self class] getNotificationNameFromType:self.type]
                                               object:nil];
    self.title.size =
        CGSizeMake(size.height * (self.title.texture.size.width / self.title.texture.size.height), size.height);
    self.title.position = CGPointMake(-self.size.width / 2 + self.title.size.width / 2, 0);
    self.value = [[SKNumberNode alloc] initWithNumber:[self getValueFromStateWithType:self.type]
                                                 size:CGSizeMake(size.width - self.title.size.width, size.height)
                                             position:CGPointMake((((size.width - self.title.size.width) / 2) +
                                                                   self.title.size.width) -
                                                                      self.size.width / 2,
                                                                  0)
                                          sizeOfDigit:CGSizeMake(self.size.height, self.size.height)
                                       numberOfDigits:((size.width - self.title.size.width) / self.size.height)
                       shouldFillEmptyDigitsWithZeros:[[self class] shouldFillEmptyDigitsWithZerosFromType:self.type]];
    [self addChild:self.title];
    [self addChild:self.value];
}

- (void)updateValue:(NSNotification *)notification
{
    NSNumber *number = [notification object];
    if ([notification.name isEqualToString:[[self class] getNotificationNameFromType:self.type]]) {
        self.value.number = [number integerValue];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[[self class] getNotificationNameFromType:self.type]
                                                  object:nil];
}

@end
