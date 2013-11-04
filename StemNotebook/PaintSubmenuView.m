//
//  PaintSubmenuView.m
//  StemNotebook
//
//  Created by Jacob on 11/3/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "PaintSubmenuView.h"

@implementation PaintSubmenuView

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"PaintSubmenuView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:firstViewUIView];
    }
    return self;
}
- (IBAction)doButton:(id)sender {
    NSLog(@"Button Pressed");
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
