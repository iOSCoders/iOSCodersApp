//
//  Subjects.h
//  iOSCoders
//
//  Created by Joe Bologna on 9/12/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Mazey2,
    GameOfWar
} App;

@interface Apps : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, unsafe_unretained) App curApp;
@property (nonatomic, copy) NSString *app;

+ (Apps *)theApps;
@end
