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
@synthesize typeSubmenu;
@synthesize sideBarView;
@synthesize cameraSubmenu;
@synthesize notebookDriveFile;
@synthesize userManager;



//Called when the view loads
- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.sideBarView.delegate = self;
    [self.SubmenuView addSubview:self.paintSubmenu];
    [self.paintSubmenu setHidden:FALSE];
    [self.menuSubmenu setHidden:TRUE];
    [self.typeSubmenu setHidden:TRUE];
    [self.cameraSubmenu setHidden:TRUE];
    [self.paintView changeMode:paintMode];
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientID
                                                                                     clientSecret:kClientSecret];
    self.driveManager = [DriveManager getDriveManager];
    self.userManager = [ActiveUser userManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    paintSubmenu = nil;
}


#pragma mark -
#pragma mark Submenu Delegate Button Methods
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

- (TypeSubmenuView *)typeSubmenu
{
    if (!typeSubmenu) {
        CGRect typeSubmenuFrame = CGRectMake(0, 0, self.SubmenuView.bounds.size.width, self.view.bounds.size.height);
        self.typeSubmenu = [[TypeSubmenuView alloc] initWithFrame:typeSubmenuFrame];
        self.typeSubmenu.delegate = self;
    }
    return typeSubmenu;
}

- (CameraSubmenuView *)cameraSubmenu
{
    if (!cameraSubmenu) {
        CGRect cameraSubmenuFrame = CGRectMake(0, 0, self.SubmenuView.bounds.size.width, self.view.bounds.size.height);
        self.cameraSubmenu = [[CameraSubmenuView alloc] initWithFrame:cameraSubmenuFrame];
        self.cameraSubmenu.delegate = self;
    }
    return cameraSubmenu;
}


#pragma mark -
#pragma mark Paint View Control Methods
//Methods used for PaintView
- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen Alpha:(float)newAlpha
{
    [self.paintView changeColorWithRed:newRed Blue:newBlue Green:newGreen Alpha:newAlpha];
    NSLog(@"Change Color Called");
}

- (void)changeText:(NSString *)text
{
    [self.paintView changeText:text];
}

- (void)changeMode:(int)newMode
{
    [self.paintView changeMode:newMode];
}

- (void)changeAlphaWithNumber:(float)newAlpha
{
    [self.paintView changeAlphaWithNumber:newAlpha];
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

#pragma mark paint view file methods
- (void) openNotebookFromFile:(GTLDriveFile *)file {
    self.notebookDriveFile = file;
    //Get Download Path
    NSString *viewPath = [self.driveManager.documentPath stringByAppendingPathComponent:file.title];

    //Setup HTTP Fetcher
    GTMHTTPFetcher *fetcher = [self.driveService.fetcherService fetcherWithURLString:file.downloadUrl];
    fetcher.downloadPath = viewPath;

    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error == nil) {
            //Saved file to disk
            NSLog(@"Retrieved file content");
            [self.paintView loadFileNamed:file.title atPath:viewPath];

        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];

}

- (void) openNotebookFromPath:(NSString *)path title:(NSString *)title {
    [self.paintView loadFileNamed:title atPath:path];
}

- (void) saveFileNamed:(NSString *)name {
    GTLDriveFile *f = [[GTLDriveFile alloc]init];
    f.identifier = userManager.folderId;
    [self.paintView saveFileNamed:name];
    [self.driveManager uploadNotebookNamed:name withParent:f];
}


//Methods Used in Menu SubMenu
-(void)uploadButtonClicked
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *viewPath = [docDir stringByAppendingPathComponent:@"Notebook2.nbf"];
    
    
    [self.driveManager uploadNotebook:viewPath];
}

- (void)loginButtonClicked
{
    [self.driveManager loginFromViewController:self];
}

- (void)logoutButtonClicked
{
    [self.driveManager logout];
}

- (void)backButtonClicked
{
    BookshelfGridViewController *bookshelf = (BookshelfGridViewController*)self.presentingViewController;
    
    [self dismissViewControllerAnimated:NO completion:NULL];
    if([userManager isAdmin]){
        [bookshelf loadViewForAdmin];
    }else{
        [bookshelf loadViewForStudent];
    }
}


//Methods used for Type Submenu
- (void)textMerged
{
    [self.paintView textMerged];
}

