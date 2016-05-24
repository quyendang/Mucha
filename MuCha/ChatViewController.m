//
//  ChatViewController.m
//  MuCha
//
//  Created by OSXVN on 5/12/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "ChatViewController.h"
#import "ServiceManager.h"
#import "DataManager.h"
#import "ChatTableViewCell.h"
#import "Message.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Cal.h"


@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, ServiceManagerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) NSMutableArray *chatArrs;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.chatArrs = [[NSMutableArray alloc] init];
    self.inputTextField.delegate = self;
    [self.chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [ServiceManager shareInstance].delegate = self;
}

#pragma mark Service Manager Delegate

- (void)socketIO:(SIOSocket *)socket callBackString:(NSString *)messeage{
    NSLog(@"%@", messeage);
    NSError *jsonError;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[messeage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
    Message *mess = [[Message alloc] initWithDictionary:dic];
    [self.chatArrs addObject:mess];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.chatTableView reloadData];
    });
}

#pragma mark Chat Table Delegtae

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *mess = [self.chatArrs objectAtIndex:indexPath.row];
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message_cell"];
    
    
    
    
    CGSize size = [mess.message usedSizeForMaxWidth:200.0f withFont:[UIFont fontWithName:@"Lato-Thin" size:17.0f]];
    if (!cell) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message_cell" maxSize:size messageType:[mess.senderID isEqualToString:self.fr.userID]];
    }
    
    cell.messageTextView.text = mess.message;
    cell.messageTextView.font = [UIFont fontWithName:@"Lato-Thin" size:17.0f];
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[mess.senderID isEqualToString:self.fr.userID] ? self.fr.userPicture : [DataManager shareInstance].avatarUrl] placeholderImage:[UIImage imageNamed:@"music_placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell setNeedsLayout];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //ChatTableViewCell *cell = [self.chatTableView cellForRowAtIndexPath:indexPath];
    Message *mess = [self.chatArrs objectAtIndex:indexPath.row];
    CGSize size = [mess.message usedSizeForMaxWidth:200.0f withFont:[UIFont fontWithName:@"Lato-Thin" size:17.0f]];
    return size.height + 30.0f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    [[ServiceManager shareInstance] sendMessage:[NSString stringWithFormat:@"{\"senderid\" : \"%@\", \"userid\" : \"%@\",\"message\" : \"%@\"}", [FBSDKAccessToken currentAccessToken].userID, self.fr.userID, textField.text]];
    //NSLog(@"w: %f h : %f", [textField.text usedSizeForMaxWidth:250.0f withFont:[UIFont fontWithName:@"" size:17.0f]].width, [textField.text usedSizeForMaxWidth:250.0f withFont:[UIFont fontWithName:@"" size:17.0f]].height);
    
    textField.text = @"";
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = self.fr.userFirstName;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.frame = CGRectMake(0.0, 3.0, 30,30);
    
    [backButton  addTarget:self action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
}
- (void) popViewControllerAnimated{
    [self.navigationController popViewControllerAnimated:YES];
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
