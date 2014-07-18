//
//  Place.h
//  Tour Map
//
//  Created by Peterlee on 7/16/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Place :NSObject

@property (nonatomic, assign) NSDate * date;
@property (nonatomic, assign) NSString * detail;
@property (nonatomic, assign) NSData * image;
@property (nonatomic, assign) NSNumber * latitude;
@property (nonatomic, assign) NSNumber * longitude;
@property (nonatomic, assign) NSString * name;
@property (nonatomic, assign) NSString * type;
@property (nonatomic, assign) NSString * imageurl;

@end
