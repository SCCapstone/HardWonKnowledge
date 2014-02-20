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

@end
