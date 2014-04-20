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
#import "NotebookViewController.h"
#import "PaintView.h"
#import "UserLoginViewController.h"

enum
{
    CellTypeFill,
    CellTypePlain,
    CellTypeOffset
};

@implementation BookshelfGridViewController

@synthesize gridView=_gridView;
@synthesize selectedFile;

#pragma mark -
#pragma mark Bookshelf View
- (void)loadViewForAdmin {
    bottomToolbar.items = [NSArray arrayWithObject:deleteButton];
    [self loadNotebooksForQuery:@"mimeType='application/octet-stream'"];
    [self loadLocalFilesForUser:@""];
}

- (void)loadViewForStudent {
    deleteButton.enabled = NO;
    NSString *search = [NSString stringWithFormat:@"mimeType='application/vnd.google-apps.folder' and title contains '%@'", [self.userManager username]];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            GTLDriveFile *file = [files.items objectAtIndex:0];
            if(file == nil)
                [self.driveManager createFolderUnderAppRootNamed:[NSString stringWithFormat:@"%@ - StemNotebooks",[self.userManager username]]];
            else{
                [self.userManager setFolderId:file.identifier];
            }
            [self loadNotebooksForQuery:[NSString stringWithFormat: @"'%@' in parents",self.userManager.folderId]];
            [self loadLocalFilesForUser:[self.userManager username]];
            //            NSLog(@"ID: %@",file.identifier);
        } else
            NSLog (@"An Error has occurred: %@", error);
    }];
}

- (IBAction)deleteNotebookView {
    NSLog(@"Delete 1");
    isDeleting = YES;
    deleteButton.action = @selector(deleteSelectedNotebook);
    deleteButton.tintColor = [UIColor darkTextColor];
    deleteButton.style = UIBarButtonItemStyleBordered;
    bottomToolbar.items = [NSArray arrayWithObjects:deleteButton, cancelButton, nil];
        
    for(int index=0; index<[_allNotebooks count]; index++)
        [self.gridView cellForItemAtIndex:index];
//    [self.gridView reloadData];
}

- (IBAction)deleteSelectedNotebook {
        NSLog(@"Delete 2");
//    for (NSNumber *number in _deletingNotebooks){
//        NSUInteger index = [number integerValue];
//        if(index <= [_driveTitles count]){
//            GTLDriveFile *file = [_driveFiles itemAtIndex:index-1];
//            [self.driveManager deleteNotebook:file];
//        }
//        else{
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//            
//            NSString *filePath = [documentsPath stringByAppendingPathComponent:[_localTitles objectAtIndex:index-[_driveTitles count]-1]];
//            NSError *error;
//            BOOL success = [fileManager removeItemAtPath:filePath error:&error];
//            if (!success) {
//                NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
//            }            
//        }
//    }
}

- (IBAction)cancelDeleteView {
    NSLog(@"Cancel");
    isDeleting = NO;
    deleteButton.action = @selector(deleteNotebookView);
    deleteButton.style = UIBarButtonItemStyleDone;
    deleteButton.tintColor = nil;
//    deleteButton = [deleteButton initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteNotebookView)];
    bottomToolbar.items = [NSArray arrayWithObject:deleteButton];
//    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.gridView.autoresizesSubviews = YES;
//    self.gridView.delegate = self;
//    self.gridView.dataSource = self;
//    [self.gridView reloadData];
}

#pragma mark -
#pragma mark Bookshelf Content
// Sign out of user account.
- (IBAction)closeBookshelf{
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)loadNotebooksForQuery: (NSString*)search{
    NSMutableArray *allFileNames = [[NSMutableArray alloc] init];
    UIAlertView *waitIndicator = [self.driveManager showWaitIndicator:@"Loading Notebooks..."];
    NSLog(@"Loading Notebooks...");
    
    // Find the existing files on Google Drive
    //    NSLog(@"%@ %@", [userManager username], [userManager folderId]);
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
        if (error == nil) {
            for (GTLDriveFile *file in files) {
                //                NSLog(@"Drive File: %@",file.title);
                [allFileNames addObject:[file.title substringToIndex:(file.title.length - 4)]];
            }
            _driveFiles = files;
            _driveTitles = allFileNames;
            [self.gridView reloadData];
        } else {
            NSLog (@"An Error has occurred: %@", error);
        }
    }];
}

