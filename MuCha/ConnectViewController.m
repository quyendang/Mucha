//
//  ConnectViewController.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "ConnectViewController.h"
#import "MusicViewController.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"Listen together";
    [self addMusicButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)addMusicButton{
    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [musicButton setImage:[UIImage imageNamed:@"icon_music.png"] forState:UIControlStateNormal];
    musicButton.showsTouchWhenHighlighted = YES;
    musicButton.frame = CGRectMake(0.0, 3.0, 30,30);
    
    [musicButton  addTarget:self action:@selector(onClickMusicButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:musicButton];
    //self.navigationItem.rightBarButtonItem = rightButton;
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
}

- (void)onClickMusicButton{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"search_music"];
    [self.tabBarController.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
