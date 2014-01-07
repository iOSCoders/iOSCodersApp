//
//  IndexObj.m
//  iOSCodersApp
//
//  Created by Joe Bologna on 10/28/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "IndexObj.h"

@interface IndexObj() {
}
@end

@implementation IndexObj

- (id)init {
    self = [super init];
    if (self) {
        self.pages = [NSMutableArray array];
        self.apps = [NSMutableArray array];
        self.webPages = [[NSBundle mainBundle] bundlePath];
        self.curElement = @"";
        self.download = [NSMutableArray array];        
    }
    return self;
}

+ (IndexObj *)theIndex {
    IndexObj *s = [[IndexObj alloc] init];
    return s;
}
#pragma mark XML Handlers
/*
 The WebPages are distributed with the app. The Copy Files build phase copies the original versions to the ./WebPages directory.
 A completely new set of pages may be available on the website. These files should replace all the files in the WebPages directory.
 This is accomplished by downloading the entire folder to ./WebPages/update, then moving the files to ./WebPages.
 If an error occurs during the download, the ./WebPages folder is left intact.
 */

- (void)update {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif

#warning This is not working yet.
    
    // get the list of files to download from the server.
    NSURL *updateUrl = [self webSiteURLFor:@"update.xml"];
    if (!updateUrl) return; // bad URL or something

    // create the ./WebPages/update folder if its not there
    NSURL *updateFolder = [NSURL fileURLWithPath:[self.webPages stringByAppendingPathComponent:@"update"]];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:updateFolder error:&error];
    [[NSFileManager defaultManager] createDirectoryAtURL:updateFolder withIntermediateDirectories:NO attributes:nil error:nil];
    BOOL ok = [self dldFile:@"update.xml" url:updateFolder] && [self dldFile:@"index.xsl" url:updateFolder];
    if (!ok) return;
    NSURL *updateXML = [NSURL URLWithString:@"update.xml" relativeToURL:updateFolder];
    NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:updateXML];
    p.delegate = self;
    if (![p parse]) {
        NSLog(@"%s, parsing %@ failed", __func__, updateUrl.absoluteString);
        NSLog(@"Skipping update");
    } else {
#pragma warning need to check a timestamp or something to avoid unnecessary i/o
        BOOL ok = YES;
        [self.download removeAllObjects];
        for (NSString *f in self.download) {
            ok = [self dldFile:f url:updateFolder];
            if (!ok) break;
        }
        
        // if the update files were downloaded ok, then move them
        if (ok) {
            for (NSString *f in self.download) {
                [[NSFileManager defaultManager] removeItemAtPath:[self.webPages stringByAppendingPathComponent:f] error:&error];
                [[NSFileManager defaultManager] moveItemAtPath:[updateFolder.path stringByAppendingPathComponent:f] toPath:[self.webPages stringByAppendingPathComponent:f] error:&error];
            }
            NSURL *url = [NSURL fileURLWithPath:[self.webPages stringByAppendingPathComponent:@"index.xml"]];
            NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:url];
            [p parse];
        }
    }
}
    
- (BOOL)dldFile:(NSString *)f url:(NSURL *)updateFolder {
    NSError *error;
    NSURL *url = [self webSiteURLFor:f];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *tmpFile = [NSTemporaryDirectory() stringByAppendingString:f];
    [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:&error];
    [data writeToFile:tmpFile atomically:YES];
    BOOL ok = [[NSFileManager defaultManager] copyItemAtPath:tmpFile toPath:[updateFolder.path stringByAppendingPathComponent:f] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
    return ok;
}
    
- (void)cacheIndex {
    self.pages = [NSMutableArray array];
    self.apps = [NSMutableArray array];
    NSURL *url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"index.xml"]];
    NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:url];
    p.delegate = self;
    self.curElement = @"";
    if (![p parse]) {
        NSLog(@"%s, parsing %@ failed", __func__, url.path);
        abort();
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.curElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.curElement isEqualToString:@"item"]) {
        NSLog(@"%@: %@\n", self.curElement, string);
        [self.pages addObject:string];
    } else if ([self.curElement isEqualToString:@"download"]) {
        NSLog(@"%@: %@\n", self.curElement, string);
        [self.download addObject:string];
    } else if ([self.curElement isEqualToString:@"app"]) {
        NSLog(@"%@: %@\n", self.curElement, string);
        [self.apps addObject:string];
    } else if ([self.curElement isEqualToString:@"version"]) {
        NSLog(@"%@: %@\n", self.curElement, string);
        self.curVersion = string;
    } else if ([self.curElement isEqualToString:@"newversion"]) {
        NSLog(@"%@: %@\n", self.curElement, string);
        self.nextVersion = string;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    self.curElement = @"";
}

- (NSURL *)webSiteURLFor:(NSString *)f {
#ifdef DEBUG
    // http://localhost/jbologna/Documents/Projects/iOS/iOSCodersApp/iOSCodersApp/WebPages/update.xml
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:@"localhost" path:[@"/jbologna/Documents/Projects/iOS/iOSCodersApp/iOSCodersApp/WebPages" stringByAppendingPathComponent:f]];
#else
    // https://raw.github.com/iOSCoders/iOSCodersApp/master/iOSCodersApp/WebPages/update.xml
    NSURL *url = [[NSURL alloc] initWithScheme:@"https" host:@"raw.github.com" path:[@"/iOSCoders/iOSCodersApp/master/iOSCodersApp/WebPages" stringByAppendingPathComponent:f]];
#endif
    NSLog(@"URL: %@", [url absoluteString]);
    return url;
}

@end
