//
//  Subjects.h
//  iOSCoders
//
//  Created by Joe Bologna on 9/12/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    About,
    Logistics,
    Resources,
    YourAppHere,
    TestApp
} Subjects;

@interface Subject : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, unsafe_unretained) Subjects curSubject;
@property (nonatomic, copy) NSString *subject;

+ (Subject *)theSubject;
@end
