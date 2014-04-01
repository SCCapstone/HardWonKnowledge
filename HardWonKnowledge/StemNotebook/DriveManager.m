//
//  DriveManager.m
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 12/5/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "DriveManager.h"

static NSString *const kKeychainItemName = @"Stem Notebook";
static NSString *const kClientID = @"279186473369-fq4ejbk5ovj6kdt68e039q8571ip5oqu.apps.googleusercontent.com";
static NSString *const kClientSecret = @"nZP3QMG9DIfcnHvpnOnnXrdY";


@implementation DriveManager
@synthesize appRoot;
@synthesize currentUserFolder;

#pragma mark -
#pragma mark Initialization Methods
+ (DriveManager*) getDriveManager;
{
    static DriveManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DriveManager alloc] init];
        // Do any other initialisation stuff here
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        sharedInstance.documentPath = [paths objectAtIndex:0];

        sharedInstance.driveService = [[GTLServiceDrive alloc] init];
        sharedInstance.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                             clientID:kClientID
                                                                                         clientSecret:kClientSecret];
        [sharedInstance initRootAppFolder];
        NSLog(@"Drive Manager Initialized");
    });
    return sharedInstance;
}

- (void)initRootAppFolder
{
    NSString *search = @"title = 'StemNotebook'";
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            //Good
            for (GTLDriveFile *file in files) {
                if ([file.title compare:@"StemNotebook"] == 0)
                    self.appRoot = file;
            }
            if (self.appRoot == nil) {
                GTLDriveFile *folder = [GTLDriveFile object];
                folder.title = @"StemNotebook";
                folder.mimeType = @"application/vnd.google-apps.folder";
                
                GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:folder uploadParameters:nil];
                [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                                          GTLDriveFile *updatedFile,
                                                                          NSError *error) {
                    if (error == nil) {
                        NSLog(@"Created folder");
                    } else {
                        NSLog(@"An error occurred: %@", error);
                    }
                }];
            }
        } else {
            NSLog (@"An Error has occurred: %@", error);
        }
    }];
}

#pragma mark -
#pragma mark Authentication Methods
- (BOOL)isAuthorized
{
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    [self.cont dismissViewControllerAnimated:YES completion:nil];
    self.cont = nil;
    if (error != nil)
    {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.driveService.authorizer = nil;
    }
    else
    {
        
        self.driveService.authorizer = authResult;
    }
}


- (void)loginFromViewController:(UIViewController *)controller
{
    self.cont = controller;
    if (![self isAuthorized]) {
        // Sign in.
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController =
        [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                   clientID:kClientID
                                               clientSecret:kClientSecret
                                           keychainItemName:kKeychainItemName
                                                   delegate:self
                                           finishedSelector:finishedSelector];
//        authViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//        authViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        authViewController.view.superview.frame = CGRectMake(0, 0, 300, 400);
//        authViewController.view.superview.center = self.view.center;
        [self.cont presentViewController:authViewController
                                animated:YES completion:nil];
    } else {
        [self showAlert:@"Logged In" message:@"You are already logged in."];
    }
}

- (void) logout
{
    if ([self isAuthorized]) {
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
        [[self driveService] setAuthorizer:nil];
        [self showAlert:@"Log Out" message:@"You have been logged out."];
    } else {
        [self showAlert:@"Not Logged In" message:@"You are currently  not logged in."];
 
    }
}

#pragma mark -
#pragma mark Drive File/Folder Methods
- (void)uploadNotebook:(NSString*)filepath
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"'Stem Notebook upload ('EEEE MMMM d, YYYY h:mm a, zzz')"];
    
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = [dateFormat stringFromDate:[NSDate date]];
    file.descriptionProperty = @"Uploaded from StemNotebook App";
    file.mimeType = @"application/octet-stream";
    
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        data = [[NSFileManager defaultManager] contentsAtPath:filepath];
    }
    else
    {
        NSLog(@"File not exists");
    }
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    NSLog(@"Uploading to Google Drive...");
    
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      NSLog(@"Done");
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          //[self showAlert:@"Google Drive" message:@"File saved!"];
                          NSLog(@"Google Drive: File Saved");
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          //[self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                          NSLog(@"An Error Occured");
                      }
                  }];
}

