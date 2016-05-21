//
//  InboxViewController.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "InboxViewController.h"
#import "ServiceManager.h"
#import "DataManager.h"
#import "Room.h"
#import "Recent.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FriendTableViewCell.h"

@interface InboxViewController () <ServiceManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *tnText;
@property (weak, nonatomic) IBOutlet UILabel *inbox;
@property (weak, nonatomic) IBOutlet UITableView *inboxTableView;

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataManager shareInstance].musicLists = [[NSMutableArray alloc] init];
    [self.tabBarController.navigationController.navigationBar setTranslucent:NO];
    self.tabBarController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.tabBarController.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:142 / 255.0f green:68 / 255.0f blue:173 / 255.0f alpha:1]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:142 / 255.0f green:68 / 255.0f blue:173 / 255.0f alpha:1]];
    [ServiceManager shareInstance].delegate = self;
    self.inboxTableView.delegate = self;
    self.inboxTableView.dataSource = self;
    [[DataManager shareInstance] getUserAvataUrl];
    [[DataManager shareInstance] getRecentMessage];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DataManager shareInstance].recentChats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Recent *item = [[DataManager shareInstance].recentChats objectAtIndex:indexPath.row];
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inbox"];
    cell.statusLabel.text = item.lastMessage;
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@", item.userId]
                                  parameters:@{ @"fields" : @"id,name,picture.width(100).height(100)"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        cell.nameLabel.text = [result valueForKey:@"name"];
        [cell.avataImageView sd_setImageWithURL:[NSURL URLWithString:[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.avataImageView.layer.cornerRadius = cell.avataImageView.layer.frame.size.width / 2;
            cell.avataImageView.clipsToBounds = YES;
            [cell setNeedsLayout];
        }];
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    return cell;
}

- (void)socketIO:(SIOSocket *)socket callBackString:(NSString *)messeage{
    NSLog(@"%@", messeage);
    dispatch_async(dispatch_get_main_queue(), ^{
       self.inbox.text = messeage;
        self.tnText.text = [NSString stringWithFormat:@"%@ \n %@", self.tnText.text, messeage];
    });
    
}
- (void)socketIO:(SIOSocket *)socket callBackRoomString:(NSString *)data{
    [[DataManager shareInstance].musicLists removeAllObjects];
    NSError *err;
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *musicArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
    for (NSDictionary *dic in musicArr) {
        Room *room = [[Room alloc] initWithDictionary:dic];
        [[DataManager shareInstance].musicLists addObject:room];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.navigationItem.backBarButtonItem = nil;
    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.tabBarController.title = @"Recents";
    if ([DataManager shareInstance].token == nil) {
        [[DataManager shareInstance] getUserToken];
    }
    
    if (![ServiceManager shareInstance].isLogin) {
        [[ServiceManager shareInstance] connectToHostWithToken:[DataManager shareInstance].token];
    }
    
    
    [self.inboxTableView reloadData];
    
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
