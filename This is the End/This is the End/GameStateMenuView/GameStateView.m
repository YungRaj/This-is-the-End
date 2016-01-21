//
//  GameStateView.m
//  This is the End
//
//  Created by Ilhan Raja on 6/21/15.
//  Copyright © 2015 Ilhan-Parker. All rights reserved.
//

#import "AppDelegate.h"
#import "GameStateView.h"

@interface GameStateView () {

}

@end


@implementation GameStateView

-(instancetype)initWithFrame:(CGRect)frame gameStateData:(GameData*)data{
    self = [super initWithFrame:frame];
    if(self){
        _data = data;
        _stateText = [CALayer layer];
        _worldText = [CALayer layer];
        _worldNum = [CALayer layer];
        _worldBackground = [CALayer layer];
        _createGame = [UIButton buttonWithType:UIButtonTypeCustom];
        _createText = [CALayer layer];
        _play = [UIButton buttonWithType:UIButtonTypeCustom];
        _playText = [CALayer layer];
        
        // remove when game is completed
    }
    
    return self;
}

-(void)setUpData{
    if(!self.stateText) {
        self.stateText = [CALayer layer];
    }if(!self.worldText){
        self.worldText = [CALayer layer];
    }if(!self.worldNum){
        self.worldNum = [CALayer layer];
    }if(!self.worldBackground){
        self.worldBackground = [CALayer layer];
    }if(!self.createGame){
        self.createGame = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.createText){
        self.createText = [CALayer layer];
    }if(!self.play){
        self.play = [UIButton buttonWithType:UIButtonTypeCustom];
    }if(!self.playText){
        self.playText = [CALayer layer];
    }
}

-(void)setUpSubViews{
    [self setUpData];
    
    UIImage *buttonImage = (id)[UIImage imageNamed:@"button.png"];
    id gameStateImage = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"gamestate%d",self.data.state] ofType:@"png"]].CGImage;
        
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    CGSize size = self.frame.size;
    self.layer.borderColor = [UIColor greenColor].CGColor;
    self.layer.borderWidth = self.frame.size.height/20;
    
    CGRect frame;
    
    frame = CGRectMake(size.width/25,
                      size.height/5,
                      size.width/4,
                      size.height/1.75);
    self.stateText.frame = frame;
    self.stateText.contents = gameStateImage;
    [self.layer addSublayer:self.stateText];
    
    frame = CGRectMake(size.width*.8,
                      size.height/6,
                      size.width/6,
                      size.height/1.5);
    
    self.createGame.frame = frame;
    [self addSubview:self.createGame];
    
    
    CGSize subViewSize  = frame.size;
    
    CGRect subframe = CGRectMake(subViewSize.width/6,
                      subViewSize.height/6,
                      subViewSize.width/1.5,
                      subViewSize.height/1.5);
    
    [self.createGame setBackgroundImage:buttonImage forState:UIControlStateNormal];
    id createText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"create" ofType:@"png"]].CGImage;
    id newText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"new" ofType:@"png"]].CGImage;
    self.createText.frame = subframe;

    
    if(self.data.filePathExists){
        id worldText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"world" ofType:@"png"]].CGImage;
        frame = CGRectMake(size.width*.38,
                          size.height/6,
                          size.width/10,
                          size.height/6);
        self.worldText.frame = frame;
        self.worldText.contents = worldText;
        [self.layer addSublayer:self.worldText];
    
    
        id worldNum = (id)[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",self.data.worlds]].CGImage;
        frame = CGRectMake(size.width*.5,
                          size.height/6,
                          size.width/50,
                          size.height/6);
        self.worldNum.frame = frame;
        self.worldNum.contents = worldNum;
        [self.layer addSublayer:self.worldNum];
    
        frame = CGRectMake(size.width*.38,
                          size.height/6,
                          size.width/10,
                          size.height/6);
        self.worldText.frame = frame;
        self.worldText.contents = worldText;
        [self.layer addSublayer:self.worldText];
        
        id worldBackground = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"background%d_thumb",self.data.worlds] ofType:@"png"]].CGImage;
        frame = CGRectMake(size.width*.39,
                          size.height/2.25,
                          size.width/8,
                          size.height/2);
        self.worldBackground.frame = frame;
        self.worldBackground.contents = worldBackground;
        [self.layer addSublayer:self.worldBackground];
        
        id playText = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"]].CGImage;
        [self.play setBackgroundImage:buttonImage forState:UIControlStateNormal];
        frame = CGRectMake(size.width*.6,
                         size.height/6,
                         size.width/6,
                         size.height/1.5);
        self.play.frame = frame;
        [self addSubview:self.play];
        self.playText.frame = subframe;
        self.playText.contents = playText;
        [[self.play layer] addSublayer:self.playText];
        self.createText.contents = newText;
    }else{
        self.createText.contents = createText;
    }
    [[self.createGame layer] addSublayer:self.createText];
}

-(void)dealloc{
    [self cleanUpView];
}

-(void)cleanUpView{
    [self.stateText removeFromSuperlayer];
    [self.worldText removeFromSuperlayer];
    [self.worldNum removeFromSuperlayer];
    [self.worldBackground removeFromSuperlayer];
    [self.createText removeFromSuperlayer];
    [self.playText removeFromSuperlayer];
    [self.createGame removeFromSuperview];
    [self.play removeFromSuperview];
    self.stateText = nil;
    self.worldText = nil;
    self.worldNum = nil;
    self.createText = nil;
    self.playText = nil;
    self.createGame = nil;
    self.play = nil;
}







@end
