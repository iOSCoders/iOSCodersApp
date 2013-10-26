//
//  Subjects.m
//  iOSCoders
//
//  Created by Joe Bologna on 9/12/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Subject.h"

@implementation Subject

- (id)init {
    self = [super init];
    if (self) {
        _list = [NSArray arrayWithObjects:@"About", @"Logistics", @"Resources", @"Your App Here", nil];
        _curSubject = About;
    }
    return self;
}

+ (Subject *)theSubject {
    Subject *s = [[Subject alloc] init];
    return s;
}

@dynamic subject;
- (NSString *)subject {
    return _list[_curSubject];
}

@end
