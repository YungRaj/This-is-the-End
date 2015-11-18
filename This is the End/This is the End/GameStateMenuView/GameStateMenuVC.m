//
//  GameStateMenuVC.m
//  This is the End
//
//  Created by Ilhan Raja on 6/21/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import "GameStateMenuVC.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "GameStateView.h"
#import "GameData.h"
#import "LoadingGameScreenVC.h"

#define numberOfGameStates 5

@interface GameStateMenuVC () {
    
}


@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong,nonatomic) CALayer *selectGameTitle;
@property (strong,nonatomic) UIButton *backButton;
@property (strong,nonatomic) CALayer *backText;
@property (strong,nonatomic) UIButton *store;
@property (strong,nonatomic) NSArray *gameStateViews;
@property (strong,nonatomic) GameData *dataAlertViewSelected;
@property (strong,nonatomic) CALayer *line1;
@property (strong,nonatomic) CALayer *line2;
@property (strong,nonatomic) CALayer *line3;
@property (strong,nonatomic) CALayer *line4;

@end

@implementation GameStateMenuVC


-(instancetype)init{
    self = [super init];
    if(self){
        _selectGameTitle = [CALayer layer];
        _gameStateViews = [[NSArray alloc]init];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backText = [CALayer layer];
        _store = [UIButton buttonWithType:UIButtonTypeCustom];
        _line1 = [CALayer layer];
        _line2 = [CALayer layer];
        _line3 = [CALayer layer];
        _line4 = [CALayer layer];
        [self setUpTapGesture];
    }
    return self;
}

-(void)setUpData{
    if(!self.selectGameTitle){
        self.selectGameTitle = [CALayer layer];
    }if(!self.backButton){
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.backText){
        self.backText = [CALayer layer];
    }if(!self.store){
        self.store = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.line1){
        self.line1 = [CALayer layer];
    }if(!self.line2){
        self.line2 = [CALayer layer];
    }if(!self.line3){
        self.line3 = [CALayer layer];
    }if(!self.line4){
        self.line4 = [CALayer layer];
    }
}


-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    [self setUpData];
    
    id selectGameTitle = (id)[UIImage imageNamed:@"selectgame.png"].CGImage;
    UIImage *button = [UIImage imageNamed:@"button.png"];
    id backText = (id)[UIImage imageNamed:@"back.png"].CGImage;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];

    
    CGSize size = self.view.bounds.size;
    CGRect frame;
    
    frame = CGRectMake(size.width/3,
                      size.height/16,
                      size.width/3,
                      size.height/8);
    self.selectGameTitle.frame = frame;
    self.selectGameTitle.contents = selectGameTitle;
    [[self.view layer] addSublayer:self.selectGameTitle];
    
    [self setUpGameStateViews];
    
    frame = CGRectMake(size.width/20,
                      size.height/16,
                      size.width/8,
                      size.height/8);
    self.backButton.frame = frame;
    [self.backButton setBackgroundImage:button forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    
    CGSize buttonSize = self.backButton.frame.size;
    frame = CGRectMake(buttonSize.width/6,
                      buttonSize.height/4,
                      buttonSize.width/1.5,
                      buttonSize.height/2);
    self.backText.frame = frame;
    self.backText.contents = backText;
    [[self.backButton layer] addSublayer:self.backText];
    
    frame = self.view.frame;
    self.store.frame = CGRectMake(frame.size.width-(frame.size.width/12+frame.size.height/12),
                                  frame.size.height/16,
                                  frame.size.width/12,
                                  frame.size.height/8);
    [self.store setBackgroundImage:[UIImage imageWithContentsOfFile:
                                    [[NSBundle mainBundle] pathForResource:@"squarebutton" ofType:@"png"]]
                                forState:UIControlStateNormal];
    [self.view addSubview:self.store];
    CGRect storeFrame = self.store.frame;
    CALayer *storeIcon = [CALayer layer];
    storeIcon.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shopsymbol" ofType:@"png"]].CGImage;
    storeIcon.frame = CGRectMake(storeFrame.size.width/4,
                                 storeFrame.size.height/4,
                                 storeFrame.size.width/1.8,
                                 storeFrame.size.height/2.25);
    [self.store.layer addSublayer:storeIcon];
    
    id border = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heightborder" ofType:@"png"]].CGImage;
    self.line1.anchorPoint = CGPointMake(0,0);
    self.line2.anchorPoint = CGPointMake(0,0);
    self.line3.anchorPoint = CGPointMake(0,0);
    self.line4.anchorPoint = CGPointMake(0,0);
    
    self.line1.contents = border;
    self.line2.contents = border;
    self.line3.contents = border;
    self.line4.contents = border;
    
    CGRect screen = [UIScreen mainScreen].bounds;
    frame.size = CGSizeMake(screen.size.width,
                            screen.size.height/
                            (screen.size.width/(55/2.25)));
    frame.origin = CGPointMake(0,0);
    [self.line1 setFrame:frame];
    frame.origin = CGPointMake(screen.size.width,0);
    [self.line2 setFrame:frame];
    self.line2.transform = CATransform3DMakeRotation(M_PI/2,0,0,1);
    frame.origin = CGPointMake(screen.size.width
                               ,screen.size.height);
    [self.line3 setFrame:frame];
    self.line3.transform = CATransform3DMakeRotation(M_PI,0,0,1);
    frame.origin = CGPointMake(0,screen.size.height);
    [self.line4 setFrame:frame];
    self.line4.transform = CATransform3DMakeRotation(-M_PI/2,0,0,1);
    [[self.view layer] addSublayer:self.line2];
    [[self.view layer] addSublayer:self.line4];
    [[self.view layer] addSublayer:self.line1];
    [[self.view layer] addSublayer:self.line3];
}