- (void)uploadNotebookNamed:(NSString*)name
{
    
    //setup path for file
    NSString *filepath = [self.documentPath stringByAppendingPathComponent:name];
    
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = name;
    file.descriptionProperty = @"Uploaded from StemNotebook App";
    file.mimeType = @"application/octet-stream";
    
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        data = [[NSFileManager defaultManager] contentsAtPath:filepath];
    }
    else
    {
        NSLog(@"File not exits");
    }
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    NSLog(@"Uploading to Google Drive...");
    
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      NSLog(@"Done");
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          //[self showAlert:@"Google Drive" message:@"File saved!"];
                          NSLog(@"Google Drive: File Saved");
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          //[self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                          NSLog(@"An Error Occured");
                      }
                  }];
}

- (void)updateNotebook:(GTLDriveFile *)file fromFileNamed: (NSString *)name
{
    
    //setup path for file
    NSString *filepath = [self.documentPath stringByAppendingPathComponent:name];
    
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        data = [[NSFileManager defaultManager] contentsAtPath:filepath];
    }
    else
    {
        NSLog(@"File not exits");
    }
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesUpdateWithObject:file
                                                       fileId:file.identifier
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    NSLog(@"Uploading to Google Drive...");
    
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      NSLog(@"Done");
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          //[self showAlert:@"Google Drive" message:@"File saved!"];
                          NSLog(@"Google Drive: File Saved");
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          //[self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                          NSLog(@"An Error Occured");
                      }
                  }];
}



- (GTLDriveFileList *)listDriveFiles {
    NSString *search = @"title contains '.nbf'";
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            //Good
            for (GTLDriveFile *file in files) {
                NSLog(@"Drive File: %@",file.title);
            }
        } else {
            NSLog (@"An Error has occurred: %@", error);
        }
    }];
    return nil;
}

- (NSString *) downloadDriveFile:(GTLDriveFile *)file
{
    //Get Download Path
    NSString *viewPath = [self.documentPath stringByAppendingPathComponent:file.title];
    
    //Setup HTTP Fetcher
    GTMHTTPFetcher *fetcher = [self.driveService.fetcherService fetcherWithURLString:file.downloadUrl];
    fetcher.downloadPath = viewPath;
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error == nil) {
            //Save file to disk
            NSLog(@"Retrieved file content");
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
    return viewPath;
}

- (void) createFolderNamed:(NSString *)name withParent:(GTLDriveFile *)parentFolder
{
    NSString *parentId = parentFolder.identifier;

    GTLDriveParentReference *parent = [GTLDriveParentReference object];
    parent.identifier = parentId;

    GTLDriveFile *folder = [GTLDriveFile object];
    folder.title = name;
    folder.mimeType = @"application/vnd.google-apps.folder";
    folder.parents = @[parent];

    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:folder uploadParameters:nil];

    UIAlertView *waitIndicator = [self showWaitIndicator:@"Creating Student Folder"];
    NSLog(@"Creating Student Folder...");
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      NSLog(@"Done");
                      if (error == nil)
                      {
                          NSLog(@"Folder ID: %@", insertedFile.identifier);
                          NSLog(@"Google Drive: Folder Saved");
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                      }
                  }];
    
}

- (void) createFolderUnderAppRootNamed:(NSString *)name
{
    [self createFolderNamed:name withParent:self.appRoot];
}

#pragma mark -
#pragma mark methodsWithSelectorCallbacks
//callbackSel should have one input, a GTLDriveFileList* object;
//To call, do this:
//[driveManager listFilesUnderFolder:someFolder withCallback:@selector(someMethod:)];
//METHOD SHOULD HAVE VOID RETURN
- (void)listFilesUnderFolder:(GTLDriveFile *)parent withCallback:(SEL)callbackSel
{
    NSString *parentId = nil;
    if (parent == nil)
        parentId = @"root";
    else
        parentId = parent.identifier;
    
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = [NSString stringWithFormat:@"'%@' in parents", parentId];
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFileList *files,
                                                              NSError *error) {
        if (error == nil) {
            if (@selector(callbackSel) != nil)
                [self performSelector:@selector(callbackSel) withObject:files];
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
}

//callbackSel should have one input, a GTLDriveFile* object;
//to call, do this:
//[driveManager uploadNotebookNamed:notebook withCallback:@selector(someMethod:)];
//METHOD SHOULD HAVE VOID RETURN
- (void)uploadNotebookNamed:(NSString*)name withCallback:(SEL)callbackSel
{
    //setup path for file
    NSString *filepath = [self.documentPath stringByAppendingPathComponent:name];
    
    //instantiate GTLDriveFile object
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = name;
    file.descriptionProperty = @"Uploaded from StemNotebook App";
    file.mimeType = @"application/octet-stream";
    
    //Get data From File
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        data = [[NSFileManager defaultManager] contentsAtPath:filepath];
    }
    else
    {
        NSLog(@"Local File Does Not Exist");
        return;
    }
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          NSLog(@"Google Drive: File Saved");
                          if (@selector(callbackSel) != nil)
                              [self performSelector:@selector(callbackSel) withObject:insertedFile];
                      }
                      else
                      {
                          NSLog(@"An Error Occured: %@", error);
                      }
                  }];
}

