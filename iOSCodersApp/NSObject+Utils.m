//
//  NSObject+Utils.m
//  Mazey2
//
//  Created by Joe Bologna on 8/31/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NSObject+Utils.h"

@implementation NSObject (Utils)

- (void)collideOn:(SKPhysicsBody *)b {
    b.categoryBitMask = b.collisionBitMask = b.contactTestBitMask = 1;
}

- (void)collideOff:(SKPhysicsBody *)b {
    b.categoryBitMask = b.collisionBitMask = b.contactTestBitMask = 0;
}

- (void)contactOn:(SKPhysicsBody *)b {
    b.categoryBitMask = 1;
    b.collisionBitMask = 0;
    b.contactTestBitMask = 1;
}

- (void)contactOff:(SKPhysicsBody *)b {
    b.categoryBitMask = b.collisionBitMask = b.contactTestBitMask = 0;
}

- (void)makeBody:(SKPhysicsBody *)b dynamic:(DYNAMIC)d {
    switch (d) {
        case FREE:
            b.affectedByGravity = NO;
            b.dynamic = YES;
            break;
        case FIXED:
            b.affectedByGravity = NO;
            b.dynamic = NO;
            break;
        case FALLING:
            b.affectedByGravity = YES;
            b.dynamic = YES;
            break;
    }
}

- (SKShapeNode *)makeBallAt:(CGPoint)p ofRadius:(CGFloat)r dynamic:(DYNAMIC)d {
    SKShapeNode *ball = [[SKShapeNode alloc] init];
    CGMutablePathRef ball_path = CGPathCreateMutable();
    CGPathAddArc(ball_path, NULL, 0, 0, r, 0, M_PI*2, YES);
    ball.path = ball_path;
    ball.position = p;
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:r];
    [self makeBody:ball.physicsBody dynamic:d];
    return ball;
}

- (SKSpriteNode *)makeCarAt:(CGPoint)p dynamic:(DYNAMIC)d {
    SKSpriteNode *car = [SKSpriteNode spriteNodeWithImageNamed:@"car_top_copy.png"];
    car.position = p;
    [car setScale:CARSIZE];
    car.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:car.size];
    [self makeBody:car.physicsBody dynamic:d];
    return car;
}

- (SKShapeNode *)makeBlockAt:(CGPoint)p ofSize:(CGSize)sz dynamic:(DYNAMIC)d {
    SKShapeNode *block = [[SKShapeNode alloc] init];
    block.position = p;
    block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sz];
    [self makeBody:block.physicsBody dynamic:d];
    return block;
}

- (SKLabelNode *)makeLabelAt:(CGPoint)p text:(NSString *)t {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.text = t;
    label.position = p;
    label.color = [SKColor whiteColor];
    return label;
}


@end
