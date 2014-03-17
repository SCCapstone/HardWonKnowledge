//
//  DriveManager.h
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 12/5/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "NotebookViewDelegate.h"
#import "GTLDrive.h"

@interface DriveManager : NSObject

@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) UIViewController *cont;

+ (DriveManager*) getDriveManager;
- (BOOL) isAuthorized;
- (GTMOAuth2ViewControllerTouch *) createAuthController;
- (void)uploadNotebook:(NSString*)filepath;
- (void)uploadNotebookNamed:(NSString *)name;
- (UIAlertView*)showWaitIndicator:(NSString *)title;
- (void)showAlert:(NSString *)title message:(NSString *)message;
- (void)loginFromViewController:(UIViewController *)controller;
- (void)logout;
- (GTLDriveFileList *) listDriveFiles;

@end
