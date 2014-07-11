//
//  TMDataManager.h
//  Tour Map
//
//  Created by Peterlee on 7/11/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMDataManager : NSObject

+(instancetype) shareInstance;
-(void) downloadData:(NSString *)url;

@end
