//
//  ViewController.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "InboxViewController.h"
#import "DataManager.h"
@interface ViewController () <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginFBButton;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:142 / 255.0f green:68 / 255.0f blue:173 / 255.0f alpha:1]];
    self.loginFBButton.delegate = self;
    self.loginFBButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if (error) {
        NSLog(@"Login Error!");
    }
    else if (result.isCancelled){
        NSLog(@"Canceled!");
    }else{
        NSLog(@"Login ok!");
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *view = [storyBoard instantiateViewControllerWithIdentifier:@"tab_main"];
        [[DataManager shareInstance] getConnectTokenFromAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Login";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
