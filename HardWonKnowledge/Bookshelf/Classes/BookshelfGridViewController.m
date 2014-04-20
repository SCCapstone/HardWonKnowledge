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
@synthesize srchedData;
@synthesize tblData;
@synthesize sBar;
@synthesize myTableView;

#pragma mark -
#pragma mark Different Views of the Bookshelf
- (void)loadViewForAdmin {
    bottomToolbar.items = [NSArray arrayWithObject:deleteButton];
    NSString *search = [NSString stringWithFormat:@"mimeType='application/vnd.google-apps.folder' and title contains '%@' and trashed = false", [self.userManager username]];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            GTLDriveFile *file = [files.items objectAtIndex:0];
            if(file == nil){
                [self.driveManager createFolderUnderAppRootNamed:[NSString stringWithFormat:@"%@ - StemNotebooks",[self.userManager username]]];
            }
            else{
                [self.userManager setFolderId:file.identifier];
                [self loadNotebooksForQuery:@"mimeType='application/octet-stream' and trashed = false"];
            }
            [self loadLocalFilesForUser:@""];
            [self.gridView reloadData];
        } else
            NSLog (@"An Error has occurred: %@", error);
    }];
}

- (void)loadViewForStudent {
    NSString *search = [NSString stringWithFormat:@"mimeType='application/vnd.google-apps.folder' and title contains '%@' and trashed = false", [self.userManager username]];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            GTLDriveFile *file = [files.items objectAtIndex:0];
            if(file == nil){
                [self.driveManager createFolderUnderAppRootNamed:[NSString stringWithFormat:@"%@ - StemNotebooks",[self.userManager username]]];
            }
            else{
                [self.userManager setFolderId:file.identifier];
                [self loadNotebooksForQuery:[NSString stringWithFormat: @"mimeType='application/octet-stream' and '%@' in parents",self.userManager.folderId]];
            }
            [self loadLocalFilesForUser:[self.userManager username]];
            [self.gridView reloadData];
            //            NSLog(@"ID: %@",file.identifier);
        } else
            NSLog (@"An Error has occurred: %@", error);
    }];
}

- (IBAction)openDeleteNotebookView {
    UIViewController *deleteView = [[UIViewController alloc]initWithNibName:nil bundle:nil];
    deleteView.modalPresentationStyle = UIModalPresentationFormSheet;
    deleteView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    deleteView.view.backgroundColor= [UIColor whiteColor];
    deleteView.view.superview.center = self.view.center;
    UINavigationBar *deleteNav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0) ];
    [deleteView.view addSubview:deleteNav];
    [self presentViewController:deleteView animated:YES completion:NULL];
    [self tableOfNotebooksInView:deleteView];
}

- (void)tableOfNotebooksInView:(UIViewController*)deleteView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, deleteView.view.frame.size.width, 50)];
    label.text = @"Delete Notebook";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:28];
    [deleteView.view addSubview:label];
    sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,150,deleteView.view.frame.size.width,50.0)];
    sBar.delegate = self;
    [deleteView.view addSubview:sBar];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, deleteView.view.frame.size.width, 300)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [deleteView.view addSubview:myTableView];
    
    srchedData = [[NSMutableArray alloc]init];
    tblData = [[NSMutableArray alloc]init];
    [tblData addObjectsFromArray:_driveTitles];
    [tblData addObjectsFromArray:_localTitles];
    [myTableView reloadData];
    [srchedData addObject:@"nil"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 550, 150, 50);
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(promptRemoveNotebook) forControlEvents:UIControlEventTouchUpInside];
    [deleteView.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Close" forState:UIControlStateNormal];
    button2.frame = CGRectMake(deleteView.view.frame.size.width-200, 550, 150, 50);
    button2.titleLabel.font = [UIFont systemFontOfSize:18];
    [button2 addTarget:self action:@selector(closeDeleteView) forControlEvents:UIControlEventTouchUpInside];
    [deleteView.view addSubview:button2];
    
}

- (void)promptRemoveNotebook {
    if([[srchedData objectAtIndex:0]isEqualToString:@"nil"]){
        return;
    }
    NSUInteger index = [[srchedData objectAtIndex:0] integerValue];
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"Delete Notebook";
    alert.message = [NSString stringWithFormat:@"Are you sure you wish to delete %@?", [tblData objectAtIndex:index]];
    [alert addButtonWithTitle:@"Delete"];
    [alert addButtonWithTitle:@"Dismiss"];
    [alert show];
}

