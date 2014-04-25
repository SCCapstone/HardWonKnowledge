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
@synthesize tempField;


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
 


- (IBAction)mergeTextTest:(id)sender {
    NSString *input = tempField.text;
    [self.delegate changeText:input];
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
