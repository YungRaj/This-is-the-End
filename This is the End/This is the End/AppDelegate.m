//
//  AppDelegate.m
//  CAGame
//
//  Created by Ilhan Raja on 6/9/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "GameAPI.h"
#import "AppDelegate.h"
#import "TITEViewController.h"
#import "MainMenuViewController.h"
#import "GameInstanceVC.h"
#import "GameScene.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


-(instancetype)init{
    self = [super init];
    
    if(self){
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size = [self screenSizeOrientationIndependent];
        _window = [[UIWindow alloc] initWithFrame:frame];
        [_window makeKeyAndVisible];
    }
    return self;
}

-(CGSize)screenSizeOrientationIndependent {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        return screenSize;
    }
    return CGSizeMake(MAX(screenSize.width, screenSize.height), MIN(screenSize.width, screenSize.height));
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:
            [UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:
                navigationController.visibleViewController];
    }else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:
                presentedViewController];
    }else if([rootViewController.childViewControllers count]>0){
        return [rootViewController.childViewControllers objectAtIndex:[rootViewController.childViewControllers count]-1];
    }else{
        return rootViewController;
    }
}

-(void)createWorkingPlistIntoDirectory:(NSSearchPathDirectory)directory{
    BOOL exists, isLatest = NO;
    NSError *error;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"GameContents" ofType:@"plist"];
    NSString *writablePath = [[NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"GameContents.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    exists = [fileManager fileExistsAtPath:writablePath];
    
    if(exists){
        NSDictionary *bundleDatabase;
        NSDictionary *cachesDatabase;
        NSDate *bundleModifiedDate;
        NSDate *cachesModifiedDate;
        NSDate *laterDate;
        
        bundleDatabase = [fileManager attributesOfItemAtPath:bundlePath error:&error];
        cachesDatabase = [fileManager attributesOfItemAtPath:writablePath error:&error];
        
        bundleModifiedDate = [bundleDatabase objectForKey:NSFileModificationDate];
        cachesModifiedDate = [cachesDatabase objectForKey:NSFileModificationDate];
        
        laterDate = [bundleModifiedDate laterDate:cachesModifiedDate];
        
        isLatest = laterDate == cachesModifiedDate ? YES : NO;
    }
    
    if(!(exists && isLatest)){
        if(exists){
            [fileManager removeItemAtPath:writablePath error:&error];
        }
        [fileManager copyItemAtPath:bundlePath toPath:writablePath error:&error];
    }
    
    
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if(!self.window.rootViewController){
        TITEViewController *rootViewController = [[TITEViewController alloc] init];
        self.window.rootViewController = rootViewController;
        [self createWorkingPlistIntoDirectory:NSCachesDirectory];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    UIViewController *topViewController = [self topViewController];
    if([topViewController isKindOfClass:[MainMenuViewController class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kMainMenuPauseFrame object:nil];
    } 
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIViewController *topViewController = [self topViewController];
    if([topViewController isKindOfClass:[GameInstanceVC class]]){
        [((SKView*)((GameInstanceVC*)topViewController).view).scene performSelector:@selector(pauseGame) withObject:nil];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    UIViewController *topViewController = [self topViewController];
    if([topViewController isKindOfClass:[MainMenuViewController class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kMainMenuResumeFrame object:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
