//
//  iOSCodersAppTests.m
//  iOSCodersAppTests
//
//  Created by Joe Bologna on 10/3/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iOSCodersAppTests : XCTestCase <NSXMLParserDelegate> {
    NSString *curElement;
}

@end

@implementation iOSCodersAppTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    curElement = @"";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//    const char *s = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><?xml-stylesheet type=\"text/xsl\" href=\"index.xsl\"?><root><title>Index</title><item>About</item><item>Logistics</item><item>Resources</item><item>Your App Here</item></root>";
//    NSXMLParser *p = [[NSXMLParser alloc] initWithData:[NSData dataWithBytes:s length:strlen(s)]];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"xml"];
    NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:url];
    p.delegate = self;
    XCTAssertTrue([p parse], @"parsing failed");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    curElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([curElement isEqualToString:@"item"]) {
        NSLog(@"%@: %@\n", curElement, string);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    curElement = @"";
}

@end
