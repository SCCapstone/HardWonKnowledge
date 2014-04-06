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
#import "TypeSubmenuView.h"
#import "CameraSubmenuView.h"
#import "BookshelfGridViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "NotebookViewDelegate.h"
#import "GTLDrive.h"
#import "DriveManager.h"
#import "ActiveUser.h"


@interface NotebookViewController : UIViewController <NotebookViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//Views that the NotebookViewController will control
@property (strong, nonatomic) IBOutlet UIView *SubmenuView; //IBOutlet created from interface builder
@property (strong, nonatomic) PaintSubmenuView *paintSubmenu;
@property (strong, nonatomic) MenuSubmenuView *menuSubmenu;
@property (strong, nonatomic) TypeSubmenuView *typeSubmenu;
@property (strong, nonatomic) CameraSubmenuView *cameraSubmenu;
@property (strong, nonatomic) IBOutlet PaintView *paintView;
@property (strong, nonatomic) IBOutlet SideBarView *sideBarView;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) DriveManager *driveManager;
@property (nonatomic, strong) GTLDriveFile *notebookDriveFile;

@property (strong,nonatomic) UIPopoverController *popoverImageViewController;
@property (nonatomic, retain) ActiveUser *userManager;

- (void) openNotebookNamed:(NSString *)name;
- (void) openNotebookFromFile:(GTLDriveFile *)file;
- (void) openNotebookFromPath:(NSString *)path title:(NSString *)title;

@end
