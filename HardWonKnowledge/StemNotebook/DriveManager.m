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

+ (DriveManager*) getDriveManager;
{
    static DriveManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DriveManager alloc] init];
        // Do any other initialisation stuff here
        sharedInstance.driveService = [[GTLServiceDrive alloc] init];
        sharedInstance.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                             clientID:kClientID
                                                                                         clientSecret:kClientSecret];
    });
    NSLog(@"Drive Manager Initialized");
    return sharedInstance;
}

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
        authViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        authViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        authViewController.view.superview.frame = CGRectMake(0, 0, 300, 400);
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filepath = [docDir stringByAppendingPathComponent:name];
    
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


- (GTLDriveFileList *)listDriveFiles {
    NSString *search = @"title contains '.nbf'";
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    __block GTLDriveFileList *list = nil;
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            //Good
            for (GTLDriveFile *file in files) {
                NSLog(@"Drive File: %@",file.title);
            }
            list = files;
        } else {
            NSLog (@"An Error has occurred: %@", error);
        }
    }];
    return list;
}

- (NSString *) downloadDriveFile:(GTLDriveFile *)file
{
    //Get Download Path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *viewPath = [docDir stringByAppendingPathComponent:file.title];
    
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
