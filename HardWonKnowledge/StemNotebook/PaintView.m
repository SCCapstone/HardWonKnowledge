//
//  PaintView.m
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "PaintView.h"
#import <QuartzCore/QuartzCore.h>


@implementation PaintView


@synthesize lastPoint;
@synthesize red;
@synthesize blue;
@synthesize green;
@synthesize alpha;
@synthesize swipe;
@synthesize brush;
@synthesize drawImage;
@synthesize drawLabel;
@synthesize drawField;
@synthesize pages;
@synthesize current;
@synthesize textAdd;
@synthesize inTextMode;


//Initialize the view
- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO]; // (2)
        current = 0;
        
        
        self.pages = [[NSMutableArray alloc] init];
        for(int i = 0; i<25; i++)
        {

            self.drawImage = [[UIImageView alloc] initWithImage:nil];
            self.drawImage.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        
                     
            
            [pages addObject:drawImage];
        }
        
        self.drawImage = [pages objectAtIndex:current];
        [self addSubview:self.drawImage];
        self.backgroundColor = [UIColor whiteColor];
        self.red=0.0;
        self.blue = 0.0;
        self.green = 0.0;
        self.alpha = 1;        
        self.brush = 10.0;
        self.inTextMode = FALSE;
    }
    return self;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.swipe =NO;
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self];
    //if(self.alpha==0)
    //{
   //    NSLog(@"if working");
    //    self.drawLabel = [[UILabel alloc] initWithFrame:CGRectMake (0, -300, self.bounds.size.width, self.bounds.size.height)];
   //
   //     self.drawLabel.text = @"test";
   //     self.drawLabel.numberOfLines = 1;
   //     self.drawLabel.backgroundColor = [UIColor clearColor];
   //     self.drawLabel.textColor = [UIColor blackColor];
   //
   //     [self.drawImage addSubview: self.drawLabel];
   // }
    if(inTextMode)
    {
        self.alpha = 0;
        [self sendNotesPressedWithX:self.lastPoint.x WithY:self.lastPoint.y];
    }
    

}
    
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!inTextMode)
    {
        self.swipe = YES;
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
    
        
        UIGraphicsBeginImageContext(self.frame.size);
    
        [self.drawImage.image drawInRect:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
    
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.alpha);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    
        self.lastPoint = currentPoint;
    }
    
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!inTextMode)
    {
        if(!self.swipe)
        {
        
            UIGraphicsBeginImageContext(self.frame.size);
        
            [self.drawImage.image drawInRect:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
        
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.alpha);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    else
    {
        self.alpha = 1;
      
    }
}

- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen Alpha:(float)newAlpha
{
    self.red = newRed;
    self.blue = newBlue;
    self.green = newGreen;
    self.alpha = newAlpha;
}

- (void)changeBrushWithNumber:(float)number
{
    self.brush = number;
}

- (void)changeText:(NSString *)text
{
    self.textAdd = text;
    
}

- (void)changeAlphaWithNumber:(float)newAlpha
{
    self.alpha = newAlpha;
}

- (void)changeTextMode:(BOOL)newMode
{
    self.inTextMode = newMode;
}

//save the notebook to a file
- (void)saveImageView
{
    NSLog(@"Save Image View Called");
    
    //setup path for file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *viewPath = [docDir stringByAppendingPathComponent:@"Notebook2.nbf"];
    
    //variable for data to be written
    NSMutableData *data = [[NSMutableData alloc] init];
    
    //setup archiver for data
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    //archive images
    for (int i = 0; i < 25; i++) {
        UIImageView *imv = [self.pages objectAtIndex:i];
        if (imv.image != nil) {
            [archiver encodeObject:imv.image forKey:[@"image-" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
            //NSLog([@"image-" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]);
        }
    }
    
    [archiver finishEncoding];
    
    //write to file
    if (![data writeToFile:viewPath atomically:YES])
        NSLog(@"Failed to write data to file!");
}

//load the notebook from a file
- (void)loadImageView
{
    NSLog(@"Decode Paint View");
    
    //setup path for file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *viewPath = [docDir stringByAppendingPathComponent:@"Notebook2.nbf"];
    
    //get data from file
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:viewPath];
    if (codedData == nil) return;
    
    //unarchive data
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    
    //get images from archive
    for (int i = 0; i<25; i++) {
        UIImage *newImage = (UIImage*)[unarchiver decodeObjectForKey:[@"image-" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
        //NSLog([@"image-" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]);
        UIImageView *v = [self.pages objectAtIndex:i];
        v.image = newImage;
    }
    [unarchiver finishDecoding];
    
    //Reset to page 1
    current = 0;
    [self.drawImage setHidden:TRUE];
    self.drawImage = [pages objectAtIndex:current];
    [self addSubview:self.drawImage];
    [self.drawImage setHidden:FALSE];
}

//move to next page
-(void)nextPage
{
    
    current = current +1;
    if(current <25)
    {
        [self.drawImage setHidden:TRUE];
        self.drawImage = [pages objectAtIndex:current];
        [self addSubview:self.drawImage];
        [self.drawImage setHidden:FALSE];
    }
    else
    {
        current = 24;
    }
}


//move to previous page
-(void)previousPage
{
    current = current -1;
    
    if(current >= 0)
    {
        [self.drawImage setHidden:TRUE];
        self.drawImage = [pages objectAtIndex:current];
        [self addSubview:self.drawImage];
        [self.drawImage setHidden:FALSE];
    }
    else
    {
        current = 0;
    }    
    
}

-(void)sendNotesPressedWithX:(int)newX WithY:(int)newY
{

    NSLog(@"sendNotes called"); //testing purposes.
    self.drawLabel = [[UILabel alloc] initWithFrame:CGRectMake (newX, newY, 1000, 20)];
    NSString *input = self.textAdd;
    self.drawLabel.text = input;
    self.drawLabel.numberOfLines = 1;
    self.drawLabel.backgroundColor = [UIColor clearColor];
    self.drawLabel.textColor = [UIColor blackColor];

    [self.drawImage addSubview: self.drawLabel];
    
    UIGraphicsBeginImageContextWithOptions(self.drawImage.bounds.size, NO, 0.0);
    [self.drawImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    [self.drawLabel removeFromSuperview];
    
    UIGraphicsEndImageContext();
    self.drawImage.image = image;
    
    
    
}








@end