//callbackSel should have one input, a GTLDriveFile* object;
//to call, do this:
//[driveManager uploadNotebookNamed:notebook withCallback:@selector(someMethod:)];
//METHOD SHOULD HAVE VOID RETURN
- (void)updateNotebook:(GTLDriveFile *)file fromFileNamed: (NSString *)name withCallback:(SEL)callbackSel
{
    //setup path for file
    NSString *filepath = [self.documentPath stringByAppendingPathComponent:name];
    
    //Get data from file
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        data = [[NSFileManager defaultManager] contentsAtPath:filepath];
    }
    else
    {
        NSLog(@"File not exits");
        return;
    }
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesUpdateWithObject:file
                                                                 fileId:file.identifier
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    NSLog(@"Uploading to Google Drive...");
    
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      NSLog(@"Done");
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          NSLog(@"Google Drive: File Saved");
                          if (@selector(callbackSel) != nil)
                              [self performSelector:@selector(callbackSel) withObject:insertedFile];

                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          //[self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                          NSLog(@"An Error Occured");
                      }
                  }];
}

//callbackSel should have one input, an NSData object
//to call, do this:
//[driveManager downloadDriveFile:someFile withCallback:@selector(someMethod:)];
//METHOD SHOULD HAVE VOID RETURN
- (NSString *) downloadDriveFile:(GTLDriveFile *)file withCallback:(SEL)callbackSel
{
    //Get Download Path
    NSString *viewPath = [self.documentPath stringByAppendingPathComponent:file.title];
    
    //Setup HTTP Fetcher
    GTMHTTPFetcher *fetcher = [self.driveService.fetcherService fetcherWithURLString:file.downloadUrl];
    fetcher.downloadPath = viewPath;
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error == nil) {
            //Save file to disk
            NSLog(@"Retrieved file content");
            if (@selector(callbackSel) != nil)
                [self performSelector:@selector(callbackSel) withObject:data];
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
    return viewPath;
}

//callbackSel should have on einput, a GTLDriveFile object
//to call, do this:
//[driveManager createFolderNamed:folderName withParent:parentFolder withCallback:@selector(someMethod:)];
//METHOD SHOULD HAVE VOID RETURN
- (void) createFolderNamed:(NSString *)name withParent:(GTLDriveFile *)parentFolder withCallback:(SEL)callbackSel
{
    NSString *parentId = parentFolder.identifier;

    GTLDriveParentReference *parent = [GTLDriveParentReference object];
    parent.identifier = parentId;

    GTLDriveFile *folder = [GTLDriveFile object];
    folder.title = name;
    folder.mimeType = @"application/vnd.google-apps.folder";
    folder.parents = @[parent];

    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:folder uploadParameters:nil];

    UIAlertView *waitIndicator = [self showWaitIndicator:@"Creating Student Folder"];
    NSLog(@"Creating Student Folder...");
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      NSLog(@"Done");
                      if (error == nil)
                      {
                          NSLog(@"Folder ID: %@", insertedFile.identifier);
                          NSLog(@"Google Drive: Folder Saved");
                          [self performSelector:@selector(callbackSel) withObject:insertedFile];
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                      }
                  }];
    
}

//callbackSel should have on einput, a GTLDriveFile object
//to call, do this:
//[driveManager createFolderNamed:folderName withParent:parentFolder withCallback:@selector(someMethod:)];
//METHOD SHOULD HAVE VOID RETURN
- (void) createFolderUnderAppRootNamed:(NSString *)name  withCallback:(SEL)callbackSel
{
    [self createFolderNamed:name withParent:self.appRoot withCallback:callbackSel];
}

#pragma mark -
#pragma mark NonDriveSupportMethods
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}
@end
