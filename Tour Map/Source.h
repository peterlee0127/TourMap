//
//  Source.h
//  Tour Map
//
//  Created by Peterlee on 7/15/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Source : NSManagedObject

@property (nonatomic, retain) NSNumber * enable;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate *date;

@end
