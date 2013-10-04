//
//  MyScene4.m
//  Mazey2
//
//  Created by Joe Bologna on 9/9/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "MyScene4.h"
#import "NSObject+Utils.h"
#import "Turtle.h"

@interface MyScene4() {
    CGPoint m;
    SKSpriteNode *car;
    SKShapeNode *corner;
    CGFloat dur;
    BOOL flying;
    SKLabelNode *score;
    NSInteger points;
}

@end

@implementation MyScene4

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        CGFloat r = 15;
        CGFloat w = 280;
        CGFloat h = 160;
        m = CGPointMake(size.width/2, size.height/2);
        
        dur = 10;
        flying = NO;
        points = 0;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.physicsWorld.contactDelegate = self;

        [self makeScore];
        [self makeCornersAt:m ofSize:1 withR:r andHeight:h andWidth:w];
        CGPathRef p = [self drawRoundRectAt:m withR:r andHeight:h andWidth:w];
        SKShapeNode *s = [self makeBlockAt:CGPointMake(m.x, m.y) ofSize:CGSizeMake(100, 50) dynamic:FIXED];
        s.strokeColor = s.fillColor = [SKColor redColor];
        [self addChild:s];

        SKShapeNode *block = [[SKShapeNode alloc] init];
        CGMutablePathRef p2 = CGPathCreateMutable();
        CGFloat block_length = w / 2;
        CGPathAddRect(p2, NULL, CGRectMake(0, 0, block_length, 4));
        block.path = p2;
        block.name = @"block";
        block.position = CGPointMake(m.x - block_length/2, m.y - h/2 - 2);
        block.strokeColor = block.fillColor = [SKColor redColor];
        block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(block_length/2, 4)];
        [self makeBody:block.physicsBody dynamic:FIXED];
        block.physicsBody.categoryBitMask = 1;
        block.physicsBody.collisionBitMask = 1;
        block.physicsBody.contactTestBitMask = 1;
        [self addChild:block];

        [self makeTheCarAt:CGPointMake(m.x, m.y + h/2)];

        [car runAction:[SKAction repeatActionForever:[SKAction followPath:p asOffset:NO orientToPath:YES duration:dur]]];
        [car runAction:[SKAction speedBy:3 duration:0.125]];
    }
    return self;
}

-(void)crossHair:(CGPoint)p {
    Turtle *t = [Turtle turtle];
    [t crossHair:CGPointMake(p.x, p.y)];
    [self addShape:t.getPath];
}

-(void)drawLineFromX:(CGPoint)x toY:(CGPoint)y {
    Turtle *t = [Turtle turtle];
    [t moveTo:x];
    [t drawTo:CGVectorMake(y.x - x.x, y.y - x.y)];
    [self addShape:t.getPath];
}

-(CGPathRef)drawRoundRectAt:(CGPoint)p withR:(CGFloat)r andHeight:(CGFloat)h andWidth:(CGFloat)w {
    Turtle *t = [Turtle turtle];
//    [t markRoundRectAt:p withR:r andHeight:h andWidth:w];
//    [self addShape:t.getPath];
    
    t = [Turtle turtle];
    [t makeRoundRectAt:p withR:r andHeight:h andWidth:w];
    [self addShape:t.getPath];
    return t.getPath;
}

-(void)addShape:(CGMutablePathRef)p {
    SKShapeNode *s = [[SKShapeNode alloc] init];
    s.path = p;
    s.strokeColor = [SKColor whiteColor];
    [self addChild:s];
}

- (void)makeScore {
    score = [self makeLabelAt:CGPointMake(m.x, m.y - 10) text:[NSString stringWithFormat:@"%d", points]];
    [self addChild:score];
}

-(void)makeTheCarAt:(CGPoint)p {
    car = [self makeCarAt:m dynamic:FREE];
    car.name = @"car";
    car.position = p;
    car.zRotation = 1.5*M_PI;
    car.physicsBody.categoryBitMask = 1;
    car.physicsBody.collisionBitMask = 1;
    car.physicsBody.contactTestBitMask = 1;
    [self addChild:car];
}

- (void)makeACornerAt:(CGPoint)p ofSize:(CGFloat)sz withRadius:(CGFloat)r id:(NSInteger)id {
    corner = [self makeBallAt:p ofRadius:sz dynamic:FIXED];
    corner.name = [NSString stringWithFormat:@"corner %d", id];
    corner.fillColor = corner.strokeColor = [SKColor whiteColor];
    corner.physicsBody.categoryBitMask = 1;
    corner.physicsBody.collisionBitMask = 0;
    corner.physicsBody.contactTestBitMask = 1;
    [self addChild:corner];
}

- (void)makeCornersAt:(CGPoint)p ofSize:(CGFloat)sz withR:(CGFloat)r andHeight:(CGFloat)h andWidth:(CGFloat)w {
    CGPoint ur = CGPointMake(p.x + w/2 - r, p.y + h/2);
    CGPoint lr = CGPointMake(p.x + w/2, p.y - h/2 + r);
    CGPoint ll = CGPointMake(p.x - w/2 + r, p.y - h/2);
    CGPoint ul = CGPointMake(p.x - w/2, p.y + h/2 - r);
    NSInteger id = 1;
    [self makeACornerAt:ur ofSize:sz withRadius:r id:id++];
    [self makeACornerAt:lr ofSize:sz withRadius:r id:id++];
    [self makeACornerAt:ll ofSize:sz withRadius:r id:id++];
    [self makeACornerAt:ul ofSize:sz withRadius:r id:id++];
}

- (SKAction *)shrink {
    flying = NO;
    return [SKAction scaleTo:CARSIZE duration:0.125];
}

- (SKAction *)grow {
    flying = YES;
    return [SKAction scaleTo:BIG_CARSIZE duration:0.125];
}

- (SKAction *)forward {
    return [SKAction speedTo:3 duration:0.125];
}

- (SKAction *)backward {
    return [SKAction speedTo:-3 duration:0.125];
}

- (void)penalty {
    [self updateScoreBy:-1];
    if (flying) {
        [self performSelector:@selector(penalty) withObject:nil afterDelay:0.5];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self collideOff:car.physicsBody];
    if (car.speed <= 0) {
        [car runAction:[SKAction sequence:@[[SKAction speedTo:3 duration:0.125],[SKAction waitForDuration:0.5],[self grow]]]];
    } else {
        [car runAction:[self grow]];
        [self performSelector:@selector(penalty) withObject:nil afterDelay:0.5];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [car collideOn:car.physicsBody];
    [car runAction:[self shrink]];
}

- (void)push {
    [car runAction:[self forward]];
}

- (void)backup {
    [car runAction:[self backward]];
    [car collideOn:car.physicsBody];
    [car runAction:[self shrink]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"%@, %@", contact.bodyA.node.name, contact.bodyB.node.name);
    NSRange r = [contact.bodyB.node.name rangeOfString:@"corner"];
    if (r.location == 0) {
        if (car.speed > 0)
            [self updateScoreBy:1];
    } else if ([contact.bodyA.node.name isEqualToString:@"block"]) {
        car.speed = 0;
        [self updateScoreBy:-1];
        [self performSelector:@selector(backup) withObject:nil afterDelay:0.05];
    }
}

- (void)updateScoreBy:(NSInteger)n {
    points += n;
    score.text = [NSString stringWithFormat:@"%d", points];
    NSLog(@"%d", points);
}

@end
