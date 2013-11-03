//
//  testView.m
//  StemNotebook
//
//  Created by Colton Waters on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "SideBarView.h"

@implementation SideBarView

{
    UIBezierPath *path; // (3)
}
- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"SideBarView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:firstViewUIView];
        [self setMultipleTouchEnabled:NO]; // (2)
        path = [UIBezierPath bezierPath];
        [path setLineWidth:20.0];
    }
    return self;
}
- (void)drawRect:(CGRect)rect // (5)
{
    [[UIColor redColor] setStroke];
    [path stroke];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p]; // (4)
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
