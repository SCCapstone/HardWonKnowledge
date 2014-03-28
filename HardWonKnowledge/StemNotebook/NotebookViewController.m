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

- (void) openNotebookNamed:(NSString *)name {
    [self.paintView loadFileNamed:name];
}

- (void) saveFileNamed:(NSString *)name {
    [self.paintView saveFileNamed:name];
    [self.driveManager uploadNotebookNamed:name];
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
    [bookshelf loadNotebookFiles];
    [self dismissViewControllerAnimated:NO completion:NULL];
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
    //picker.allowsEditing = YES;
    //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIPopoverController *popOver = [[UIPopoverController alloc]initWithContentViewController:picker];
    self.popoverImageViewController = popOver;
    [self.popoverImageViewController presentPopoverFromRect:CGRectMake(450.0f, 825.0f, 10.0f, 10.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    //[self presentViewController:picker animated:YES completion:NULL];

}

//-(void) importButtonClicked
//{
//    NSLog(@"WORKING");
//}

- (void)cameraButtonClicked
{
    NSLog(@" Did it go to notebookviewcontol");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)videoButtonClicked
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}


- (void)testButtonClicked
{
    NSLog(@"TEST SENT TO DELEGATE");
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

- (void)nextPage
{
    [self.paintView nextPage];
}

-(void)previousPage
{
    [self.paintView previousPage];
}






@end
