//
//  PaintView.m
//  StemNotebook
//
//  Created by Colton Waters on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "PaintView.h"


@implementation PaintView

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO]; // (2)
        drawImage = [aDecoder decodeObjectForKey:@"drawImage"];
        if (!drawImage) {
            drawImage = [[UIImageView alloc] initWithImage:nil];
            drawImage.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }
        [self addSubview:drawImage];
        self.backgroundColor = [UIColor whiteColor];
        red=0.0/255.0;
        blue = 0.0;
        green = 0.0;
        brush = 10.0;
}
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    swipe =NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self];
    //lastPoint.y -= 20;
    //lastPoint.x -=200;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    swipe = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    //currentPoint.y -= 20;
    //currentPoint.x -= 200;
    
    UIGraphicsBeginImageContext(self.frame.size);
    
//This is what needs to be changed to fix the window size v
    [drawImage.image drawInRect:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
//This is what needs to be changed to fix the window size ^
    
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
    
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!swipe)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        
//It shows up here too v
        [drawImage.image drawInRect:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
//It shows up here too ^
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen
{
    red = newRed;
    blue = newBlue;
    green = newGreen;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:drawImage forKey:@"drawImage"];
}


@end
