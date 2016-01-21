//
//  StoreViewController.m
//  This is the End
//
//  Created by Ilhan Raja on 1/20/16.
//  Copyright © 2016 Ilhan-Parker. All rights reserved.
//

#import "StoreViewController.h"
#import "GameStateMenuVC.h"
#import "Badge.h"
#import "PowerUp.h"

NSString *kStoreVCDismissKey = @"storeDismissKey";

@interface StoreViewController () {
    
}


@property (strong,nonatomic) UIScrollView *storeContents;
@property (strong,nonatomic) UIButton *backButton;
@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong,nonatomic) CALayer *line1;
@property (strong,nonatomic) CALayer *line2;
@property (strong,nonatomic) CALayer *line3;
@property (strong,nonatomic) CALayer *line4;

@end

@implementation StoreViewController


-(instancetype)init{
    self = [super init];
    if(self) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _line1 = [CALayer layer];
        _line2 = [CALayer layer];
        _line3 = [CALayer layer];
        _line4 = [CALayer layer];
        [self setUpTapGesture];
    }
    return self;
}

-(void)loadView{
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(screen.size.width/8,
                                                         screen.size.height/8,
                                                         screen.size.width*3/4,
                                                         screen.size.height*3/4)];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    UIImage *store = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"store" ofType:@"png"]];
    UIImage *button = [UIImage imageNamed:@"button.png"];
    
    if(!store){
        NSLog(@"Panic");
    }
    
    id back = (id)[UIImage imageNamed:@"back.png"].CGImage;
    id border = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heightborder"
                                                                                     ofType:@"png"]].CGImage;
    self.line1.anchorPoint = CGPointMake(0,0);
    self.line2.anchorPoint = CGPointMake(0,0);
    self.line3.anchorPoint = CGPointMake(0,0);
    self.line4.anchorPoint = CGPointMake(0,0);
    
    self.line1.contents = border;
    self.line2.contents = border;
    self.line3.contents = border;
    self.line4.contents = border;
    
    CGRect frame;
    CGRect lineVerticalFrame;
    CGRect lineHorizontalFrame;
    CGRect screen = self.view.frame;
    CGSize size = screen.size;
    lineHorizontalFrame.size = CGSizeMake(screen.size.width,
                                          screen.size.height/
                                          (screen.size.width/(55/2)));
    lineVerticalFrame.size = CGSizeMake(screen.size.height,
                                        screen.size.height/
                                        (screen.size.width/(55/2)));
    lineHorizontalFrame.origin = CGPointMake(0,0);
    [self.line1 setFrame:lineHorizontalFrame];
    lineVerticalFrame.origin = CGPointMake(screen.size.width,0);
    [self.line2 setFrame:lineVerticalFrame];
    self.line2.transform = CATransform3DMakeRotation(M_PI/2,0,0,1);
    lineHorizontalFrame.origin = CGPointMake(screen.size.width,
                               screen.size.height);
    [self.line3 setFrame:lineHorizontalFrame];
    self.line3.transform = CATransform3DMakeRotation(M_PI,0,0,1);
    lineVerticalFrame.origin = CGPointMake(0,screen.size.height);
    [self.line4 setFrame:lineVerticalFrame];
    self.line4.transform = CATransform3DMakeRotation(-M_PI/2,0,0,1);
    [[self.view layer] addSublayer:self.line2];
    [[self.view layer] addSublayer:self.line4];
    [[self.view layer] addSublayer:self.line1];
    [[self.view layer] addSublayer:self.line3];
    
    
    CALayer *storeText = [CALayer layer];
    storeText.contents = (id)store.CGImage;
    frame = CGRectMake(size.width/2.75,
                       size.height/12,
                       size.width/4,
                       size.height/8);
    storeText.frame = frame;
    [self.view.layer addSublayer:storeText];
    
    frame = CGRectMake(size.width/20,
                       size.height/16,
                       size.width/7,
                       size.height/7);
    self.backButton.frame = frame;
    [self.backButton setBackgroundImage:button forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    
    CGSize buttonSize = self.backButton.frame.size;
    frame = CGRectMake(buttonSize.width/6,
                       buttonSize.height/4,
                       buttonSize.width/1.5,
                       buttonSize.height/2);
    CALayer *backText = [CALayer layer];
    backText.frame = frame;
    backText.contents = back;
    [[self.backButton layer] addSublayer:backText];
    
    self.storeContents = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/8,
                                                                        self.view.frame.size.height/4,
                                                                        self.view.frame.size.width*3/4,
                                                                        self.view.frame.size.height*2/3)];
    
    CGSize storeItemSize = CGSizeMake(self.view.frame.size.width*3/4,
                                      self.view.frame.size.height/6);
    self.storeContents.backgroundColor = [UIColor grayColor];
    [self.storeContents setContentSize:CGSizeMake(storeItemSize.width,
                                                  storeItemSize.height*(numberOfBadges+numberOfPowerUps))];
    [self.view addSubview:self.storeContents];
    self.storeContents.showsVerticalScrollIndicator=YES;
    self.storeContents.scrollEnabled = YES;
    self.storeContents.userInteractionEnabled = YES;
    
    CGFloat y = 0;
    for(int i=0; i<(numberOfBadges+numberOfPowerUps); i++){
        CGRect frame = CGRectMake(0,y,storeItemSize.width,storeItemSize.height);
        UIView *cell = [[UIView alloc] initWithFrame:frame];
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.layer.borderWidth = storeItemSize.height/15;
        [self.storeContents addSubview:cell];
        y+=storeItemSize.height;
    }
}


-(void)setUpTapGesture{
    self.tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapView:)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.tapGesture.cancelsTouchesInView = NO;
}

-(void)tapView:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self.view];
    if(CGRectContainsPoint(self.backButton.frame,point)){
        CGRect oldFrame = self.view.frame;
        CGRect newFrame = CGRectMake(oldFrame.origin.x,
                                     -oldFrame.size.height,
                                     oldFrame.size.width,
                                     oldFrame.size.height);
        [UIView animateWithDuration:0.8 animations:^{
            [self.view setFrame:newFrame];
        } completion:^(BOOL completion){
            if(completion){
                [self.view removeFromSuperview];
                for(UIViewController *controller in [self.parentViewController childViewControllers]){
                    if([controller isKindOfClass:[GameStateMenuVC class]]){
                        controller.view.userInteractionEnabled = YES;
                    }
                }
                [self removeFromParentViewController];
            }
        }];
    }
}



@end
