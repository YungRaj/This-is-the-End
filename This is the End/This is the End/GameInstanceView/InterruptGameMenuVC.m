//
//  PauseMenuVC.m
//  This is the End
//
//  Created by Ilhan Raja on 7/24/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "GameAPI.h"
#import "InterruptGameMenuVC.h"
#import "GameStateMenuVC.h"
#import "GameInstanceVC.h"
#import "TITEViewController.h"
#import "GameData.h"

@interface InterruptGameMenuVC () {
    
}

@property (assign,nonatomic) InterruptedGameMode mode;
@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong,nonatomic) UIView *interruptView;
@property (strong,nonatomic) UIButton *continueGame;
@property (strong,nonatomic) UIButton *saveAndQuit;
@property (strong,nonatomic) UIButton *quit;
@property (strong,nonatomic) UIButton *store;

@end

@implementation InterruptGameMenuVC

-(instancetype)initWithType:(InterruptedGameMode)mode{
    self = [super init];
    if(self){
        _mode = mode;
        [self setUpTapGesture];
    }
    return self;
}

-(void)setUpTapGesture{
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.tapGesture.cancelsTouchesInView = NO;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInterruptGame];
    switch(self.mode){
        case InterruptedGameOver: [self setUpGameOverMenu]; break;
        case InterruptedGamePaused: [self setUpPauseMenu]; break;
        case InterruptedGameLevelCompleted: break;
        case InterruptedGameWorldCompleted: break;
        default: break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpInterruptGame{
    self.interruptView = [[UIView alloc] init];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    self.interruptView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    CGPoint center = CGPointMake(self.view.frame.size.width/2,
                                 self.view.frame.size.height/2);
    CGFloat width = self.view.frame.size.width/1.5;
    CGFloat height = self.view.frame.size.height/1.2;
    CGRect frame = CGRectMake(center.x-width/2,
                              center.y-height/2,
                              width,
                              height);
    self.interruptView.frame = frame;
    
    UIImage *border = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heightborder" ofType:@"png"]];
    CALayer *line1 = [CALayer layer];
    line1.contents = (id)border.CGImage;
    line1.frame = CGRectMake(0,0,
                             frame.size.width,
                             frame.size.height/15);
    
    CALayer *line2 = [CALayer layer];
    line2.contents = (id)border.CGImage;
    line2.anchorPoint = CGPointMake(0,0);
    line2.contents = (id)border.CGImage;
    line2.frame = CGRectMake(frame.size.width,0,
                             frame.size.height,
                             frame.size.height/15);
    line2.transform = CATransform3DMakeRotation(M_PI/2,0,0,1);
    [self.interruptView.layer addSublayer:line2];
    CALayer *line3 = [CALayer layer];
    line3.contents = (id)border.CGImage;
    line3.anchorPoint = CGPointMake(0,0);
    line3.contents = (id)border.CGImage;
    line3.frame = CGRectMake(frame.size.width,frame.size.height,
                             frame.size.width,
                             frame.size.height/15);
    line3.transform = CATransform3DMakeRotation(M_PI,0,0,1);
    [self.interruptView.layer addSublayer:line3];
    CALayer *line4 = [CALayer layer];
    line4.contents = (id)border.CGImage;
    line4.anchorPoint = CGPointMake(0,0);
    line4.contents = (id)border.CGImage;
    line4.frame = CGRectMake(0,frame.size.height,
                             frame.size.height,
                             frame.size.height/15);
    line4.transform = CATransform3DMakeRotation(-M_PI/2,0,0,1);
    [self.interruptView.layer addSublayer:line4];
    [self.interruptView.layer addSublayer:line1];
    
    [self.view addSubview:self.interruptView];
    
    CALayer *interruption = [CALayer layer];
    id interruptionText;
    switch(self.mode){
        case InterruptedGameOver: interruptionText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gameover" ofType:@"png"]].CGImage;
            interruption.frame = CGRectMake(frame.size.width/4,
                                            frame.size.height/5,
                                            frame.size.width/2,
                                            frame.size.height/4);
            
        break;
        case InterruptedGamePaused: interruptionText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"paused" ofType:@"png"]].CGImage;
            interruption.frame = CGRectMake(frame.size.width/3,
                                            frame.size.height/4,
                                            frame.size.width/3,
                                            frame.size.height/6);
        break;
        default: break;
    }
    interruption.contents = interruptionText;
    
    [self.interruptView.layer addSublayer:interruption];
}

