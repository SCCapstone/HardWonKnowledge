//
//  TypeSubmenuView.m
//  StemNotebook
//
//  Created by CLAYTON PIERCE GOETTE on 2/26/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "TypeSubmenuView.h"

@implementation TypeSubmenuView

@synthesize delegate;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *typeSubmenuViewIB = [[[NSBundle mainBundle] loadNibNamed:@"TypeSubmenuView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:typeSubmenuViewIB];
    }
    return self;
}
 


- (IBAction)sendNotesPressed:(id)sender {
    [self.delegate sendNotesPressed];
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
