//
//  ConnectViewController.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "ConnectViewController.h"
#import "MusicViewController.h"
#import "Music.h"
#import "DataManager.h"
#import "ServiceManager.h"
#import "ChatViewController.h"
#import "Room.h"
#import "ConectTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ConnectViewController () <UITableViewDelegate, UITableViewDataSource, ServiceManagerDelegate, MusicViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *musicTableView;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.musicTableView.delegate = self;
    self.musicTableView.dataSource = self;
}
#pragma mark Service Manager Delegate

- (void)socketIO:(SIOSocket *)socket callBackRoomString:(NSString *)data{
    [[DataManager shareInstance].musicLists removeAllObjects];
    NSError *err;
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *musicArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
    for (NSDictionary *dic in musicArr) {
        Room *room = [[Room alloc] initWithDictionary:dic];
        [[DataManager shareInstance].musicLists addObject:room];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.musicTableView reloadData];
    });
}

#pragma mark Music TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DataManager shareInstance].musicLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Room *room = [[DataManager shareInstance].musicLists objectAtIndex:indexPath.row];
    ConectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"connect_cell"];
    cell.musicTitle.text = room.music.title;
    [cell.firstUserImageView sd_setImageWithURL:[NSURL URLWithString:room.music.avataUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        {
            cell.firstUserImageView.layer.cornerRadius = 25;
            cell.firstUserImageView.clipsToBounds = YES;
            [cell.firstUserImageView setNeedsLayout];
        }
    }];
    [cell.secondUserImageView sd_setImageWithURL:[NSURL URLWithString:room.music.avataUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        {
            cell.secondUserImageView.layer.cornerRadius = 25;
            cell.secondUserImageView.clipsToBounds = YES;
            [cell.secondUserImageView setNeedsLayout];
        }
    }];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"Listen together";
    [self addMusicButton];
    [ServiceManager shareInstance].delegate = self;
    [self.musicTableView reloadData];
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

- (void)serverResponseRoom{
    NSLog(@"refresh");
    [self.musicTableView reloadData];
}

- (void)onClickMusicButton{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"search_music"];
    view.delegate = self;
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