-(void)setUpGameOverMenu{
    if(!self.continueGame){
        self.continueGame = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.quit){
        self.quit = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.store){
        self.store = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    CGRect frame = self.interruptView.frame;
    
    UIImage *button = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button" ofType:@"png"]];
    UIImage *squareButton = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"squarebutton" ofType:@"png"]];
    [self.continueGame setBackgroundImage:button forState:UIControlStateNormal];
    self.continueGame.frame = CGRectMake(frame.size.width/6,
                                         frame.size.height/1.8,
                                         frame.size.width/5,
                                         frame.size.height/6);
    [self.interruptView addSubview:self.continueGame];
    CGRect continueGameButtonFrame = self.continueGame.frame;
    CALayer *retryText = [CALayer layer];
    retryText.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"retry" ofType:@"png"]].CGImage;
    retryText.frame = CGRectMake(continueGameButtonFrame.size.width/8,
                                     continueGameButtonFrame.size.height/3.5,
                                     continueGameButtonFrame.size.width/2,
                                     continueGameButtonFrame.size.height/2.4);
    [self.continueGame.layer addSublayer:retryText];
    CALayer *retrySymbol = [CALayer layer];
    retrySymbol.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"retrysymbol" ofType:@"png"]].CGImage;
    retrySymbol.frame = CGRectMake(continueGameButtonFrame.size.width*.7,
                                   continueGameButtonFrame.size.height/3,
                                   continueGameButtonFrame.size.width/6,
                                   continueGameButtonFrame.size.height/3);
    [self.continueGame.layer addSublayer:retrySymbol];
    
    [self.quit setBackgroundImage:button forState:UIControlStateNormal];
    self.quit.frame = CGRectMake(frame.size.width/6+frame.size.width/5+frame.size.width/12,
                                 frame.size.height/1.8,
                                 frame.size.width/5,
                                 frame.size.height/6);
    [self.interruptView addSubview:self.quit];
    CALayer *quitText = [CALayer layer];
    quitText.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"quit" ofType:@"png"]].CGImage;
    quitText.frame = CGRectMake(self.quit.frame.size.width/6,
                               self.quit.frame.size.height/4,
                               self.quit.frame.size.width/1.5,
                               self.quit.frame.size.height/2);
    [self.quit.layer addSublayer:quitText];
    
    self.store.frame = CGRectMake(frame.size.width/6+frame.size.width*2/5+frame.size.width/12+frame.size.width/12,
                                  frame.size.height/1.8,
                                  frame.size.width/8,
                                  frame.size.height/6);
    [self.store setBackgroundImage:squareButton forState:UIControlStateNormal];
    [self.interruptView addSubview:self.store];
    CGRect storeFrame = self.store.frame;
    CALayer *storeIcon = [CALayer layer];
    storeIcon.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shopsymbol" ofType:@"png"]].CGImage;
    storeIcon.frame = CGRectMake(storeFrame.size.width/4,
                                 storeFrame.size.height/4,
                                 storeFrame.size.width/1.8,
                                 storeFrame.size.height/2.25);
    [self.store.layer addSublayer:storeIcon];
}

-(void)setUpPauseMenu{
    if(!self.continueGame){
        self.continueGame = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.saveAndQuit){
        self.saveAndQuit = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.quit){
        self.quit = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.store){
        self.store = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    CGRect frame = self.interruptView.frame;
    UIImage *button = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button" ofType:@"png"]];
    UIImage *squareButton = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"squarebutton" ofType:@"png"]];
    
    [self.continueGame setBackgroundImage:button forState:UIControlStateNormal];
    self.continueGame.frame = CGRectMake(frame.size.width/12,
                                 frame.size.height/2,
                                 frame.size.width/5,
                                 frame.size.height/6);
    [self.interruptView addSubview:self.continueGame];
    
    CGRect continueGameButtonFrame = self.continueGame.frame;
    
    CALayer *playText = [CALayer layer];
    playText.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"]].CGImage;
    playText.frame = CGRectMake(continueGameButtonFrame.size.width/6,
                                    continueGameButtonFrame.size.height/3.5,
                                    continueGameButtonFrame.size.width/2,
                                    continueGameButtonFrame.size.height/2.5);
    [self.continueGame.layer addSublayer:playText];
        CALayer *playSymbol = [CALayer layer];
    playSymbol.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"playsymbol" ofType:@"png"]].CGImage;
    playSymbol.frame = CGRectMake(continueGameButtonFrame.size.width*.7,
                                      continueGameButtonFrame.size.height/3,
                                      continueGameButtonFrame.size.width/4,
                                      continueGameButtonFrame.size.height/3);
    [self.continueGame.layer addSublayer:playSymbol];
    
    self.saveAndQuit.frame = CGRectMake(frame.size.width*3.5/10,
                                        frame.size.height/2,
                                        frame.size.width/3.34,
                                        frame.size.height/6);
    [self.saveAndQuit setBackgroundImage:button forState:UIControlStateNormal];
    [self.interruptView addSubview:self.saveAndQuit];
    
    CGRect saveAndQuitFrame = self.saveAndQuit.frame;
    CALayer *saveAndQuitText = [CALayer layer];
    saveAndQuitText.contents = (id)[UIImage imageWithContentsOfFile:
                          [[NSBundle mainBundle] pathForResource:@"saveandquit"
                                                          ofType:@"png"]].CGImage;
    saveAndQuitText.frame = CGRectMake(saveAndQuitFrame.size.width/12,
                                       saveAndQuitFrame.size.height/4,
                                       saveAndQuitFrame.size.width/1.2,
                                       saveAndQuitFrame.size.height/2.2);
    [self.saveAndQuit.layer addSublayer:saveAndQuitText];
    
    self.quit.frame = CGRectMake((saveAndQuitFrame.origin.x+saveAndQuitFrame.size.width+(saveAndQuitFrame.origin.x-(continueGameButtonFrame.origin.x+continueGameButtonFrame.size.width))),
                                        frame.size.height/2,
                                        frame.size.width/5,
                                        frame.size.height/6);
    [self.quit setBackgroundImage:button forState:UIControlStateNormal];
    [self.interruptView addSubview:self.quit];
    CGRect quitFrame = self.quit.frame;
    CALayer *quitText = [CALayer layer];
    quitText.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"quit" ofType:@"png"]].CGImage;
    quitText.frame = CGRectMake(quitFrame.size.width/6,
                                quitFrame.size.height/4,
                                quitFrame.size.width/1.5,
                                quitFrame.size.height/2);
    [self.quit.layer addSublayer:quitText];
    
    self.store.frame = CGRectMake(frame.size.width/2-frame.size.width/16,
                                  frame.size.height/1.25-frame.size.height/12,
                                  frame.size.width/8,
                                  frame.size.height/6);
    [self.store setBackgroundImage:squareButton forState:UIControlStateNormal];
    [self.interruptView addSubview:self.store];
    CGRect storeFrame = self.store.frame;
    CALayer *storeIcon = [CALayer layer];
    storeIcon.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shopsymbol" ofType:@"png"]].CGImage;
    storeIcon.frame = CGRectMake(storeFrame.size.width/4,
                                 storeFrame.size.height/4,
                                 storeFrame.size.width/1.8,
                                 storeFrame.size.height/2.25);
    [self.store.layer addSublayer:storeIcon];
}

