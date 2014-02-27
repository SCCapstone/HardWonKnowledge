/*
 * BookshelfGridViewController.m
 * Modified by Keneequa Brown on Feb. 5, 2014
 *
 *
 * Modified from ImageDemoViewController.m
 * Classes
 *
 * Created by Jim Dovey on 17/4/2010.
 *
 * Copyright (c) 2010 Jim Dovey
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "BookshelfGridViewController.h"
#import "BookshelfGridViewCell.h"
#import "BookshelfGridFilledCell.h"
#import "../../StemNotebook/NotebookViewController.h"
#import "UserLoginViewController.h"

enum
{
    CellTypeFill,
    CellTypePlain,
    CellTypeOffset
};

@implementation BookshelfGridViewController

@synthesize gridView=_gridView;

// Sign out of user account.
- (IBAction)logoutAccount{
    UserLoginViewController *login = [[UserLoginViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:login animated:YES completion:NULL];
}

-(IBAction)notebookEntry{
    NotebookViewController *notebook = [[NotebookViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:notebook animated:NO completion:NULL];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Title"];
    
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    self.driveManager = [DriveManager getDriveManager];

    if ( _orderedFileNames != nil)
        return;

    NSMutableArray *allFileNames = [[NSMutableArray alloc] init];
    UIAlertView *waitIndicator = [self.driveManager showWaitIndicator:@"Loading Notebooks..."];
    NSLog(@"Loading Notebooks...");
    
    // Find the existing files on Google Drive
    NSString *search = @"title contains 'Stem Notebook Upload'";
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
        if (error == nil) {
            for (GTLDriveFile *file in files) {
                NSLog(@"Drive File: %@",file.title);
                [allFileNames addObject:file.title];
            }
            _allFiles = files;
            // _orderedFileNames = [[allFileNames sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] copy];
            _fileNames = [[allFileNames sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] copy];
            // _fileNames = [_orderedFileNames copy];
            
            [self.gridView reloadData];
        } else {
            NSLog (@"An Error has occurred: %@", error);
        }
    }];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}

- (void) viewDidUnload
{
    // Release any retained subviews of the main view.
    self.gridView = nil;
}

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return ( [_fileNames count] );
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    //Display notebooks in grid
    static NSString * FilledCellIdentifier = @"FilledCellIdentifier";
    AQGridViewCell * cell = nil;
    BookshelfGridFilledCell * filledCell = (BookshelfGridFilledCell *)[aGridView dequeueReusableCellWithIdentifier: FilledCellIdentifier];
    if ( filledCell == nil )
    {
        filledCell = [[BookshelfGridFilledCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 300.0)
                                                    reuseIdentifier: FilledCellIdentifier];
        //                filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
        filledCell.selectionGlowColor = [UIColor blackColor];
    }
    
    if(index%2==0){
        filledCell.image = [UIImage imageNamed:@"Green.png"];
    } else{
        filledCell.image = [UIImage imageNamed:@"Black.png"];
    }
    filledCell.title = [_fileNames objectAtIndex: index];
    
    cell = filledCell;
    return ( cell );
    
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(230.0, 345.0) );
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
    GTLDriveFile *file = [_allFiles itemAtIndex:index];
        NSLog(@"File %i selected: %@",index,file.title);
    self.driveManager = [DriveManager getDriveManager];
    NSString *viewPath = [self.driveManager downloadDriveFile:file];
    
//    NotebookViewController *notebook = [[NotebookViewController alloc] initWithNibName:nil bundle:nil];
//    GTLDriveFile *file = [_allFiles itemAtIndex:index];
//    [[notebook paintView] loadNotebook:file ];
//    [self presentViewController:notebook animated:NO completion:NULL];
//    NSString *viewPath = file.downloadUrl;
//    NSString *viewPath = [self.driveManager downloadDriveFile:file];
//    NSLog(@"Item %i was selected: %@ %@",index,file.title,viewPath);
//    
//    //get data from file
//    NSData *codedData = [[NSData alloc] initWithContentsOfFile:viewPath];
//    if (codedData == nil) return;

    //unarchive data
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
//
//    //get images from archive
//    for (int i = 0; i<25; i++) {
//        UIImage *newImage = (UIImage*)[unarchiver decodeObjectForKey:[@"image-" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
//        //NSLog([@"image-" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]);
//        UIImageView *v = [notebook.paintView.pages objectAtIndex:i];
//        v.image = newImage;
//    }
//    NSLog(@"SELECTED %i", 4);
//    [unarchiver finishDecoding];
//    
//    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:file.title message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
//    
////    UIImageView *imageView = (UIImage *)[unarchiver decodeObjectForKey:@"image-"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];
////    viewPath = file.downloadUrl;
//    NSString *path = viewPath;
//    NSLog(@"PAAATH: %@",viewPath);
//    UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
//    [imageView setImage:bkgImg];
//    
//    [successAlert addSubview:imageView];
//    
//    [successAlert show];
//        [self presentViewController:notebook animated:NO completion:NULL];
}

#pragma mark -
#pragma mark Grid View Delegate

// nothing here yet

@end
