//
//  DataManager.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"
#import "RecentInbox.h"

@implementation DataManager
+ (DataManager *)shareInstance{
    static DataManager *instance;
    if (instance == nil) {
        instance = [[DataManager alloc] init];
    }
    return instance;
}

- (void)getConnectTokenFromAccessToken:(NSString *)token{
    NSDictionary *req = [NSDictionary dictionaryWithObject:token forKey:@"accessToken"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://fptdilinh.net:3000/api/login"]];
    [request setHTTPMethod:@"POST"];
    NSData *datapost = [NSJSONSerialization dataWithJSONObject:req options:0 error:nil];
    [request setHTTPBody:datapost];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    self.token = [data objectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getUserToken{
    self.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

- (void)loadTopMusic{
    self.haveARoom = NO;
    self.topMusics = [[NSMutableArray alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.soundcloud.com/tracks?client_id=48e42f21de4a98b9ab09d24ceb40dcf3"]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSArray *topMusics = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    for (NSDictionary *item in topMusics) {
        Music *music = [[Music alloc] initWithDictionary:item];
        [self.topMusics addObject:music];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeLoadData)]){
        [self.delegate completeLoadData];
    }
}

- (void)getUserAvataUrl{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(100).height(100)"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                //NSString *nameOfLoginUser = [result valueForKey:@"name"];
                self.avatarUrl = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
            }
        }];
    }
}

- (Music *)musicById:(NSString *)musicId{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.soundcloud.com/tracks/%@?client_id=48e42f21de4a98b9ab09d24ceb40dcf3", musicId]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    return [[Music alloc] initWithDictionary:dic];
}

- (void)searchWithKey:(NSString *)key{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/tracks?client_id=48e42f21de4a98b9ab09d24ceb40dcf3&q=%@",[key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSArray *topMusics = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    [self.topMusics removeAllObjects];
    for (NSDictionary *item in topMusics) {
        Music *music = [[Music alloc] initWithDictionary:item];
        [self.topMusics addObject:music];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeLoadData)]){
        [self.delegate completeLoadData];
    }
}


- (void)getRecentMessage{
    self.recentChats = [[NSMutableArray alloc] init];
    NSArray *chats = [self getAllRooms];
    //NSLog(@"%@", chats);
    for (RecentInbox *ob in chats) {
        //[context delete:ob];
       // [context save:nil];
        Recent *rc = [[Recent alloc] initWithDB:ob];
        [self.recentChats addObject:rc];
    }
}
#pragma mark Core data

#pragma mark Room Function
- (NSArray *)getAllRooms{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSArray *rooms = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RecentInbox"];
    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"gioiTinh = 1"];
    //request.predicate = predicate;
    
    NSError *error;
    rooms = [context executeFetchRequest:request error:&error];
    return rooms;
}

- (void)addMessage:(Message *)message{
    
}

- (void)addNewRoom:(Recent *)recent{
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RecentInbox"];
    request.predicate = [NSPredicate predicateWithFormat:@"roomid=%@", recent.roomId];
    if ([context executeFetchRequest:request error:nil].count == 0) {
        RecentInbox *rc = [NSEntityDescription insertNewObjectForEntityForName:@"RecentInbox" inManagedObjectContext:context];
        [rc initWithRecent:recent];
        [context save:nil];
    }else{
        RecentInbox *rc = [context executeFetchRequest:request error:nil].firstObject;
        [rc initWithRecent:recent];
        [context save:nil];
    }
}

- (void)deleteRoomById:(NSString *)iD{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RecentInbox"];
    request.predicate = [NSPredicate predicateWithFormat:@"roomid=%@", iD];
    RecentInbox *rc = [context executeFetchRequest:request error:nil].firstObject;
    [context delete:rc];
    [context save:nil];
}




#pragma mark - Helper
- (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

@end
