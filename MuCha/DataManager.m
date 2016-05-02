//
//  DataManager.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
+ (DataManager *)shareInstance{
    static DataManager *instance;
    if (instance == nil) {
        instance = [[DataManager alloc] init];
    }
    return instance;
}

- (void)loadTopMusic{
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

@end
