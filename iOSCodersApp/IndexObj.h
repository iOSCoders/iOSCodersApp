//
//  IndexObj.h
//  iOSCodersApp
//
//  Created by Joe Bologna on 10/28/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexObj : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *pages, *apps;
@property (strong, nonatomic) NSString *curElement;
@property (strong, nonatomic) NSMutableArray *download;
@property (strong, nonatomic) NSString *curVersion, *nextVersion;
@property (strong, nonatomic) NSString *webPages;

+ (IndexObj *)theIndex;
- (void)update;
- (void)cacheIndex;

@end
