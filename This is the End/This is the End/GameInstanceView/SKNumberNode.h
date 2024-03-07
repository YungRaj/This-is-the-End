//
//  SKNumberNode.h
//  This is the End
//
//  Created by Ilhan Raja on 10/5/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface SKNumberNode : SKSpriteNode

@property (assign, nonatomic) NSInteger number;


- (instancetype)initWithNumber:(NSInteger)number
                              size:(CGSize)size
                          position:(CGPoint)position
                       sizeOfDigit:(CGSize)size
                    numberOfDigits:(NSInteger)digits
    shouldFillEmptyDigitsWithZeros:(BOOL)shouldFillEmptyDigitsWithZeros;


@end
