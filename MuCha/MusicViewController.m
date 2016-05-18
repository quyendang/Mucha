//
//  MusicViewController.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicTableViewCell.h"
#import "DataManager.h"
#import "Music.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ServiceManager.h"
#import "Room.h"
#import <SBJson4.h>
@import AVFoundation;
#import <DGActivityIndicatorView.h>

@interface MusicViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DataManagerDelegate, ServiceManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataManager shareInstance].delegate = self;
    self.musicTableView.delegate = self;
    self.musicTableView.dataSource = self;
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:[UIColor colorWithRed:142 / 255.0f green:68 / 255.0f blue:173 / 255.0f alpha:1]];
    CGFloat width = self.view.bounds.size.width / 5.0f;
    CGFloat height = self.view.bounds.size.height / 7.0f;
    self.activityIndicatorView.frame = CGRectMake(20.0f, 20.0f, width, height);
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

- (void)socketIO:(SIOSocket *)socket callBackRoomString:(NSString *)data{
    NSLog(@"%@", data);
    [[DataManager shareInstance].musicLists removeAllObjects];
    NSError *err;
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *musicArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
    for (NSDictionary *dic in musicArr) {
        Room *room = [[Room alloc] initWithDictionary:dic];
        [[DataManager shareInstance].musicLists addObject:room];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(serverResponseRoom)]){
        [self.delegate serverResponseRoom];
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self popViewControllerAnimated];
    });
    
}

- (void)socketIO:(SIOSocket *)socket callBackString:(NSString *)messeage{
    NSLog(@"%@", messeage);
    [DataManager shareInstance].haveARoom = YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (void)completeLoadData{
    //[self.musicTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    self.activityIndicatorView.hidden = NO;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        [[DataManager shareInstance] searchWithKey:self.searchTextField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.activityIndicatorView.hidden = YES;
            [self.musicTableView reloadData];
        });
    });
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ServiceManager shareInstance].delegate = self;
    self.title = @"Search a song";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.frame = CGRectMake(0.0, 3.0, 30,30);
    
    [backButton  addTarget:self action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        if ([DataManager shareInstance].topMusics.count == 0) {
            self.activityIndicatorView.hidden = NO;
            [[DataManager shareInstance] loadTopMusic];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.musicTableView reloadData];
            self.activityIndicatorView.hidden = YES;
        });
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) popViewControllerAnimated{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DataManager shareInstance].topMusics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music_cell"];
    Music *music = [[DataManager shareInstance].topMusics objectAtIndex:indexPath.row];
    [cell.thumbImageView sd_setImageWithURL:[NSURL URLWithString:music.avataUrl] placeholderImage:[UIImage imageNamed:@"music_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell setNeedsLayout];
    }];
    cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.layer.frame.size.width / 2;
    cell.thumbImageView.clipsToBounds = YES;
    cell.nameLabel.text = music.title;
    cell.directorLabel.text = music.username;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![DataManager shareInstance].haveARoom) {
        Music *music = [[DataManager shareInstance].topMusics objectAtIndex:indexPath.row];
        [[ServiceManager shareInstance] createRoomWithMusic:music currentUserId:[FBSDKAccessToken currentAccessToken].userID];
        //Music *m = [[DataManager shareInstance] musicById:music.musicId];
        //NSLog(@"%@", m.avataUrl);
        
    }else{
        NSLog(@"You are have a room !");
    }
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
