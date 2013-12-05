//
//  PaintSubmenuView.m
//  StemNotebook
//
//  Created by Jacob Wood on 11/3/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "PaintSubmenuView.h"

@implementation PaintSubmenuView

@synthesize delegate;

//initialized in code, so initWithFrame is used
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView *paintSubmenuViewIB = [[[NSBundle mainBundle] loadNibNamed:@"PaintSubmenuView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:paintSubmenuViewIB];
    }
    return self;
}


- (IBAction)Red:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:0 Green:0 Alpha:1];

}

- (IBAction)Blue:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:255 Green:0 Alpha:1.0];
 
}
- (IBAction)Green:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:0 Green:255 Alpha:1.0];
}
- (IBAction)Black:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:0 Green:0 Alpha:1.0];
}

- (IBAction)White:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:255 Green:255 Alpha:1.0];
}

- (IBAction)Yellow:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:0 Green:255 Alpha:1.0];
}

- (IBAction)Purple:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:255 Green:0 Alpha:1.0];
}

- (IBAction)Orange:(id)sender {
    CGFloat red, green, blue, alpha;
    UIColor* color = [UIColor orangeColor];
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    [self.delegate changeColorWithRed:red Blue:blue Green:green Alpha:alpha];
}

- (IBAction)Brown:(id)sender {
    CGFloat red, green, blue, alpha;
    UIColor* color = [UIColor brownColor];
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    [self.delegate changeColorWithRed:red Blue:blue Green:green Alpha:alpha];
}




- (IBAction)Small:(id)sender {
    [self.delegate changeBrushWithNumber:2.5];
}
- (IBAction)Normal:(id)sender {
    [self.delegate changeBrushWithNumber:10];
}

- (IBAction)Large:(id)sender {
    [self.delegate changeBrushWithNumber:20];
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