//Methods used for Camera Submenu
- (void)importButtonClicked
{
    NSLog(@" Did it go to notebookviewcontol");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIPopoverController *popOver = [[UIPopoverController alloc]initWithContentViewController:picker];
    self.popoverImageViewController = popOver;
    [self.popoverImageViewController presentPopoverFromRect:CGRectMake(384.0f, 704.0f, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    //[self presentViewController:picker animated:YES completion:NULL];

}

- (void)cameraButtonClicked
{
    NSLog(@" Did it go to notebookviewcontol");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    UIPopoverController *popOver = [[UIPopoverController alloc]initWithContentViewController:picker];
    self.popoverImageViewController = popOver;
    [self.popoverImageViewController presentPopoverFromRect:CGRectMake(384.0f, 704.0f, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    //[self presentViewController:picker animated:YES completion:NULL];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    [self.cameraSubmenu changeDisplayImage:pickedImage];
    [self.paintView changeImage:pickedImage];
}


//Methods used for Side Bar Menu
- (void)showPaintSubmenu
{
    [self.SubmenuView addSubview:self.paintSubmenu];
    [self.paintSubmenu setHidden:FALSE];
    [self.menuSubmenu setHidden:TRUE];
    [self.typeSubmenu setHidden:TRUE];
    [self.view endEditing:YES];
    [self.cameraSubmenu setHidden:TRUE];
    //[self.paintView changeAlphaWithNumber:1.0];
    [self.paintView changeMode:paintMode];
    
}

- (void)showMenuSubmenu
{
    [self.SubmenuView addSubview:self.menuSubmenu];
    [self.menuSubmenu setHidden:FALSE];
    [self.paintSubmenu setHidden:TRUE];
    [self.typeSubmenu setHidden:TRUE];
    [self.view endEditing:YES];
    [self.cameraSubmenu setHidden:TRUE];
    [self.paintView changeMode:menuMode];
}
- (void)showTypeSubmenu
{
    [self.SubmenuView addSubview:self.typeSubmenu];
    [self.menuSubmenu setHidden: TRUE];
    [self.paintSubmenu setHidden: TRUE];
    [self.typeSubmenu setHidden:FALSE];
    [self.cameraSubmenu setHidden:TRUE];
    [self.view endEditing:YES];
    [self.paintView changeMode:textMode];
        
}
- (void)showCameraSubmenu
{
    [self.SubmenuView addSubview:self.cameraSubmenu];
    [self.menuSubmenu setHidden: TRUE];
    [self.paintSubmenu setHidden: TRUE];
    [self.typeSubmenu setHidden:TRUE];
    [self.cameraSubmenu setHidden:FALSE];    
    [self.view endEditing:YES];
    [self.paintView changeMode:cameraMode];
}

- (void)doneButtonPressed
{
    if (self.notebookDriveFile.title == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Notebook Name" message:@"What is the name of this notebook?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay",nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else {
        [self.paintView saveFileNamed:self.notebookDriveFile.title];
//        [self.driveManager updateNotebook:self.notebookDriveFile fromFileNamed:self.notebookDriveFile.title];
        //setup path for file
        NSString *filepath = [self.driveManager.documentPath stringByAppendingPathComponent:self.notebookDriveFile.title];

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

        GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:self.notebookDriveFile.mimeType];
        GTLQueryDrive *query = [GTLQueryDrive queryForFilesUpdateWithObject:self.notebookDriveFile
                                                                     fileId:self.notebookDriveFile.identifier
                                                           uploadParameters:uploadParameters];

        UIAlertView *waitIndicator = [self.driveManager showWaitIndicator:@"Uploading to Google Drive"];
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
                              NSError *error = nil;
                              [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
                          }
                          else
                          {
                              NSLog(@"An error occurred: %@", error);
                              //[self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                              NSLog(@"An Error Occured");
                          }
                          [self backButtonClicked];
                      }];
//        [self backButtonClicked];
    }
}

- (void)nextPage
{
    [self.paintView nextPage];
    NSString *newString = [NSString stringWithFormat:@"%d",self.paintView.current+1];
    [self.sideBarView changePageNumber:newString];
}

-(void)previousPage
{
    [self.paintView previousPage];
    NSString *newString = [NSString stringWithFormat:@"%d",self.paintView.current+1];
    [self.sideBarView changePageNumber:newString];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *textField = [alertView textFieldAtIndex:0];
    if ([textField.text length] <= 0 || buttonIndex == 0){
        return; //If cancel or 0 length string the string doesn't matter
    }
    if (buttonIndex == 1) {
        GTLDriveFile *f = [[GTLDriveFile alloc]init];
        f.identifier = userManager.folderId;
        NSString *fileName;
        fileName = [textField.text stringByAppendingString:@".nbf"];
        [self.paintView saveFileNamed:fileName];
//        [self.driveManager uploadNotebookNamed:fileName withParent:f];
        //setup path for file
        NSString *filepath = [self.driveManager.documentPath stringByAppendingPathComponent:fileName];

        NSString *parentID = f.identifier;
        GTLDriveParentReference *parent = [GTLDriveParentReference object];
        parent.identifier = parentID;

        GTLDriveFile *file = [GTLDriveFile object];
        file.title = fileName;
        file.descriptionProperty = @"Uploaded from StemNotebook App";
        file.mimeType = @"application/octet-stream";
        file.parents=@[parent];

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

        UIAlertView *waitIndicator = [self.driveManager showWaitIndicator:@"Uploading to Google Drive"];
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
                              NSError *error = nil;
                              [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];

                          }
                          else
                          {
                              NSLog(@"An error occurred: %@", error);
                              //[self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                              NSLog(@"An Error Occured");
                          }
                          [self backButtonClicked];
                      }];

//        [self backButtonClicked];
    }
}




@end
