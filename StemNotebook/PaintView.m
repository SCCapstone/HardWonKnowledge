//
//  PaintView.m
//  StemNotebook
//
//  Created by Colton Waters on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "PaintView.h"


@implementation PaintView

@synthesize lastPoint;
@synthesize red;
@synthesize blue;
@synthesize green;
@synthesize swipe;
@synthesize brush;
@synthesize drawImage;

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    
    if (self = [super initWithCoder:aDecoder])
    {
        
        [self setMultipleTouchEnabled:NO]; // (2)
        self.drawImage = [[UIImageView alloc] initWithImage:nil];
        self.drawImage.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:self.drawImage];
        self.backgroundColor = [UIColor whiteColor];
        self.red=0.0;
        self.blue = 0.0;
        self.green = 0.0;
        self.brush = 10.0;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.swipe =NO;
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self];

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.swipe = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.drawImage.image drawInRect:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
    
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.lastPoint = currentPoint;
    
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.swipe)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        
        [self.drawImage.image drawInRect:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen
{
    self.red = newRed;
    self.blue = newBlue;
    self.green = newGreen;
}

- (void)changeBrushWithNumber:(float)number
{
    self.brush = number;
}

- (void)saveImageView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *viewPath = [docDir stringByAppendingPathComponent:@"Notebook2.nbf"];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.drawImage.image forKey:@"drawImage"];
    [archiver finishEncoding];
    if (![data writeToFile:viewPath atomically:YES])
        NSLog(@"BAD");
}

- (void)loadImageView
{
    NSLog(@"Decode Paint View");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *viewPath = [docDir stringByAppendingPathComponent:@"Notebook2.nbf"];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:viewPath];
    if (codedData == nil) return;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    UIImage *newImage = (UIImage*)[unarchiver decodeObjectForKey:@"drawImage"];
    if (newImage)
        self. drawImage.image = newImage;
    else
        NSLog(@"Bad Image");
    [unarchiver finishDecoding];
}


@end