-(void)setUpGameStateViews{
    CGSize size = self.view.bounds.size;
    CGSize gameStateSize = CGSizeMake(size.width/1.2,
                                      size.height/7);
    CGRect frame;
    if([self.gameStateViews count]==5U){
        for(GameStateView *gameStateView in self.gameStateViews){
            [gameStateView setUpSubViews];
        }
    }else{
        frame.origin = CGPointMake(size.width/12,
                                   size.height/4.5);
        frame.size = gameStateSize;
        
        NSMutableArray *tempStates = [[NSMutableArray alloc]init];
        for(int i=0; i<numberOfGameStates; i++){
            GameStateView *view = [[GameStateView alloc] initWithFrame:frame
                                                      gameStateData:[GameData loadInstanceWithState:i]];
            [view setUpSubViews];
            [self.view addSubview:view];
            [tempStates addObject:view];
            frame.origin.y+=frame.size.height;
        }
        self.gameStateViews = [NSArray arrayWithArray:tempStates];
    }
}


-(void)setUpTapGesture{
    self.tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapView:)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.tapGesture.cancelsTouchesInView = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    [self cleanUpViews];
}

-(void)cleanUpViews{
    [self cleanUpGameStateViews];
    [self.selectGameTitle removeFromSuperlayer];
    [self.backText removeFromSuperlayer];
    [self.backButton removeFromSuperview];
    [self.line1 removeFromSuperlayer];
    [self.line2 removeFromSuperlayer];
    [self.line3 removeFromSuperlayer];
    [self.line4 removeFromSuperlayer];
    self.selectGameTitle = nil;
    self.backText = nil;
    self.backButton = nil;
    self.line1 = nil;
    self.line2 = nil;
    self.line3 = nil;
    self.line4 = nil;
}

-(void)cleanUpGameStateViews{
    for(GameStateView *stateView in self.gameStateViews){
        [stateView cleanUpView];
    }
}

- (void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Yes"]){
        [self.dataAlertViewSelected removefilePathAtState:self.dataAlertViewSelected.state];
        [self cleanUpGameStateViews];
        [self setUpGameStateViews];
    }
    self.dataAlertViewSelected = nil;
}

-(void)tapView:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self.view];
    for(NSUInteger i=0; i<[self.gameStateViews count]; i++){
        GameStateView *stateView = [self.gameStateViews objectAtIndex:i];
        GameData *stateData = stateView.data;
        if(CGRectContainsPoint([stateView.play.superview
                                convertRect:stateView.play.frame
                                toView:self.view],point)){
            LoadingGameScreenVC *loadingGameScreenVC = [[LoadingGameScreenVC alloc] init];
            loadingGameScreenVC.state = stateData;
            UIViewController *parentVC = self.parentViewController;
            [parentVC addChildViewController:loadingGameScreenVC];
            [loadingGameScreenVC didMoveToParentViewController:parentVC];
            __weak typeof(self) weakSelf = self;
            [parentVC transitionFromViewController:self toViewController:loadingGameScreenVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                                        animations:nil completion:^(BOOL didComplete){
                        [weakSelf.view removeFromSuperview];
                        [weakSelf removeFromParentViewController];
            }];
            
        }else if(CGRectContainsPoint([stateView.createGame.superview
                                      convertRect:stateView.createGame.frame
                                      toView:self.view],point)){
            if(stateView.data.filePathExists){
                UIAlertView *alertView = [[UIAlertView alloc]init];
                alertView.delegate = self;
                alertView.alertViewStyle = UIAlertViewStyleDefault;
                alertView.title = @"This is the End";
                alertView.message = @"You are about to remove game state data and create a new game. Continue?";
                [alertView addButtonWithTitle:@"Yes"];
                [alertView addButtonWithTitle:@"No"];
                [alertView show];
                self.dataAlertViewSelected = stateData;
            }else{
                [stateData saveToState:stateData.state];
                [self cleanUpGameStateViews];
                [self setUpGameStateViews];
            }
        }
    }
    if(CGRectContainsPoint(self.backButton.frame,point)){
        MainMenuViewController *mainMenuVC = [[MainMenuViewController alloc] init];
        UIViewController *parentVC = self.parentViewController;
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [parentVC addChildViewController:mainMenuVC];
        [parentVC.view addSubview:mainMenuVC.view];
        [mainMenuVC didMoveToParentViewController:parentVC];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [parentVC.view.layer addAnimation:transition forKey:nil];
    }if(CGRectContainsPoint(self.store.frame,point)){
        
    }
}


@end
