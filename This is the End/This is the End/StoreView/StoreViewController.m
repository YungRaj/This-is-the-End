//
//  StoreViewController.m
//  This is the End
//
//  Created by Ilhan Raja on 1/20/16.
//  Copyright © 2016 Ilhan-Parker. All rights reserved.
//

#import "StoreViewController.h"
#import "Badge.h"
#import "Coin.h"
#import "GameStateMenuVC.h"
#import "PowerUp.h"

NSString *kStoreVCDismissKey = @"storeDismissKey";

@interface StoreViewController () {
}


@property (strong, nonatomic) UIScrollView *storeContents;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) CALayer *line1;
@property (strong, nonatomic) CALayer *line2;
@property (strong, nonatomic) CALayer *line3;
@property (strong, nonatomic) CALayer *line4;

@end

@implementation StoreViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _line1 = [CALayer layer];
        _line2 = [CALayer layer];
        _line3 = [CALayer layer];
        _line4 = [CALayer layer];
        [self setUpTapGesture];
    }
    return self;
}

- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(screen.size.width / 8, screen.size.height / 8,
                                                         screen.size.width * 3 / 4, screen.size.height * 3 / 4)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)setUpView
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    UIImage *store = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"store" ofType:@"png"]];
    UIImage *button = [UIImage imageNamed:@"button.png"];

    if (!store) {
        NSLog(@"Panic");
    }

    id back = (id)[UIImage imageNamed:@"back.png"].CGImage;
    id border =
        (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heightborder" ofType:@"png"]]
            .CGImage;
    self.line1.anchorPoint = CGPointMake(0, 0);
    self.line2.anchorPoint = CGPointMake(0, 0);
    self.line3.anchorPoint = CGPointMake(0, 0);
    self.line4.anchorPoint = CGPointMake(0, 0);

    self.line1.contents = border;
    self.line2.contents = border;
    self.line3.contents = border;
    self.line4.contents = border;

    CGRect frame;
    CGRect lineVerticalFrame;
    CGRect lineHorizontalFrame;
    CGRect screen = self.view.frame;
    CGSize size = screen.size;
    lineHorizontalFrame.size = CGSizeMake(screen.size.width, screen.size.height / (screen.size.width / (55 / 2)));
    lineVerticalFrame.size = CGSizeMake(screen.size.height, screen.size.height / (screen.size.width / (55 / 2)));
    lineHorizontalFrame.origin = CGPointMake(0, 0);
    [self.line1 setFrame:lineHorizontalFrame];
    lineVerticalFrame.origin = CGPointMake(screen.size.width, 0);
    [self.line2 setFrame:lineVerticalFrame];
    self.line2.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
    lineHorizontalFrame.origin = CGPointMake(screen.size.width, screen.size.height);
    [self.line3 setFrame:lineHorizontalFrame];
    self.line3.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    lineVerticalFrame.origin = CGPointMake(0, screen.size.height);
    [self.line4 setFrame:lineVerticalFrame];
    self.line4.transform = CATransform3DMakeRotation(-M_PI / 2, 0, 0, 1);
    [[self.view layer] addSublayer:self.line2];
    [[self.view layer] addSublayer:self.line4];
    [[self.view layer] addSublayer:self.line1];
    [[self.view layer] addSublayer:self.line3];


    CALayer *storeText = [CALayer layer];
    CALayer *blackBackground = [CALayer layer];
    storeText.contents = (id)store.CGImage;
    frame = CGRectMake(size.width / 2.65, size.height / 12, size.width / 4, size.height / 8);
    storeText.frame = frame;
    frame = CGRectMake(size.width / 2.9, size.height / 20, size.width / 3.25, size.height / 5);
    blackBackground.frame = frame;
    blackBackground.backgroundColor = [UIColor blackColor].CGColor;
    blackBackground.borderColor = [UIColor greenColor].CGColor;
    blackBackground.borderWidth = blackBackground.frame.size.height / 15;
    [self.view.layer addSublayer:blackBackground];
    [self.view.layer addSublayer:storeText];

    frame = CGRectMake(size.width / 20, size.height / 16, size.width / 7, size.height / 7);
    self.backButton.frame = frame;
    [self.backButton setBackgroundImage:button forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];

    CGSize buttonSize = self.backButton.frame.size;
    frame = CGRectMake(buttonSize.width / 6, buttonSize.height / 4, buttonSize.width / 1.5, buttonSize.height / 2);
    CALayer *backText = [CALayer layer];
    backText.frame = frame;
    backText.contents = back;
    [[self.backButton layer] addSublayer:backText];

    self.storeContents = [[UIScrollView alloc]
        initWithFrame:CGRectMake(self.view.frame.size.width / 36, self.view.frame.size.height / 4,
                                 self.view.frame.size.width * 17 / 18, self.view.frame.size.height * 7 / 10)];

    CGSize storeItemSize = CGSizeMake(self.view.frame.size.width / 3.182225, self.view.frame.size.height / 4);
    self.storeContents.backgroundColor = [UIColor grayColor];
    [self.storeContents setContentSize:CGSizeMake(storeItemSize.width, storeItemSize.height * (numberOfBadges + 0.5))];
    [self.view addSubview:self.storeContents];
    self.storeContents.showsVerticalScrollIndicator = YES;
    self.storeContents.scrollEnabled = YES;
    self.storeContents.userInteractionEnabled = YES;

    CGFloat y = 0;
    for (int i = 0; i <= numberOfBadges; i++) {
        CGRect frame = CGRectMake(0, y, storeItemSize.width, storeItemSize.height);
        if (i == 0) {
            frame.size.height = storeItemSize.height / 2;
        }
        UIView *cellLeft = [[UIView alloc] initWithFrame:frame];
        frame.origin.x += storeItemSize.width;
        UIView *cellMiddle = [[UIView alloc] initWithFrame:frame];
        frame.origin.x += storeItemSize.width;
        UIView *cellRight = [[UIView alloc] initWithFrame:frame];

        cellLeft.layer.borderColor = [UIColor blackColor].CGColor;
        cellLeft.layer.borderWidth = storeItemSize.height / 15;

        cellRight.layer.borderColor = cellLeft.layer.borderColor;
        cellRight.layer.borderWidth = cellLeft.layer.borderWidth;


        cellMiddle.layer.borderColor = cellLeft.layer.borderColor;
        cellMiddle.layer.borderWidth = cellLeft.layer.borderWidth;

        if (i == 0) {
            CGRect layerFrame;
            CALayer *coins = [CALayer layer];
            CALayer *powerUps = [CALayer layer];
            CALayer *badges = [CALayer layer];
            coins.contents =
                (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"coins" ofType:@"png"]]
                    .CGImage;
            powerUps.contents =
                (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"powerups" ofType:@"png"]]
                    .CGImage;
            badges.contents =
                (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"badges" ofType:@"png"]]
                    .CGImage;
            layerFrame =
                CGRectMake(frame.size.width / 3, frame.size.height / 4, frame.size.width / 3, frame.size.height / 2);
            coins.frame = layerFrame;
            [cellLeft.layer addSublayer:coins];
            layerFrame =
                CGRectMake(frame.size.width / 4, frame.size.height / 4, frame.size.width / 2, frame.size.height / 2);
            powerUps.frame = layerFrame;
            [cellMiddle.layer addSublayer:powerUps];
            layerFrame =
                CGRectMake(frame.size.width / 4, frame.size.height / 4, frame.size.width / 2, frame.size.height / 2);
            badges.frame = layerFrame;
            [cellRight.layer addSublayer:badges];
            goto finishLoop;
        }
        if (i - 1 < numberOfPowerUps) {
            NSString *powerUpName = powerUps[i - 1];
            if (powerUpName) {
                // could use frame to determine proper location but I want to know which cell I am pulling data from
                CALayer *powerUpImage = [CALayer layer];
                UILabel *label = [[UILabel alloc] init];

                powerUpImage.contents =
                    (id)[UIImage
                        imageWithContentsOfFile:[[NSBundle mainBundle]
                                                    pathForResource:[NSString stringWithFormat:@"%@1", powerUpName]
                                                             ofType:@"png"]]
                        .CGImage;
                powerUpImage.frame = CGRectMake(storeItemSize.width / 6, storeItemSize.height / 8,
                                                storeItemSize.width / 6, storeItemSize.width / 6);
                [cellMiddle.layer addSublayer:powerUpImage];
                label.text = powerUpName;
                CGFloat sizeText = storeItemSize.height / 7;
                label.font = [UIFont systemFontOfSize:sizeText];
                label.frame = CGRectMake(storeItemSize.width / 4 - (sizeText * [powerUpName length] / 2),
                                         storeItemSize.height / 1.75, sizeText * [powerUpName length], sizeText * 1.2);
                label.adjustsFontSizeToFitWidth = YES;
                label.textAlignment = NSTextAlignmentCenter;
                [cellMiddle addSubview:label];
            }
        }
        if (i - 1 < numberOfBadges) {
            NSString *badgeName = badges[i - 1];
            if (badgeName) {
                // could use frame to determine proper location but I want to know which cell I am pulling data from
                CALayer *badgeImage = [CALayer layer];
                UILabel *label = [[UILabel alloc] init];

                badgeImage.contents =
                    (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:badgeName
                                                                                         ofType:@"png"]]
                        .CGImage;
                badgeImage.frame = CGRectMake(storeItemSize.width / 6, storeItemSize.height / 8,
                                              storeItemSize.width / 6, storeItemSize.width / 6);
                [cellRight.layer addSublayer:badgeImage];

                label.text = badgeName;

                CGFloat sizeText = storeItemSize.height / 8;
                label.font = [UIFont systemFontOfSize:sizeText];
                label.frame = CGRectMake(storeItemSize.width / 4 - (sizeText * [badgeName length] / 2),
                                         storeItemSize.height / 1.75, sizeText * [badgeName length], sizeText * 1.2);
                label.adjustsFontSizeToFitWidth = YES;
                label.textAlignment = NSTextAlignmentCenter;
                [cellRight addSubview:label];
            }
        }

    finishLoop: {
        [self.storeContents addSubview:cellLeft];
        if (i - 1 < numberOfPowerUps)
            [self.storeContents addSubview:cellMiddle];
        if (i - 1 < numberOfBadges)
            [self.storeContents addSubview:cellRight];
        y += frame.size.height;
    }
    }
}


- (void)setUpTapGesture
{
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.tapGesture.cancelsTouchesInView = NO;
}

- (void)tapView:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    if (CGRectContainsPoint(self.backButton.frame, point)) {
        CGRect oldFrame = self.view.frame;
        CGRect newFrame =
            CGRectMake(oldFrame.origin.x, -oldFrame.size.height, oldFrame.size.width, oldFrame.size.height);
        [UIView animateWithDuration:0.8
            animations:^{
              [self.view setFrame:newFrame];
            }
            completion:^(BOOL completion) {
              if (completion) {
                  [self.view removeFromSuperview];
                  for (UIViewController *controller in [self.parentViewController childViewControllers]) {
                      if ([controller isKindOfClass:[GameStateMenuVC class]]) {
                          controller.view.userInteractionEnabled = YES;
                      }
                  }
                  [self removeFromParentViewController];
              }
            }];
    }
}


@end
