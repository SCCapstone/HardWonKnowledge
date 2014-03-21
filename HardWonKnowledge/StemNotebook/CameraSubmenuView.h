//
//  CameraSubmenuView.h
//  StemNotebook
//
//  Created by Jacob on 3/20/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotebookViewDelegate.h"

@interface CameraSubmenuView : UIView

@property (nonatomic, strong) id <NotebookViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *displayImage;


@end
