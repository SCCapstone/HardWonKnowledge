//
//  testView.m
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "SideBarView.h"

@implementation SideBarView
@synthesize pageNumber;

- (id)initWithCoder:(NSCoder *)aDecoder //Instantiated in interface builder, so initWithCoder used
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"SideBarView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:firstViewUIView];
        pageNumber.text = @"1";

    }
    return self;
}

- (IBAction)paintButtonPressed:(id)sender {
    [self.delegate showPaintSubmenu];
}
- (IBAction)menuButtonPressed:(id)sender {
    [self.delegate showMenuSubmenu];
}
- (IBAction)nextButtonPressed:(id)sender {
    [self.delegate nextPage];
}
- (IBAction)previousButtonPressed:(id)sender {
    [self.delegate previousPage];
}

- (IBAction)typeButtonPressed:(id)sender {
    [self.delegate showTypeSubmenu];
    
}

- (IBAction)cameraButtonPressed:(id)sender {
    [self.delegate showCameraSubmenu];
}

-(void)changePageNumber:(NSString *) newNumber
{
    pageNumber.text = newNumber;
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
