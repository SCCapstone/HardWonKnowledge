//
//  PaintSubmenuView.h
//  StemNotebook
//
//  Created by Jacob Wood on 11/3/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotebookViewDelegate.h"

@interface PaintSubmenuView : UIView

@property (nonatomic, strong) id <NotebookViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *blueBtn;
@property (weak, nonatomic) IBOutlet UIButton *yellowBtn;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;
@property (weak, nonatomic) IBOutlet UIButton *greenBtn;
@property (weak, nonatomic) IBOutlet UIButton *purpleBtn;
@property (weak, nonatomic) IBOutlet UIButton *orangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *brownBtn;
@property (weak, nonatomic) IBOutlet UIButton *eraseBtn;
@property (strong, nonatomic) NSArray *buttons;

@property (weak, nonatomic) IBOutlet UIButton *small;
@property (weak, nonatomic) IBOutlet UIButton *medium;
@property (weak, nonatomic) IBOutlet UIButton *large;
@property (strong, nonatomic) NSArray *sizes;




@end
