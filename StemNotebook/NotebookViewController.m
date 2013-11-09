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

//Called when the view loads
- (void)viewDidLoad
{    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.SubmenuView addSubview:self.paintSubmenu];
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

- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen
{
    [self.paintView changeColorWithRed:newRed Blue:newBlue Green:newGreen];
    NSLog(@"Change Color Called");
}



@end
