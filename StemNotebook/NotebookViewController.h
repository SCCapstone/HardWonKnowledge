//
//  ViewController.h
//  StemNotebook
//
//  Created by Colton Waters on 10/27/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintSubmenuView.h"
#import "SideBarView.h"
#import "PaintView.h"

@interface NotebookViewController : UIViewController <NotebookViewDelegate>

//Views that the NotebookViewController will control
@property (strong, nonatomic) IBOutlet UIView *SubmenuView; //IBOutlet created from interface builder
@property (strong, nonatomic) PaintSubmenuView *paintSubmenu;
@property (strong, nonatomic) IBOutlet PaintView *paintView;

@end