-(void)cleanUpPauseMenu{
    [self.interruptView removeFromSuperview];
    [self.continueGame removeFromSuperview];
    [self.saveAndQuit removeFromSuperview];
    [self.quit removeFromSuperview];
    [self.store removeFromSuperview];
    self.continueGame = nil;
    self.saveAndQuit = nil;
    self.quit = nil;
    self.store = nil;
}

-(void)dealloc{
    [self cleanUpPauseMenu];
}

-(void)tapView:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:self.interruptView];
    if(self.mode==InterruptedGamePaused){
        if(CGRectContainsPoint(self.continueGame.frame,point)){
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFade;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            [[NSNotificationCenter defaultCenter] postNotificationName:kGameNotificationResume object:nil];
            
        }else if(CGRectContainsPoint(self.saveAndQuit.frame,point)){
            [[NSNotificationCenter defaultCenter] postNotificationName:kGameNotificationSave object:nil];
            [self loadGameMenu];
        }else if(CGRectContainsPoint(self.quit.frame,point)){
            [self loadGameMenu];
        }else if(CGRectContainsPoint(self.store.frame,point)){
            
        }
    }else if(self.mode==InterruptedGameOver){
        if(CGRectContainsPoint(self.continueGame.frame,point)){
            UIViewController *parentViewController = self.parentViewController;
            GameInstanceVC *gameInstance = [[GameInstanceVC alloc] init];
            [parentViewController addChildViewController:gameInstance];
            [parentViewController.view addSubview:gameInstance.view];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFade;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [((UIViewController*)[parentViewController.childViewControllers objectAtIndex:0]).view removeFromSuperview];
            [((UIViewController*)[parentViewController.childViewControllers objectAtIndex:1]).view removeFromSuperview];
            [[parentViewController.childViewControllers objectAtIndex:0] removeFromParentViewController];
            [[parentViewController.childViewControllers objectAtIndex:0] removeFromParentViewController];
        }else if(CGRectContainsPoint(self.quit.frame,point)){
            [self loadGameMenu];
        }
    }
}

-(void)loadGameMenu{
    if([self.parentViewController isKindOfClass:[TITEViewController class]]){
        TITEViewController *parentViewController = (TITEViewController*)self.parentViewController;
        parentViewController.gameDataSelected = nil;
    }
    GameStateMenuVC *gameStateMenu = [[GameStateMenuVC alloc] init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFade;
    [self.parentViewController addChildViewController:gameStateMenu];
    [self.parentViewController.view addSubview:gameStateMenu.view];
    [self.parentViewController.view.layer addAnimation:transition forKey:nil];
    GameInstanceVC *gameInstance =
                    (GameInstanceVC*)[self.parentViewController.childViewControllers objectAtIndex:0];
    [gameInstance.view removeFromSuperview];
    [gameInstance removeFromParentViewController];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

-(void)animationDidStart:(CAAnimation *)anim{}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}



@end
