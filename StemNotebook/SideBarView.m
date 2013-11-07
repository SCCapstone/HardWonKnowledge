//
//  testView.m
//  StemNotebook
//
//  Created by Colton Waters on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "SideBarView.h"

@implementation SideBarView

- (id)initWithCoder:(NSCoder *)aDecoder //Instantiated in interface builder, so initWithCoder used
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"SideBarView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:firstViewUIView];

    }
    return self;
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
