//
//  ViewController.m
//  CAGame
//
//  Created by Ilhan Raja on 6/9/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "GameAPI.h"
#import "MainMenuViewController.h"
#import "TITEViewController.h"
#import "GameStateMenuVC.h"
#import "HelpMenuVC.h"
#import "SettingsMenuVC.h"
#import "AppDelegate.h"
#import "Player.h"
#import "UIImage+Color.h"


@interface MainMenuViewController () {
    
}

@property (strong,nonatomic) NSTimer *updateFrame;
@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong,nonatomic) UIButton *playButton;
@property (strong,nonatomic) CALayer *playText;
@property (strong,nonatomic) UIButton *helpButton;
@property (strong,nonatomic) CALayer *helpText;
@property (strong,nonatomic) UIButton *settingsButton;
@property (strong,nonatomic) CALayer *settingsText;

@end

@implementation MainMenuViewController

@dynamic view;

-(void)loadView{
    self.view = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseUpdateFrame:) name:kMainMenuPauseFrame object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playUpdateFrame:) name:kMainMenuResumeFrame object:nil];
    [super viewDidLoad];
    [self setUptapGesture];
    [self setUpPlayer];
    [self setUpView];
    [self authenticateLocalPlayer];

    // sets up the Layers
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!self.updateFrame){
        self.updateFrame = [NSTimer scheduledTimerWithTimeInterval:2.5f/11 target:self selector:@selector(updateFrame:) userInfo:nil repeats:YES];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    TITEViewController *rootViewController;
    if([self.parentViewController isKindOfClass:[TITEViewController class]]){
        rootViewController  = (TITEViewController*)self.parentViewController;
    }
    __weak typeof(self) weakSelf = self;
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [weakSelf presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                
                rootViewController.gameCenterEnabled = YES;
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                     //   _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                rootViewController.gameCenterEnabled = NO;
            }
        }
    };
}

static int frameCount;

-(UIImage*)imageWithFrameCount{
    if(frameCount>=11)frameCount=0;
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"mm%d",++frameCount] ofType:@"png"]];
}

-(void)updateFrame:(NSTimer*)timer{
    self.view.image = [self imageWithFrameCount];
}

-(void)setUpView{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self setUpPadView];
    }else{
        [self setUpPhoneView];
    }
}

-(void)setUpPadView{
    
}

-(void)setUpPhoneView{
    self.view.image = [self imageWithFrameCount];
    self.updateFrame = [NSTimer scheduledTimerWithTimeInterval:2.5f/11 target:self selector:@selector(updateFrame:) userInfo:nil repeats:YES];

    UIImage *playButton = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"playbutton" ofType:@"png"]];
    UIImage *optionsButton = [UIImage imageNamed:@"button.png"];
    id playText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"]].CGImage;
    id helpText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"png"]].CGImage;
    id settingsText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"png"]].CGImage;
    
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playText = [CALayer layer];
    self.helpText = [CALayer layer];
    self.settingsText = [CALayer layer];


    [self.playButton setImage:playButton forState:
                    UIControlStateNormal];
    [self.helpButton setImage:optionsButton forState:
                    UIControlStateNormal];
    [self.settingsButton setImage:optionsButton forState:
                    UIControlStateNormal];
    self.playText.contents = playText;
    self.helpText.contents = helpText;
    self.settingsText.contents = settingsText;
    
    
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    CGRect frame;
    
    CGSize buttonSize;
    
    frame = CGRectMake(screen.size.width/5,
                      screen.size.height/1.4,
                      screen.size.width/6,
                      screen.size.height/5);
    
    buttonSize = frame.size;
    self.playButton.frame = frame;
    
    frame = CGRectMake(buttonSize.width/12,
                      buttonSize.height/2.5,
                      buttonSize.width/1.2,
                      buttonSize.height/2.5);
    
    self.playText.frame = frame;
    
    frame = CGRectMake(screen.size.width/2.25,
                      screen.size.height/1.3,
                      screen.size.width/6,
                      screen.size.height/8);
    
    buttonSize = frame.size;
    self.helpButton.frame = frame;
    
    frame = CGRectMake(buttonSize.width/8,
                      buttonSize.height/4.5,
                      buttonSize.width/1.3,
                      buttonSize.height/1.85);
    self.helpText.frame = frame;
    
    frame = CGRectMake(screen.size.width/1.45,
                      screen.size.height/1.3,
                      screen.size.width/6,
                      screen.size.height/8);
    
    buttonSize = frame.size;
    self.settingsButton.frame = frame;
    
    frame = CGRectMake(buttonSize.width/12,
                      buttonSize.height/4,
                      buttonSize.width/1.2,
                      buttonSize.height/1.9);
    
    self.settingsText.frame = frame;
    
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.helpButton];
    [self.view addSubview:self.settingsButton];
    [[self.playButton layer] addSublayer:self.playText];
    [[self.helpButton layer] addSublayer:self.helpText];
    [[self.settingsButton layer] addSublayer:self.settingsText];
}

