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

@interface MusicViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DataManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataManager shareInstance].delegate = self;
    self.musicTableView.delegate = self;
    self.musicTableView.dataSource = self;
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (void)completeLoadData{
    //[self.musicTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        [[DataManager shareInstance] searchWithKey:self.searchTextField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.musicTableView reloadData];
        });
    });
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
            [[DataManager shareInstance] loadTopMusic];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.musicTableView reloadData];
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
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        
        if (music.data == nil) {
            music.data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:music.avataUrl]];
        }
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.thumbImageView.image = [UIImage imageWithData:music.data];
        });
    });
    cell.thumbImageView.image = [UIImage imageWithData:music.data];
    cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.layer.frame.size.width / 2;
    cell.thumbImageView.clipsToBounds = YES;
    cell.nameLabel.text = music.title;
    cell.directorLabel.text = music.username;
    return cell;
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
