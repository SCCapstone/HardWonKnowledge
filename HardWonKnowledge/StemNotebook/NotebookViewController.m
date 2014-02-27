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





//Called when the view loads
- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.sideBarView.delegate = self;
    
    [self.SubmenuView addSubview:self.typeSubmenu];
    [self.paintSubmenu setHidden:TRUE];
    [self.menuSubmenu setHidden:TRUE];
    [self.typeSubmenu setHidden:FALSE];
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
    [self.typeSubmenu setHidden:TRUE];
    [self.view endEditing:YES];
    
}

- (void)showMenuSubmenu
{
    [self.SubmenuView addSubview:self.menuSubmenu];
    [self.menuSubmenu setHidden:FALSE];
    [self.paintSubmenu setHidden:TRUE];
    [self.typeSubmenu setHidden:TRUE];
    [self.view endEditing:YES];
}

- (void)showTypeSubmenu
{
    [self.SubmenuView addSubview:self.typeSubmenu];
    [self.menuSubmenu setHidden: TRUE];
    [self.paintSubmenu setHidden: TRUE];
    [self.typeSubmenu setHidden:FALSE];
        
}

- (void)changeBrushWithNumber:(float)number
{
    [self.paintView changeBrushWithNumber:number];
}

- (void)nextPage
{
    [self.paintView nextPage];
}

-(void)previousPage
{
    [self.paintView previousPage];
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

- (void)sendNotesPressed
{
    
    [self.paintView sendNotesPressed];

}








@end