- (void)removeNotebook {
    NSUInteger index = [[srchedData objectAtIndex:0] integerValue];
    if(index < [_driveTitles count]){
        GTLDriveFile *file = [_driveFiles itemAtIndex:index];
        [self.driveManager deleteNotebook:file];
    }
    else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[_localTitles objectAtIndex:index-[_driveTitles count]]];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success) {
            NSLog(@"Could not delete file: %@ ",[error localizedDescription]);
        }
    }
    
    [tblData removeObjectAtIndex:index];
    [myTableView reloadData];
}

- (IBAction)closeDeleteView {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
    if([self.userManager isAdmin]){
        [self loadViewForAdmin];
    }else{
        [self loadViewForStudent];
    }
}

#pragma mark -
#pragma mark Methods for Retrieving Bookshelf Content
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
//            [self.gridView reloadData];
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
#pragma mark Bookshelf to Notebook Methods
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
#pragma mark Initialization and Deallocation Methods
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
    _allNotebooks = [[NSMutableArray alloc]initWithObjects:@"Create New", nil];
//    NSLog(@"%i %i %i", [_localTitles count], [_driveTitles count], [_allNotebooks count]);
    nav.title = [NSString stringWithFormat:@"%@'s Notebooks",[self.userManager firstName]];
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
#pragma mark AlertView Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonPressedName isEqualToString:@"Delete"]){
        [self removeNotebook];
    }
    else if ([buttonPressedName isEqualToString:@"Dismiss"]){
        return;
    }
}

#pragma mark -
#pragma mark Bookshelf GridView Methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return ( [_localTitles count]+[_driveTitles count]+1 );
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * FilledCellIdentifier = @"FilledCellIdentifier";
    AQGridViewCell * cell = nil;
    BookshelfGridFilledCell * filledCell = (BookshelfGridFilledCell *)[aGridView dequeueReusableCellWithIdentifier: FilledCellIdentifier];
    NSLog(@"GRRRR");
    if ( filledCell == nil )
    {
        filledCell = [[BookshelfGridFilledCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 300.0)
                                                    reuseIdentifier: FilledCellIdentifier];
        //                        filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
        filledCell.selectionGlowColor = [UIColor blackColor];
    }
    
    [_allNotebooks removeAllObjects];
    [_allNotebooks addObject:@"Create New"];
    [_allNotebooks addObjectsFromArray:_driveTitles];
    [_allNotebooks addObjectsFromArray:_localTitles];
    NSLog(@"index %i drive %d local %d combined %d",index, _driveTitles.count, _localTitles.count,_allNotebooks.count);
    
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
    if(index == 0){
        [self newNotebookEntry];
    }
    else if(index<=[_driveTitles count] && [_driveTitles count]!=0){
        GTLDriveFile *file = [_driveFiles itemAtIndex:index-1];
        [self openNotebookForFile:file];
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[_localTitles objectAtIndex:index-[_driveTitles count]-1]];
        [self openNotebookForPath:path title:[_localTitles objectAtIndex:index-[_driveTitles count]-1]];
    }
    
}

#pragma mark -
#pragma mark TableView and SearchBar Methods for Deletion

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"contacts error in num of row");
    return [tblData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.textLabel.text = [tblData objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = (indexPath.row%2)
    ? [UIColor lightGrayColor] : [UIColor whiteColor];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // only show the status bar's cancel button while in edit mode
    sBar.showsCancelButton = YES;
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [tblData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    sBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [tblData removeAllObjects];// remove all data that belongs to previous search
    if([searchText isEqualToString:@""]||searchText==nil){
        [myTableView reloadData];
        return;
    }
    NSInteger counter = 0;
    for(NSString *name in _allNotebooks){
        NSRange r = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
        if(r.location != NSNotFound)
            [tblData addObject:name];
        counter++;
    }
    [myTableView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [tblData removeAllObjects];
    [tblData addObjectsFromArray:_allNotebooks];
    @try{
        [myTableView reloadData];
    }
    @catch(NSException *e){
    }
    [sBar resignFirstResponder];
    sBar.text = @"";
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    sBar.text = cell.textLabel.text;
    [srchedData setObject:[NSString stringWithFormat:@"%i",indexPath.row] atIndexedSubscript:0];
}

// nothing here yet

@end
