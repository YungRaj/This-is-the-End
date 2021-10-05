//
//  HelpMenuVC.m
//  This is the End
//
//  Created by Ilhan Raja on 6/21/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import "HelpMenuVC.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"


@interface HelpMenuVC ()
{
    
}

@property (strong,nonatomic) UIButton *backButton;
@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong,nonatomic) CALayer *line1;
@property (strong,nonatomic) CALayer *line2;
@property (strong,nonatomic) CALayer *line3;
@property (strong,nonatomic) CALayer *line4;

@end

@implementation HelpMenuVC


-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _line1 = [CALayer layer];
        _line2 = [CALayer layer];
        _line3 = [CALayer layer];
        _line4 = [CALayer layer];
        
        [self setUpTapGesture];
    }
    
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setUpData
{
    if(!self.backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    } if(!self.line1)
    {
        self.line1 = [CALayer layer];
    } if(!self.line2)
    {
        self.line2 = [CALayer layer];
    } if(!self.line3)
    {
        self.line3 = [CALayer layer];
    } if(!self.line4)
    {
        self.line4 = [CALayer layer];
    }
}

-(void)setUpView
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self setUpPadView];
    } else{
        [self setUpPhoneView];
    }
}

-(void)setUpPadView{
    
}

-(void)setUpPhoneView
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    UIImage *button = [UIImage imageNamed:@"button.png"];
    
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
    CGRect screen = [UIScreen mainScreen].bounds;
    CGSize size = screen.size;
    
    frame.size = CGSizeMake(screen.size.width,
                            screen.size.height/
                            (screen.size.width/(55/2)));
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
    CALayer *backText = [CALayer layer];
    backText.frame = frame;
    backText.contents = back;
    [[self.backButton layer] addSublayer:backText];
}

-(MainMenuViewController*)MainMenuViewController
{
    for(UIViewController *childViewController in self.parentViewController.childViewControllers)
    {
        if([childViewController isKindOfClass:[MainMenuViewController class]])
        {
            return (MainMenuViewController*)childViewController;
        }
    }
    
    return nil;
}

-(void)setUpTapGesture
{
    self.tapGesture =
    
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapView:)];
    
    [self.view addGestureRecognizer:self.tapGesture];
    
    self.tapGesture.cancelsTouchesInView = NO;
}

-(void)tapView:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    
    if(CGRectContainsPoint(self.backButton.frame,point))
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromBottom;
        
        MainMenuViewController *mainMenuVC = [self MainMenuViewController];
        
        UIViewController *parentVC = self.parentViewController;
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
       
        [parentVC.view addSubview:mainMenuVC.view];
        [parentVC.view.layer addAnimation:transition forKey:nil];
    }
}


@end
