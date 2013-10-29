//
//  NSObject+Utils.h
//  Mazey2
//
//  Created by Joe Bologna on 8/31/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CARSIZE 0.25
#define BIG_CARSIZE 0.5

typedef enum {
    FREE,
    FIXED,
    FALLING
} DYNAMIC;

@interface NSObject (Utils)

- (void)collideOn:(SKPhysicsBody *)b;
- (void)collideOff:(SKPhysicsBody *)b;
- (void)contactOn:(SKPhysicsBody *)b;
- (void)contactOff:(SKPhysicsBody *)b;
- (void)makeBody:(SKPhysicsBody *)b dynamic:(DYNAMIC)d;
- (SKShapeNode *)makeBallAt:(CGPoint)p ofRadius:(CGFloat)r dynamic:(DYNAMIC)d;
- (SKShapeNode *)makeBlockAt:(CGPoint)p ofSize:(CGSize)sz dynamic:(DYNAMIC)d;
- (SKSpriteNode *)makeCarAt:(CGPoint)p dynamic:(DYNAMIC)d;
- (SKLabelNode *)makeLabelAt:(CGPoint)p text:(NSString *)t;

@end
