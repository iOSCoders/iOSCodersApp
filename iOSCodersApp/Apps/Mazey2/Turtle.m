//
//  Turtle.m
//  Mazey2
//
//  Created by Joe Bologna on 9/9/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Turtle.h"

@interface Turtle() {
    CGPoint curPoint;
    CGMutablePathRef path;
    CGSize size;
    CGPoint m;
}

@end

@implementation Turtle

- (id)init {
    if (self = [super init]) {
        curPoint = CGPointMake(0, 0);
        path = CGPathCreateMutable();
        size = [[UIScreen mainScreen] bounds].size;
        m = CGPointMake(size.width/2, size.height/2);
    }
    return self;
}

+ (Turtle *)turtle {
    Turtle *t = [[self alloc] init];
    return t;
}

- (void)moveTo:(CGPoint)p {
    curPoint = p;
    CGPathMoveToPoint(path, NULL, curPoint.x, curPoint.y);
}

- (void)moveBy:(CGVector)v {
    curPoint = CGPointMake(curPoint.x + v.dx, curPoint.y + v.dy);
    CGPathMoveToPoint(path, NULL, curPoint.x, curPoint.y);
}

- (void)drawTo:(CGVector)v {
    curPoint = CGPointMake(curPoint.x + v.dx, curPoint.y + v.dy);
    CGPathAddLineToPoint(path, NULL, curPoint.x, curPoint.y);
}

- (void)arcFrom:(CGVector)v withRadius:(CGFloat)r {
    CGPathMoveToPoint(path, NULL, curPoint.x + v.dx + r, curPoint.y + v.dy + r);
    curPoint = CGPointMake(curPoint.x + v.dx, curPoint.y + v.dy + r);
    CGPathAddArc(path, NULL, curPoint.x, curPoint.y, r, 0, 2*M_PI, YES);
}

-(void)llCornerwithRadius:(CGFloat)r {
    CGPathMoveToPoint(path, NULL, curPoint.x + r, curPoint.y - r);
    CGPathAddArc(path, NULL, curPoint.x + r, curPoint.y, r, -0.5*M_PI, -1*M_PI, YES);
}

-(void)lrCornerwithRadius:(CGFloat)r {
    CGPathMoveToPoint(path, NULL, curPoint.x, curPoint.y);
    CGPathAddArc(path, NULL, curPoint.x, curPoint.y - r, r, -0.5*M_PI, 0*M_PI, NO);
}

-(void)urCornerwithRadius:(CGFloat)r {
    CGPathMoveToPoint(path, NULL, curPoint.x, curPoint.y);
    CGPathAddArc(path, NULL, curPoint.x, curPoint.y, r, 0, 2*M_PI, YES);
}

-(void)ulCornerwithRadius:(CGFloat)r {
    curPoint = CGPointMake(curPoint.x + r, curPoint.y + r);
    CGPathAddArc(path, NULL, curPoint.x, curPoint.y, r, 0, 2*M_PI, YES);
}

/*
 Draw rect of size WxH, centered at x, y
 
 
 2. Move the starting point to UL at the beginning of the arc. x-r+w/2, y+r+h/2, draw the arc from this point. The end of the arc will be at: x+w/2, y+h/2. Continue in the same manner...
 
 UR: x+r+w/2,y+r+h/2,r,270,0
 LR: x+w/2,y-h/2,r,0,90
 LL: x-r-w/2,y-r-h/2,r,90,180
 UL: x-r-w/2,y+h/2,r,180,270
 */


-(void)markRoundRectAt:(CGPoint)p withR:(CGFloat)r andHeight:(CGFloat)h andWidth:(CGFloat)w {
    CGPoint ur = CGPointMake(m.x + w/2, m.y + h/2);
    CGPoint lr = CGPointMake(m.x + w/2, m.y - h/2);
    CGPoint ll = CGPointMake(m.x - w/2, m.y - h/2);
    CGPoint ul = CGPointMake(m.x - w/2, m.y + h/2);
//    Draw crosshairs at center, UL, UR, LR, UL to show the bounds of the rectangle
    [self crossHair:m];
    [self crossHair:ur];
    [self crossHair:lr];
    [self crossHair:ll];
    [self crossHair:ul];
}

-(void)makeRoundRectAt:(CGPoint)p withR:(CGFloat)r andHeight:(CGFloat)h andWidth:(CGFloat)w {
    CGPoint ur = CGPointMake(m.x + w/2, m.y + h/2);
    CGPoint lr = CGPointMake(m.x + w/2, m.y - h/2);
    CGPoint ll = CGPointMake(m.x - w/2, m.y - h/2);
    CGPoint ul = CGPointMake(m.x - w/2, m.y + h/2);

/*
 The location of radians on the arc are:
     090
      +
      |
180 +-+-+ 000, 360
      |
      +
     270
 
 When drawing in the clockwise direction, the lower radian must preceed the larger radian. The larger radian must be 360 not 0.
 The order of arcs drawn is significant because the a line is drawn from the current point to the start of the arc, to make it
 continuous the start of the arc must be aligned with the the point where the last vector ended.
 */
    
//    Move to the start of the UR arc
    path = CGPathCreateMutable();

    // UR
    curPoint = CGPointMake(ur.x - r, ur.y);
    CGPathMoveToPoint(path, NULL, curPoint.x, curPoint.y);
    curPoint = CGPointMake(curPoint.x, curPoint.y - r);
    CGPathAddArc(path, NULL, curPoint.x, curPoint.y, r, 0.5*M_PI, 2*M_PI, YES);

    // LR
    curPoint = CGPointMake(lr.x - r, lr.y + r);
    CGPathAddArc(path, NULL, curPoint.x, curPoint.y, r, 2*M_PI, 1.5*M_PI, YES);

    // LL
    curPoint = CGPointMake(ll.x + r, ll.y + r);
    CGPathAddArc(path, NULL, curPoint.x, curPoint.y, r, 1.5*M_PI, 1*M_PI, YES);
    
    // UL
    curPoint = CGPointMake(ul.x + r, ul.y - r);
    CGPathAddArc(path, NULL, curPoint.x, curPoint.y, r, 1*M_PI, 0.5*M_PI, YES);
    curPoint = CGPointMake(ur.x - r, ur.y);
    CGPathAddLineToPoint(path, NULL, curPoint.x, curPoint.y);
}

-(void)crossHair:(CGPoint)p {
    CGFloat sz = 10;
    CGPathMoveToPoint(path, NULL, p.x - sz/2, p.y);
    CGPathAddLineToPoint(path, NULL, p.x + sz/2, p.y);
    CGPathMoveToPoint(path, NULL, p.x, p.y - sz/2);
    CGPathAddLineToPoint(path, NULL, p.x, p.y + sz/2);
}

- (CGMutablePathRef)getPath {
    return path;
}
@end