-(void)loadLocalFilesForUser:(NSString*)username {
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:NULL];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for(NSString *item in directoryContent){
        if([[item substringFromIndex:[item length]-4]isEqualToString:@".nbf"] && [[item substringToIndex:[username length]]isEqualToString:username]){
            //            NSLog(@"Local File: %@",item);
            [temp addObject:item];
        }
    }
    _localTitles = temp;
}

#pragma mark -
#pragma mark Notebook
-(IBAction)newNotebookEntry{
    NotebookViewController *notebook = [[NotebookViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:notebook animated:NO completion:NULL];
}

- (IBAction)openNotebookForFile: (GTLDriveFile *) file{
    NotebookViewController *notebook = [[NotebookViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:notebook animated:NO completion:NULL];
    [notebook openNotebookFromFile:file];
}

- (IBAction)openNotebookForPath: (NSString *)path title:(NSString *)title{
    NotebookViewController *notebook = [[NotebookViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:notebook animated:NO completion:NULL];
    [notebook openNotebookFromPath:path title:title];
}

#pragma mark -
#pragma mark Original Methods
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    self.driveManager = [DriveManager getDriveManager];
    
    self.userManager = [ActiveUser userManager];
    _allNotebooks = [[NSMutableArray alloc]initWithObjects:@"init", nil];
    _deletingNotebooks = [[NSMutableArray alloc]init];
    nav.title = [NSString stringWithFormat:@"%@'s Notebooks",[self.userManager firstName]];
    isDeleting = NO;
    bottomToolbar.items = [[NSArray alloc]init];
}

// Override to allow orientations other than the default portrait orientation.
//- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
//{
//    return YES;
//}

- (void) viewDidUnload
{
    // Release any retained subviews of the main view.
    self.gridView = nil;
}

#pragma mark -
#pragma mark Grid View

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return ( [_localTitles count]+[_driveTitles count]+1 );
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * FilledCellIdentifier = @"FilledCellIdentifier";
    AQGridViewCell * cell = nil;
    BookshelfGridFilledCell * filledCell = (BookshelfGridFilledCell *)[aGridView dequeueReusableCellWithIdentifier: FilledCellIdentifier];
    if ( filledCell == nil )
    {
        filledCell = [[BookshelfGridFilledCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 300.0)
                                                    reuseIdentifier: FilledCellIdentifier];
        //                filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
        if(isDeleting){
            filledCell.selectionGlowColor = nil;
        }
        else{
            filledCell.selectionGlowColor = [UIColor blackColor];
        }
    }
    
    [_allNotebooks removeAllObjects];
    [_allNotebooks addObject:@"Create New"];
    [_allNotebooks addObjectsFromArray:_driveTitles];
    [_allNotebooks addObjectsFromArray:_localTitles];
    //    NSLog(@"index %i drive %d local %d combined %d",index, _driveTitles.count, _localTitles.count,_allNotebooks.count);
    
    if(index==0)
        filledCell.image = [UIImage imageNamed:@"blank_notebook.png"];
    else if(index<=[_driveTitles count])
        filledCell.image = [UIImage imageNamed:@"green_notebook.png"];
    else
        filledCell.image = [UIImage imageNamed:@"black_notebook.png"];
    
    filledCell.title = [_allNotebooks objectAtIndex:index];
    
    cell = filledCell;
    return ( cell );
    
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(175, 262.5) );
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
    if(index>[_allNotebooks count])
        return;
    if(isDeleting)
        [self selectNotebookToDeleteAtIndex:index];
    else
        [self selectNotebookToOpenAtIndex:index];
}

- (void)selectNotebookToOpenAtIndex:(NSUInteger)index{
    if(index == 0){
        [self newNotebookEntry];
        //        NSLog(@"selected create %d",index);
    }
    else if(index<=[_driveTitles count] && [_driveTitles count]!=0){
        //        NSLog(@"selected drive %d",index-1);
        GTLDriveFile *file = [_driveFiles itemAtIndex:index-1];
        [self openNotebookForFile:file];
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[_localTitles objectAtIndex:index-[_driveTitles count]-1]];
        [self openNotebookForPath:path title:[_localTitles objectAtIndex:index-[_driveTitles count]-1]];
        //        NSLog(@"selected local %d",index-[_driveTitles count]-1);
    }
}

- (void)selectNotebookToDeleteAtIndex:(NSUInteger)index{
    if(index == 0){
        return;
    }
    else {
        [self.gridView cellForItemAtIndex:index].selectionStyle = AQGridViewCellSelectionStyleBlueGray;
        [_deletingNotebooks addObject:[NSNumber numberWithInt:index]];
    }
}

// nothing here yet

@end
