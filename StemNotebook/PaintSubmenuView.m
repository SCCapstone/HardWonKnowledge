//
//  PaintSubmenuView.m
//  StemNotebook
//
//  Created by Jacob on 11/3/13.
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

//Method called when button is pressed.
//Should be replaced with relevant methods when UI is more fleshed out
- (IBAction)doButton:(id)sender {
    NSLog(@"Button Pressed");
    [self.delegate PaintViewButtonPressed];
    [self.delegate changeColorWithRed:255 Blue:255 Green:255];

}

- (IBAction)Red:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:0 Green:0];

}

- (IBAction)Blue:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:255 Green:0];   
 
}
- (IBAction)Green:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:0 Green:255];
}
- (IBAction)Black:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:0 Green:0];
}

- (IBAction)White:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:255 Green:255];
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
