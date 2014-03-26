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
    NSLog(@"button clicked");
    [self.delegate importButtonClicked];
}

- (IBAction)cameraButtonClicked:(id)sender {
    [self.delegate cameraButtonClicked];
}

- (IBAction)videoButtonClicked:(id)sender {
   // [self.delegate videoButtonClicked];
}


- (void) setDisplayImage:(UIImageView*)newImage
{
    //self.displayImage = newImage;
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.displayImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}





- (void)imageVideoPickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.movieURL = info[UIImagePickerControllerMediaURL];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.movieController stop];
    [self.movieController.view removeFromSuperview];
    self.movieController = nil;
    
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
