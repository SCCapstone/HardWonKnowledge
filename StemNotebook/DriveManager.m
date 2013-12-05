//
//  DriveManager.m
//  StemNotebook
//
//  Created by Colton Waters on 12/5/13.
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
