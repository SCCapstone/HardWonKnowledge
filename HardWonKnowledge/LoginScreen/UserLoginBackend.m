//
//  UserLoginBackend.m
//  StemNotebook
//
//  Created by Keneequa Brown on 3/5/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "UserLoginBackend.h"

@implementation UserLoginBackend

@synthesize adminCredentials;
@synthesize userCredentials;
@synthesize dataSrc;
@synthesize srchedData;
@synthesize tblData;
@synthesize sBar;
@synthesize myTableView;
@synthesize listFileId;
@synthesize userTxtPath;

- (void)addNewUser: (NSMutableDictionary*)dictionary array:(NSMutableArray*)array {
    for(int i=0; i<[array count]; i++){
        if(i<=1)
            [array setObject:[[array objectAtIndex:i] lowercaseString] atIndexedSubscript:i];
        else
            [array setObject:[[array objectAtIndex:i] capitalizedString] atIndexedSubscript:i];
    }
    [dictionary setObject:array forKey:[array objectAtIndex:0]];
}

- (void)findBundleData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"txt"];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *rows = [contents componentsSeparatedByString:@"\n"];
    
    for(NSString *row in rows)
        [self parseText:row file:0];
}

/*  Find the user credential files to parse  */
- (void)findDriveData{
    self.driveManager = [DriveManager getDriveManager];
    NSString *search = @"title contains 'NOTEBOOK_USERS_LIST'";
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            GTLDriveFile *file = [files.items objectAtIndex:0];
            NSString *contents = [NSString stringWithContentsOfFile:userTxtPath encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"File ID: %@",  file.identifier);
            if(file.identifier != nil)
                listFileId = file.identifier;
            
            if(contents==nil){
                NSLog(@"No File in Drive");
                [self saveOnDisk:@"new file XX XX" clearFile:YES];
                [self uploadListFile:YES];
                [self findDriveData];
            }
            else{
                NSLog(@"File in Drive");
                if(listFileId == nil)
                    [self findDriveData];
                
                [self.driveManager downloadDriveFile:file];
                NSArray *rows = [contents componentsSeparatedByString:@"\n"];
                for (NSString *row in rows)
                    [self parseText:row file:1];
            }
            
        } else
            NSLog (@"An Error has occurred: %@", error);
    }];
}

