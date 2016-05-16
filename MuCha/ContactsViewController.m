//
//  ContactsViewController.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "ContactsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Friend.h"
#import "FriendTableViewCell.h"
#import "ServiceManager.h"
#import "ChatViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ContactsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (strong, nonatomic) NSMutableArray *dsFriends;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendTableView.dataSource = self;
    self.friendTableView.delegate = self;
    self.dsFriends = [[NSMutableArray alloc] init];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:[NSDictionary dictionaryWithObject:@"id,name,link,first_name, last_name, picture.type(large)" forKey:@"fields"]
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        for (NSDictionary *dic in [result objectForKey:@"data"]) {
            Friend *fr = [[Friend alloc] initWithDictionary:dic];
            [self.dsFriends addObject:fr];
        }
        [self.friendTableView reloadData];
    }];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"count %ld", self.dsFriends.count);
    return self.dsFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Friend *fr = [self.dsFriends objectAtIndex:indexPath.row];
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend_cell"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", fr.userFirstName, fr.userLastName];
    //cell.nameLabel.font = [UIFont fontWithName:@"Lato-Thin" size:17];
    cell.statusLabel.text = @"Ready to chat!";
    [cell.avataImageView sd_setImageWithURL:[NSURL URLWithString:fr.userPicture] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.avataImageView.layer.cornerRadius = cell.avataImageView.layer.frame.size.height / 2;
        cell.avataImageView.clipsToBounds = YES;
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Friend *fr = [self.dsFriends objectAtIndex:indexPath.row];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"chat"];
    view.fr = fr;
    [self.tabBarController.navigationController pushViewController:view animated:YES];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Facebook Friends";
    }
    else if (section == 1){
        return @"B";
    }
    else{
        return @"C";
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"Contacts";
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
