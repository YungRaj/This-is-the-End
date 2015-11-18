//
//  TITEViewController.m
//  This is the End
//
//  Created by Ilhan Raja on 7/5/15.
//  Copyright (c) 2015 Ilhan-Parker. All rights reserved.
//

#import "GameAPI.h"
#import "TITEViewController.h"
#import "MainMenuViewController.h"
#import "GameData.h"

@interface TITEViewController ()

@end

@implementation TITEViewController

-(void)setGameDataSelected:(GameData *)gameDataSelected{
    _gameDataSelected = gameDataSelected;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:kGameNotificationSave object:nil];
}

-(void)save{
    if(self.gameDataSelected){
        [self.gameDataSelected saveToState:self.gameDataSelected.state];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = YES;
    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc]init];
    [self addChildViewController:mainMenuViewController];
    [self.view addSubview:mainMenuViewController.view];
    [mainMenuViewController didMoveToParentViewController:self];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
