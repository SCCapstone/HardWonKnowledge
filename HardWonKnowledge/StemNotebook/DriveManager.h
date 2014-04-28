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
#import "ActiveUser.h"

@interface DriveManager : NSObject

@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) UIViewController *cont;
@property (nonatomic, strong) NSString *documentPath;
@property (nonatomic, strong) GTLDriveFile *appRoot;
@property (nonatomic, strong) GTLDriveFile *currentUserFolder;
@property (nonatomic, retain) ActiveUser *userManager;
#pragma mark -
#pragma mark Initialization Methods
+ (DriveManager*) getDriveManager;
- (void)initRootAppFolder;

#pragma mark -
#pragma mark Authentication Methods
- (BOOL)isAuthorized;
- (GTMOAuth2ViewControllerTouch *) createAuthController;
- (void)loginFromViewController:(UIViewController *)controller;
- (void)logout;

#pragma mark -
#pragma mark Drive File/Folder Methods
- (void)listDriveFiles;
- (void)uploadNotebook:(NSString*)filepath;
- (void)uploadNotebookNamed:(NSString *)name;
- (void)uploadNotebookNamed:(NSString *)name withParent:(GTLDriveFile *)parentFolder;
- (void)updateNotebook:(GTLDriveFile *)file fromFileNamed: (NSString *)name;
- (NSString *) downloadDriveFile:(GTLDriveFile *)file;
- (void) createFolderNamed:(NSString *)name withParent:(GTLDriveFile *)parentFolder;
- (void) createFolderUnderAppRootNamed:(NSString *)name;
- (void) deleteNotebook:(GTLDriveFile *)file;

#pragma mark -
#pragma mark methodsWithSelectorCallbacks
- (void)listFilesUnderFolder:(GTLDriveFile *)parent withCallback:(SEL)callbackSel;
- (void)uploadNotebookNamed:(NSString*)name withCallback:(SEL)callbackSel;
- (void)uploadNotebookNamed:(NSString *)name withParent:(GTLDriveFile *)parentFolder withCallback:(SEL)callbackSelector;
- (void)updateNotebook:(GTLDriveFile *)file fromFileNamed: (NSString *)name withCallback:(SEL)callbackSel;
- (NSString *) downloadDriveFile:(GTLDriveFile *)file withCallback:(SEL)callbackSel;
- (void) createFolderNamed:(NSString *)name withParent:(GTLDriveFile *)parentFolder withCallback:(SEL)callbackSel;
-(void) createFolderUnderAppRootNamed:(NSString *)name withCallback:(SEL)callbackSel;
- (void) createFolderUnderAppRootNamed:(NSString *)name completionHandler:(void (^)(GTLServiceTicket *ticket, GTLDriveFile *insertedFile, NSError *error)) handler;

#pragma mark -
#pragma mark Block Parameter Drive Methods
- (void)listFilesUnderFolder:(GTLDriveFile *)parent completionHandler:(void (^)(GTLServiceTicket*, GTLDriveFileList*, NSError*))handler;
- (void)uploadNotebookNamed:(NSString*)name completionhandler:(void (^)(GTLServiceTicket*, GTLDriveFile*, NSError*))handler;
- (void)uploadNotebookNamed:(NSString *)name withParent:(GTLDriveFile *)parentFolder completionhandler:(void (^)(GTLServiceTicket*, GTLDriveFile*, NSError*))handler;
- (void)updateNotebook:(GTLDriveFile *)file fromFileNamed: (NSString *)name completionhandler:(void (^)(GTLServiceTicket*, GTLDriveFile*, NSError*))handler;
- (NSString *) downloadDriveFile:(GTLDriveFile *)file completionHandler:(void (^)(NSData *data, NSError *error))handler;
- (void) createFolderNamed:(NSString *)name withParent:(GTLDriveFile *)parentFolder completionHandler:(void (^)(GTLServiceTicket *ticket, GTLDriveFile *insertedFile, NSError *error)) handler;

#pragma mark -
#pragma mark NonDriveSupportMethods
- (UIAlertView*)showWaitIndicator:(NSString *)title;
- (void)showAlert:(NSString *)title message:(NSString *)message;

@end
