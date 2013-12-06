//
//  ViewController.m
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 10/27/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "NotebookViewController.h"

static NSString *const kKeychainItemName = @"Stem Notebook";
static NSString *const kClientID = @"279186473369-fq4ejbk5ovj6kdt68e039q8571ip5oqu.apps.googleusercontent.com";
static NSString *const kClientSecret = @"nZP3QMG9DIfcnHvpnOnnXrdY";

@interface NotebookViewController ()

@end

@implementation NotebookViewController

//Synthesize getters and setters for all views
@synthesize SubmenuView;
@synthesize paintSubmenu;
@synthesize menuSubmenu;

//Called when the view loads
- (void)viewDidLoad
{    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.sideBarView.delegate = self;
    [self.SubmenuView addSubview:self.paintSubmenu];
    [self.paintSubmenu setHidden:FALSE];
    [self.menuSubmenu setHidden:TRUE];
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientID
                                                                                     clientSecret:kClientSecret];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    paintSubmenu = nil;
}

//Delegate method called when paint button is pressed.
//Should later be deleted and replaced with real methods
-(void)PaintViewButtonPressed
{
    NSLog(@"Delegate Method Called");
}

//Overloaded getter to lazy load paintSubmenu\
//That is, only create menu when accessed and not initialized
- (PaintSubmenuView *)paintSubmenu
{
    if (!paintSubmenu) {
        CGRect paintSubmenuFrame = CGRectMake(0, 0, self.SubmenuView.bounds.size.width, self.view.bounds.size.height);
        self.paintSubmenu = [[PaintSubmenuView alloc] initWithFrame:paintSubmenuFrame];
        self.paintSubmenu.delegate = self;
    }
    return paintSubmenu;
}

- (MenuSubmenuView *)menuSubmenu
{
    if (!menuSubmenu) {
        CGRect menuSubmenuFrame = CGRectMake(0, 0, self.SubmenuView.bounds.size.width, self.view.bounds.size.height);
        self.menuSubmenu = [[MenuSubmenuView alloc] initWithFrame:menuSubmenuFrame];
        self.menuSubmenu.delegate = self;
    }
    return menuSubmenu;
}

- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen Alpha:(float)newAlpha
{
    [self.paintView changeColorWithRed:newRed Blue:newBlue Green:newGreen Alpha:newAlpha];
    NSLog(@"Change Color Called");
}

- (void)showPaintSubmenu
{
    [self.SubmenuView addSubview:self.paintSubmenu];
    [self.paintSubmenu setHidden:FALSE];
    [self.menuSubmenu setHidden:TRUE];
}

- (void)showMenuSubmenu
{
    [self.SubmenuView addSubview:self.menuSubmenu];
    [self.menuSubmenu setHidden:FALSE];
    [self.paintSubmenu setHidden:TRUE];
}

- (void)changeBrushWithNumber:(float)number
{
    [self.paintView changeBrushWithNumber:number];
}

-(void)encodePaintView
{
    [self.paintView saveImageView];
}

-(void)decodePaintView
{
    [self.paintView loadImageView];
}

-(void)uploadButtonClicked
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *viewPath = [docDir stringByAppendingPathComponent:@"Notebook2.nbf"];
    
    
    [self uploadNotebook:viewPath];
}

- (void)loginButtonClicked
{
    if (![self isAuthorized])
    {
        // Sign in.
        
        
        
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController =
        [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                   clientID:kClientID
                                               clientSecret:kClientSecret
                                           keychainItemName:kKeychainItemName
                                                   delegate:self
                                           finishedSelector:finishedSelector];
        [self presentModalViewController:authViewController
                                animated:YES];
    } else {
        [self showAlert:@"Logged In" message:@"You are already logged in."];
    }

}

- (void)logoutButtonClicked
{
    if ([self isAuthorized])
    {
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
        [[self driveService] setAuthorizer:nil];
        [self showAlert:@"Log Out" message:@"You have been logged out."];
    } else {
        [self showAlert:@"Not Logged In" message:@"You are currently  not logged in."];

    }
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

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
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


@end
