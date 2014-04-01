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
        self.displayImage = [[UIImageView alloc] initWithImage:nil];
        self.displayImage.frame = CGRectMake(20,49,363,231);
        [self addSubview:displayImage];
        [self.displayImage setHidden:FALSE];
    }
    return self;
}


- (IBAction)importButtonClicked:(id)sender {
    [self.delegate importButtonClicked];
}


- (IBAction)cameraButtonClicked:(id)sender {
    [self.delegate cameraButtonClicked];
}


- (void) changeDisplayImage:(UIImage*)image
{
    [self.displayImage setHidden:TRUE];
    int width = image.size.width;
    int height = image.size.height;
    self.displayImage.frame = CGRectMake(20,49,363,231);
    while(displayImage.frame.size.height <= height || displayImage.frame.size.width <= width)
    {
        width--;
        height--;
    }
    self.displayImage.image = image;
    self.displayImage.frame = CGRectMake(200-width/2,165-height/2,width, height);
    [self addSubview:self.displayImage];
    [self.displayImage setHidden:FALSE];
    self.displayImage.image = image;
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
