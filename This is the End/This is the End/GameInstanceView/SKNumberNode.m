//
//  SKNumberNode.m
//  This is the End
//
//  Created by Ilhan Raja on 10/5/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//


#import "SKNumberNode.h"
#import "GameAPI.h"
#import "GameData.h"

@interface SKNumberNode () {
    NSInteger _numberOfDigits;
    CGSize _sizeOfDigit;
    BOOL _shouldFillEmptyDigitsWithZeros;
}

@end

@implementation SKNumberNode

- (instancetype)initWithNumber:(NSInteger)number
                              size:(CGSize)size
                          position:(CGPoint)position
                       sizeOfDigit:(CGSize)sizeOfDigit
                    numberOfDigits:(NSInteger)numberOfDigits
    shouldFillEmptyDigitsWithZeros:(BOOL)shouldFillEmptyDigitsWithZeros
{
    self = [super init];

    if (self) {
        self.size = size;
        self.position = position;

        _shouldFillEmptyDigitsWithZeros = shouldFillEmptyDigitsWithZeros;
        _number = number;
        _sizeOfDigit = sizeOfDigit;
        _numberOfDigits = numberOfDigits;

        [self setUpNumberNode];
    }

    return self;
}

- (void)setNumber:(NSInteger)number
{
    _number = number;

    [self updateNode];
}

- (NSUInteger)countNumberOfDigits:(NSInteger)number
{
    return [[NSString stringWithFormat:@"%ld", (long)number] length];
}

- (void)setUpNumberNode
{
    CGFloat x = -self.size.width / 2 + _sizeOfDigit.width / 2;

    for (int i = 0; i < _numberOfDigits; i++) {
        SKSpriteNode *digit = [SKSpriteNode node];

        digit.size = _sizeOfDigit;
        digit.position = CGPointMake(x, 0);

        x += _sizeOfDigit.width;

        [self addChild:digit];
    }

    [self updateNode];
}

- (void)updateNode
{
    NSUInteger numDigits = [self countNumberOfDigits:_number];
    NSInteger number = _number;

    if (_shouldFillEmptyDigitsWithZeros) {
        NSInteger i = [self.children count] - 1;

        while (i > 0) {
            SKNode *digit = [self.children objectAtIndex:i];

            if ([digit isKindOfClass:[SKSpriteNode class]]) {
                NSInteger digitValue = number % 10;
                SKTexture *digitTexture =
                    [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%ldw", (long)digitValue]];

                ((SKSpriteNode *)digit).texture = digitTexture;

                number /= 10;

                i--;
            }
        }
    } else {
        NSInteger i = numDigits;
        if (number == 0) {
            SKNode *digit = [self.children objectAtIndex:1];

            if ([digit isKindOfClass:[SKSpriteNode class]]) {
                SKTexture *zero = [SKTexture textureWithImageNamed:@"0w"];
                ((SKSpriteNode *)digit).texture = zero;
                return;
            }
        }

        while (number > 0 && i >= 0) {
            SKNode *digit = [self.children objectAtIndex:i];

            if ([digit isKindOfClass:[SKSpriteNode class]]) {
                NSInteger digitValue = number % 10;
                SKTexture *digitTexture =
                    [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%ldw", (long)digitValue]];

                ((SKSpriteNode *)digit).texture = digitTexture;

                number /= 10;

                i--;
            }
        }
    }
}

- (void)dealloc
{
}


@end