- (void)initVariables{
    userCredentials = [[NSMutableDictionary alloc] init];
    adminCredentials = [[NSMutableDictionary alloc] init];
    dataSrc = [[NSMutableArray alloc] init];
    listFileId = [[NSString alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    userTxtPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"users.txt"];
    NSLog(@"%@", userTxtPath);
    
}

/*  Search if administrator username is in keys  */
- (BOOL)isAdminUser: (NSString *) name{
    for (NSString *key in [adminCredentials allKeys]){
        //        NSLog(@"Compare: %@ %@", name, key);
        if ([name isEqualToString:key]){
            //            NSLog(@"Found: %@ %@", name, key);
            return true;}
    }
    return false;
}

/*  Search if student username is in keys  */
- (BOOL)isStudentUser: (NSString *) name{
    for (NSString *key in [userCredentials allKeys]){
        if ([name isEqualToString:key])
            return true;
    }
    return false;
}

/*  Parse the string given and add as user  */
- (void)parseText: (NSString *)text file:(NSInteger)fileType {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([text isEqualToString:@""] || [text isEqualToString:@"new file XX XX"])
        return;
    
    text = [text stringByAppendingString:@" % % %"];
    NSMutableArray *fields = [NSMutableArray arrayWithArray:[text componentsSeparatedByString:@" "]];
    if(fileType == 0)
        [adminCredentials setObject:fields forKey:[fields objectAtIndex:0]];
    else{
        if([fields containsObject:@"#*#"])
            [self addNewUser:adminCredentials array:[[NSMutableArray alloc]initWithArray:[fields subarrayWithRange:NSMakeRange(0, 5)]]];
        else
            [self addNewUser:userCredentials array:[[NSMutableArray alloc]initWithArray:[fields subarrayWithRange:NSMakeRange(0, 5)]]];
        [self setUpDataSrc: [fields subarrayWithRange:NSMakeRange(0, [fields count]-3)]];
    }
}

-(void)removeSelectedUser {
    // Update values and save new file without deleted user
    
    //    NSString *contents = [NSString stringWithContentsOfFile:userTxtPath encoding:NSUTF8StringEncoding error:nil];
    //    NSArray *rows = [contents componentsSeparatedByString:@"\n"];
    //    contents = @"";
    //    for (NSString *row in rows){
    //        if([[row stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""])
    //            break;
    //        NSArray *fields = [row componentsSeparatedByString:@" "];
    //        if([[srchedData objectAtIndex:0]isEqualToString:[fields objectAtIndex:0]])
    //            continue;
    //        contents = [contents stringByAppendingString:[[NSString alloc] initWithFormat:@"%@\n",row]];
    //    }
    //    [dataSrc removeAllObjects];
    //    [userCredentials removeAllObjects];
    //    [tblData removeAllObjects];
    //    [self saveOnDisk:contents clearFile:YES];
    //    [self uploadListFile:NO];
    //    rows = [contents componentsSeparatedByString:@"\n"];
    //    for(NSString *row in rows)
    //        [self parseText:row];
    //        [myTableView reloadData];
    
    //    for(id key in userCredentials){
    //        if([[userCredentials objectForKey:key]isEqual:[srchedData objectAtIndex:0]])
    //            continue;
    //        NSString *text = @"";
    //        for(NSString *field in [userCredentials objectForKey:key]){
    //            text = [text stringByAppendingFormat:@"%@ ",field];
    //        }
    //        [self parseText:text];
    //        [myTableView reloadData];
    //    }
    NSLog(@"REMOVE");
}

/*  Save added user to file on disk  */
- (void)saveUser: (NSString *)user{
    [self parseText:user file:1];
    [self saveOnDisk:user clearFile:NO];
    [self uploadListFile:NO];
}

/*  Save the file to disk before upload  */
- (void)saveOnDisk: (NSString *)text clearFile:(BOOL)clearFile{
    NSString *contents = [NSString stringWithContentsOfFile:userTxtPath encoding:NSUTF8StringEncoding error:nil];
    if(clearFile || [contents isEqualToString:@"new file XX XX"])
        text = [[NSString alloc]initWithFormat:@"%@", text];
    else
        text = [[NSString alloc]initWithFormat:@"%@\n%@", contents, text];
    
    [text writeToFile:userTxtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Saved to disk");
}

- (void)setUpDataSrc: (NSArray *)array{
    NSString *text = [[NSString alloc]initWithFormat:@"%@ -",[[array objectAtIndex:0] lowercaseString]];
    for(int i=2; i<[array count]; i++){
        text = [text stringByAppendingFormat:@" %@", [[array objectAtIndex:i]capitalizedString]];
    }
    NSLog(@"%@", text);
    [dataSrc addObject:text];
    
    //    if([last isEqualToString:@" "])
    //        [dataSrc addObject:[NSString stringWithFormat:@"%@ - %@ %@",user, first,last]];
    //    else
    //        [dataSrc addObject:[NSString stringWithFormat:@"%@ - %@ %@",last,first,user]];
}

/*  Upload file to Google Drive  */
- (void)uploadListFile: (BOOL)isNewFile{
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = @"NOTEBOOK_USERS_LIST.txt";
    file.descriptionProperty = @"Text file of STEM Notebook users.";
    file.mimeType = @"text/plain";
    
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:userTxtPath])
        data = [[NSFileManager defaultManager] contentsAtPath:userTxtPath];
    else
        NSLog(@"File does not exist");
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query;
    if(isNewFile)
        query = [GTLQueryDrive queryForFilesInsertWithObject:file uploadParameters:uploadParameters];
    else
        query = [GTLQueryDrive queryForFilesUpdateWithObject:file fileId:listFileId uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self.driveManager showWaitIndicator:@"Loading"];
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFile *insertedFile, NSError *error) {
        [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
        if (error == nil){
            NSLog(@"Google Drive: File Saved");
        }
        else
            NSLog(@"An error occurred: %@", error);
    }];
}

@end
