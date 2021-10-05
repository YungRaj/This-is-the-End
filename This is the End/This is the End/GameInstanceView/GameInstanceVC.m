//
//  GameInstanceVC.m
//  This is the End
//
//  Created by Ilhan Raja on 7/16/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//


#import "GameAPI.h"
#import "GameInstanceVC.h"
#import "TITEViewController.h"
#import "InterruptGameMenuVC.h"
#import "GameData.h"
#import "GameScene.h"


@interface GameInstanceVC () {
    
}



@end

@implementation GameInstanceVC

@dynamic view;

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        
    
    }
    
    return self;
}


-(void)loadView
{
    self.view = [[SKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

-(GameData*)gameData
{
    if([self.parentViewController isKindOfClass:[TITEViewController class]])
    {
        return ((TITEViewController*)self.parentViewController).gameDataSelected;
    }
    
    return nil;
}
    
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpGame];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpData
{
    
}


-(void)setUpGame{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseGame:) name:kGameNotificationPause object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playGame:) name:kGameNotificationResume object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver:) name:kGameNotificationOver object:nil];
    
    self.view.multipleTouchEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
    [self setUpData];
    
    if(!self.view.scene)
    {
        //self.view.showsFPS = YES;
        //self.view.showsNodeCount = YES;

        SKScene *scene =  [[GameScene alloc] initWithSize:self.view.frame.size gameStateData:[self gameData]];
        
        scene.userInteractionEnabled = YES;
        scene.scaleMode = SKSceneScaleModeResizeFill;
        
        [self.view presentScene:scene];
    }
}

-(void)pauseGame:(NSNotification*)notification
{
    if([notification.name isEqualToString:kGameNotificationPause])
    {
        InterruptGameMenuVC *pausedMenu = [[InterruptGameMenuVC alloc] initWithType:InterruptedGamePaused];
        
        [self.parentViewController addChildViewController:pausedMenu];
        [self.parentViewController.view addSubview:pausedMenu.view];
        
        CATransition *transition = [CATransition animation];
        
        transition.duration = .5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFade;
        
        [self.view.window.layer addAnimation:transition forKey:nil];
    }
}

-(void)playGame:(NSNotification*)notification
{
    if([notification.name isEqualToString:kGameNotificationResume])
    {
        self.view.paused = NO;
    }
}

-(void)gameOver:(NSNotification*)notification
{
    if([notification.name isEqualToString:kGameNotificationOver])
    {
        for(UIViewController *controller in self.parentViewController.childViewControllers)
        {
            if([controller isKindOfClass:[InterruptGameMenuVC class]])
            {
                return;
            }
        }
        
        InterruptGameMenuVC *gameOver = [[InterruptGameMenuVC alloc] initWithType:InterruptedGameOver];
        
        [self.parentViewController addChildViewController:gameOver];
        [self.parentViewController.view addSubview:gameOver.view];
        
        CATransition *transition = [CATransition animation];
        
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionReveal;
        
        [self.view.window.layer addAnimation:transition forKey:nil];
    }
}


-(void)dealloc
{
    [self.view.scene removeAllActions];
    [self.view.scene removeAllChildren];
    [self.view presentScene:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGameNotificationPause object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGameNotificationResume object:nil];
}

@end
