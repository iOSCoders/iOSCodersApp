//
//  Apps.h
//  iOSCoders
//
//  Created by Joe Bologna on 9/12/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Apps.h"

@implementation Apps

- (id)init {
    self = [super init];
    if (self) {
        _list = [NSArray arrayWithObjects:@"Mazey2", nil];
        _curApp = Mazey2;
    }
    return self;
}

+ (Apps *)theApps {
    Apps *s = [[Apps alloc] init];
    return s;
}

@dynamic app;
- (NSString *)app {
    return _list[_curApp];
}

@end
