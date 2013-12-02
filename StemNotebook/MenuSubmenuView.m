//
//  MenuSubmenuView.m
//  StemNotebook
//
//  Created by Colton Waters on 11/22/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "MenuSubmenuView.h"

@implementation MenuSubmenuView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *menuSubmenuViewIB = [[[NSBundle mainBundle] loadNibNamed:@"MenuSubmenuView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:menuSubmenuViewIB];
    }
    return self;
}
- (IBAction)encodePaintView:(id)sender {
    [self.delegate encodePaintView];
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
