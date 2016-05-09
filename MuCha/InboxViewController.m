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

@interface InboxViewController () <ServiceManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tnText;

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.navigationController.navigationBar setTranslucent:NO];
    self.tabBarController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.tabBarController.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:22/255.0f green:160/255.0f blue:33/255.0f alpha:1]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:22/255.0f green:160/255.0f blue:33/255.0f alpha:1]];
    [ServiceManager shareInstance].delegate = self;
    // Do any additional setup after loading the view.
}

- (void)socketIO:(SIOSocket *)socket callBackString:(NSString *)messeage{
    NSLog(@"%@", messeage);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.backBarButtonItem = nil;
    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.tabBarController.title = @"Recents";
    if ([DataManager shareInstance].token == nil) {
        [[DataManager shareInstance] getUserToken];
    }
    
    if (![ServiceManager shareInstance].isLogin) {
        [[ServiceManager shareInstance] connectToHostWithToken:[DataManager shareInstance].token];
    }
    
}

- (IBAction)sendClick:(id)sender {
    [[ServiceManager shareInstance] sendMessage:@"Test test"];
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
