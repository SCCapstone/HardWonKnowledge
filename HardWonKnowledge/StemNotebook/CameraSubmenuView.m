//
//  CameraSubmenuView.m
//  StemNotebook
//
//  Created by Jacob on 3/20/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "CameraSubmenuView.h"

@implementation CameraSubmenuView

@synthesize delegate;
@synthesize displayImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *CameraSubmenuViewIB = [[[NSBundle mainBundle] loadNibNamed:@"CameraSubmenuView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:CameraSubmenuViewIB];
    }
    return self;
}


- (IBAction)importButtonClicked:(id)sender {
    [self.delegate importButtonClicked];
}


- (IBAction)cameraButtonClicked:(id)sender {
    [self.delegate cameraButtonClicked];
}

- (void) setDisplayImage:(UIImageView*)newImage
{
    //self.displayImage = newImage;
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
