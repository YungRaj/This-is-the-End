//
//  PlayerSettings.h
//  This is the End
//
//  Created by Ilhan Raja on 8/4/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerSettings : NSObject <NSCoding>

- (void)savePlayerSettings;
- (void)removePlayerSettings;

@end
