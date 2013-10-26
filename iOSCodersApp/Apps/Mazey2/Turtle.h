//
//  Turtle.h
//  Mazey2
//
//  Created by Joe Bologna on 9/9/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Turtle : NSObject

+ (Turtle *)turtle;

-(void)moveTo:(CGPoint)p;
-(void)moveBy:(CGVector)v;
-(void)drawTo:(CGVector)v;
-(void)arcFrom:(CGVector)v withRadius:(CGFloat)r;
-(void)llCornerwithRadius:(CGFloat)r;
-(void)lrCornerwithRadius:(CGFloat)r;
-(void)urCornerwithRadius:(CGFloat)r;
-(void)ulCornerwithRadius:(CGFloat)r;
-(void)markRoundRectAt:(CGPoint)p withR:(CGFloat)r andHeight:(CGFloat)h andWidth:(CGFloat)w;
-(void)makeRoundRectAt:(CGPoint)p withR:(CGFloat)r andHeight:(CGFloat)h andWidth:(CGFloat)w;
-(void)crossHair:(CGPoint)p;
-(CGMutablePathRef)getPath;

@end
