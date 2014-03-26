//
//  CameraSubmenuView.h
//  StemNotebook
//
//  Created by Jacob on 3/20/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NotebookViewDelegate.h"

@interface CameraSubmenuView : UIView

@property (nonatomic, strong) id <NotebookViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *displayImage;
@property (copy,   nonatomic) NSURL *movieURL;
@property (strong, nonatomic) MPMoviePlayerController *movieController;


@end
