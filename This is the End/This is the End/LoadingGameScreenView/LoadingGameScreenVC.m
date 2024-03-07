//
//  LoadingGameScreenVC.m
//  This is the End
//
//  Created by Ilhan Raja on 7/1/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import "LoadingGameScreenVC.h"
#import "AppDelegate.h"
#import "GameData.h"
#import "GameInstanceVC.h"
#import "GameStateMenuVC.h"
#import "TITEViewController.h"

@interface LoadingGameScreenVC ()

@property (assign, nonatomic) BOOL gameIsReady;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIImageView *loadingScreen;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) CALayer *cancelText;
@property (strong, nonatomic) NSTimer *updateFrame;
@property (strong, nonatomic) NSTimer *gameReadyCheck;


@end


@implementation LoadingGameScreenVC

static int32_t frameCount;

- (instancetype)init
{
    self = [super init];

    if (self) {
        _gameIsReady = NO;
        _loadingScreen = [[UIImageView alloc] init];
        _indicator =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelText = [CALayer layer];

        [self setUpTapGesture];
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpLoadingGameScreen];

    self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self startLoadingGame];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setUpData
{
    if (!self.loadingScreen) {
        self.loadingScreen = [[UIImageView alloc] init];
    }
    if (!self.indicator) {
        self.indicator =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    if (!self.cancelButton) {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    if (!self.cancelText) {
        self.cancelText = [CALayer layer];
    }

    frameCount = 0;
}

- (UIImage *)imageWithFrameCount
{
    if (frameCount >= 21)
        frameCount = 0;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return
            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                 pathForResource:[NSString stringWithFormat:@"ls-iPad%d", ++frameCount]
                                                          ofType:@"png"]];
    }

    return [UIImage
        imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ls%d", ++frameCount]
                                                                ofType:@"png"]];
}

- (void)updateFrame:(NSTimer *)timer
{
    self.loadingScreen.image = [self imageWithFrameCount];
}

- (void)setUpLoadingGameScreen
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self setUpPadView];
    } else {
        [self setUpPhoneView];
    }
}

- (void)setUpPadView
{
}

- (void)setUpPhoneView
{
    [self setUpData];

    self.loadingScreen.frame = self.view.bounds;
    self.loadingScreen.image = [self imageWithFrameCount];

    __weak typeof(self) weakSelf = self;

    self.updateFrame = [NSTimer scheduledTimerWithTimeInterval:4.0f / 21
                                                        target:weakSelf
                                                      selector:@selector(updateFrame:)
                                                      userInfo:nil
                                                       repeats:YES];

    [self.view addSubview:self.loadingScreen];

    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    self.cancelText.contents =
        (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cancel" ofType:@"png"]].CGImage;


    CGRect frame;
    CGSize size = self.view.frame.size;

    frame = CGRectMake(size.width / 8, size.height / 5, size.width / 8, size.height / 5);

    self.indicator.frame = frame;
    self.indicator.color = [UIColor greenColor];
    [self.view addSubview:self.indicator];
    [self.indicator startAnimating];

    frame = CGRectMake(size.width / 2.5, size.height / 1.18, size.width / 6, size.height / 8);
    self.cancelButton.frame = frame;
    [self.view addSubview:self.cancelButton];

    CGSize buttonSize = frame.size;
    frame = CGRectMake(buttonSize.width / 8, buttonSize.height / 4, buttonSize.width / 1.25, buttonSize.height / 2);
    self.cancelText.frame = frame;
    [self.cancelButton.layer addSublayer:self.cancelText];
}

static GameInstanceVC *game;

- (void)startLoadingGame
{
    __weak typeof(self) weakSelf = self;

    self.gameReadyCheck = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                           target:weakSelf
                                                         selector:@selector(checkIfGameIsReady:)
                                                         userInfo:nil
                                                          repeats:NO];

    if ([self.parentViewController isKindOfClass:[TITEViewController class]]) {
        TITEViewController *parentViewController = (TITEViewController *)self.parentViewController;

        parentViewController.gameDataSelected = self.state;
    }

    game = [[GameInstanceVC alloc] init];

    self.gameIsReady = YES;
}

- (void)checkIfGameIsReady:(NSTimer *)timer
{
    if (self.gameIsReady) {
        [timer invalidate];

        UIViewController *parentVC = self.parentViewController;

        [self.view removeFromSuperview];
        [self removeFromParentViewController];

        [parentVC addChildViewController:game];
        [parentVC.view addSubview:game.view];

        [game didMoveToParentViewController:parentVC];

        CATransition *transition = [CATransition animation];

        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFade;

        [parentVC.view.layer addAnimation:transition forKey:nil];

        [self cleanUpLoadingGameScreen];

        game = nil;
    } else if (timer.timeInterval == 0.0f) {
        [timer invalidate];

        __weak typeof(self) weakSelf = self;

        self.gameReadyCheck = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                               target:weakSelf
                                                             selector:@selector(checkIfGameIsReady:)
                                                             userInfo:nil
                                                              repeats:YES];
    }
}

- (void)cleanUpLoadingGameScreen
{
    [self.updateFrame invalidate];
    [self.gameReadyCheck invalidate];
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.cancelText removeFromSuperlayer];
    [self.loadingScreen stopAnimating];
    [self.loadingScreen removeFromSuperview];
    self.gameReadyCheck = nil;
    self.updateFrame = nil;
    self.loadingScreen = nil;
    self.indicator = nil;
    self.cancelButton = nil;
    self.cancelText = nil;
}

- (void)dealloc
{
    [self cleanUpLoadingGameScreen];
}

- (void)setUpTapGesture
{
    self.tapGesture =

        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];

    [self.view addGestureRecognizer:self.tapGesture];

    self.tapGesture.cancelsTouchesInView = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)tapView:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];

    if (CGRectContainsPoint(self.cancelButton.frame, point)) {
        if ([self.parentViewController isKindOfClass:[TITEViewController class]]) {
            TITEViewController *parentViewController = (TITEViewController *)self.parentViewController;

            parentViewController.gameDataSelected = nil;
        }

        self.state = nil;

        GameStateMenuVC *gameStateMenuVC = [[GameStateMenuVC alloc] init];

        UIViewController *parentVC = self.parentViewController;

        [parentVC addChildViewController:gameStateMenuVC];

        [gameStateMenuVC didMoveToParentViewController:parentVC];

        __weak typeof(self) weakSelf = self;

        [self cleanUpLoadingGameScreen];

        game = nil;

        [parentVC transitionFromViewController:self
                              toViewController:gameStateMenuVC
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionFlipFromBottom
                                    animations:nil
                                    completion:^(BOOL didComplete) {
                                      [weakSelf.view removeFromSuperview];
                                      [weakSelf removeFromParentViewController];
                                    }];
    }
}

@end
