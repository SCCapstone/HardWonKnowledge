//
//  ViewController.m
//  StemNotebook
//
//  Created by Colton Waters on 10/27/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "NotebookViewController.h"

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
        CGRect paintSubmenuFrame = CGRectMake(0, 0, self.SubmenuView.bounds.size.width, self.view.bounds.size.height);
        self.menuSubmenu = [[MenuSubmenuView alloc] initWithFrame:paintSubmenuFrame];
        self.menuSubmenu.delegate = self;
    }
    return menuSubmenu;
}

- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen
{
    [self.paintView changeColorWithRed:newRed Blue:newBlue Green:newGreen];
    NSLog(@"Change Color Called");
}

- (void)showPaintSubmenu
{
    [self.SubmenuView addSubview:self.paintSubmenu];

}

- (void)showMenuSubmenu
{
    [self.SubmenuView addSubview:self.menuSubmenu];
}

- (void)encodePaintView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *viewPath = [docDir stringByAppendingPathComponent:@"Notebook1.nbf"];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.paintView forKey:@"paintView"];
    [archiver finishEncoding];
    if (![data writeToFile:viewPath atomically:YES])
        NSLog(@"BAD");

}

@end