-(void)setUptapGesture{
    self.tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapView:)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.tapGesture.cancelsTouchesInView = NO;

}

-(void)setUpPlayer{
    [Player loadPlayerInstance];
}

-(void)dealloc{
    [self cleanUpMainMenuItems];
}

-(void)cleanUpMainMenuItems{
    [self invalidateUpdateFrameTimer];
    [self.playButton removeFromSuperview];
    [self.settingsButton removeFromSuperview];
    [self.helpButton removeFromSuperview];
    [self.playText removeFromSuperlayer];
    [self.helpText removeFromSuperlayer];
    [self.settingsText removeFromSuperlayer];
    self.playButton = nil;
    self.helpButton = nil;
    self.settingsButton = nil;
    self.playText = nil;
    self.helpText = nil;
    self.settingsText = nil;
    
}

-(void)pauseUpdateFrame:(NSNotification*)notification{
    if([notification.name isEqualToString:kMainMenuPauseFrame]){
        [self invalidateUpdateFrameTimer];
    }
}

-(void)playUpdateFrame:(NSNotification*)notification{
    if([notification.name isEqualToString:kMainMenuResumeFrame]){
        self.updateFrame = [NSTimer scheduledTimerWithTimeInterval:2.5/11 target:self selector:@selector(updateFrame:) userInfo:nil repeats:YES];
    }
}

-(void)invalidateUpdateFrameTimer{
    [self.updateFrame invalidate];
    self.updateFrame = nil;
}

-(void)tapView:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self.view];
    if(CGRectContainsPoint(self.playButton.frame, point)){
        [self invalidateUpdateFrameTimer];
        GameStateMenuVC *gameStateMenuVC = [[GameStateMenuVC alloc] init];
        UIViewController *parentVC = self.parentViewController;
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [parentVC addChildViewController:gameStateMenuVC];
        [parentVC.view addSubview:gameStateMenuVC.view];
        [gameStateMenuVC didMoveToParentViewController:parentVC];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [parentVC.view.layer addAnimation:transition forKey:nil];
        
    }else if(CGRectContainsPoint(self.helpButton.frame,point)){
        [self invalidateUpdateFrameTimer];
        HelpMenuVC *helpMenuVC = [[HelpMenuVC alloc] init];
        UIViewController *parentVC = self.parentViewController;
        [self.view removeFromSuperview];
        [parentVC addChildViewController:helpMenuVC];
        [parentVC.view addSubview:helpMenuVC.view];
        [helpMenuVC didMoveToParentViewController:parentVC];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [parentVC.view.layer addAnimation:transition forKey:nil];
    }else if(CGRectContainsPoint(self.settingsButton.frame, point)){
        [self invalidateUpdateFrameTimer];
        SettingsMenuVC *settingsMenuVC = [[SettingsMenuVC alloc] init];
        UIViewController *parentVC = self.parentViewController;
        [self.view removeFromSuperview];
        [parentVC addChildViewController:settingsMenuVC];
        [parentVC.view addSubview:settingsMenuVC.view];
        [settingsMenuVC didMoveToParentViewController:parentVC];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [parentVC.view.layer addAnimation:transition forKey:nil];
    }
}


@end

