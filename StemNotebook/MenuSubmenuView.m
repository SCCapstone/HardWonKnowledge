//
//  MenuSubmenu.m
//  StemNotebook
//
//  Created by Colton Waters on 11/6/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "MenuSubmenuView.h"

@implementation MenuSubmenuView


- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"MenuSubmenuView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:firstViewUIView];
    }
    return self;
}
- (IBAction)DoButton:(id)sender {
    NSLog(@"NewButtonPressed");
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
