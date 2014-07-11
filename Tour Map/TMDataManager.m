//
//  TMDataManager.m
//  Tour Map
//
//  Created by Peterlee on 7/11/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMDataManager.h"
#import <AFNetworking.h>

@implementation TMDataManager

+(instancetype) shareInstance
{
    static TMDataManager *shareInstance_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [[TMDataManager alloc] init];
    });
    return shareInstance_;
}
-(void) downloadData:(NSString *)url
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:url parameters:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetch fail");
    }]
    ;
}

@end
