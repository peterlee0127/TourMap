//
//  Source.h
//  Tour Map
//
//  Created by Peterlee on 7/16/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Source;

@interface Source : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * enable;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSData * place;
@property (nonatomic, retain) Source *relationship;

@end
