//
//  ViewController.h
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 10/27/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintSubmenuView.h"
#import "SideBarView.h"
#import "PaintView.h"
#import "MenuSubmenuView.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "NotebookViewDelegate.h"
#import "GTLDrive.h"

@interface NotebookViewController : UIViewController <NotebookViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//Views that the NotebookViewController will control
@property (strong, nonatomic) IBOutlet UIView *SubmenuView; //IBOutlet created from interface builder
@property (strong, nonatomic) PaintSubmenuView *paintSubmenu;
@property (strong, nonatomic) MenuSubmenuView *menuSubmenu;
@property (strong, nonatomic) IBOutlet PaintView *paintView;
@property (strong, nonatomic) IBOutlet SideBarView *sideBarView;
@property (nonatomic, retain) GTLServiceDrive *driveService;

@end
