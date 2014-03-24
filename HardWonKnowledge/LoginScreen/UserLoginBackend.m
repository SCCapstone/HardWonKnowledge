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
@synthesize listFileId;
@synthesize userTxtPath;

- (void)addNewUser: (NSMutableDictionary*)dictionary array:(NSMutableArray*)array {
    for(int i=0; i<[array count]; i++){
        NSString *text = [array objectAtIndex:i];
        if(i==0)
            text = [text lowercaseString];
        else if(i>1)
            text = [text capitalizedString];
        
        [array setObject:text atIndexedSubscript:i];
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
            if(file.identifier != nil){
                listFileId = file.identifier;
                [self.driveManager downloadDriveFile:file];
            }
            
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
                
                //                [self.driveManager downloadDriveFile:file];
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
    userTxtPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"NOTEBOOK_USERS_LIST.txt"];
    NSLog(@"%@", userTxtPath);
    
}

/*  Search if administrator username is in keys  */
- (BOOL)isAdminUser: (NSString *) name{
    for (NSString *key in [adminCredentials allKeys]){
        //        NSLog(@"Compare: %@ %@", name, key);
        if ([name isEqualToString:key] && [adminCredentials objectForKey:name] != nil){
            //            NSLog(@"Found: %@ %@", name, key);
            return true;}
    }
    return false;
}

/*  Search if student username is in keys  */
- (BOOL)isStudentUser: (NSString *) name{
    for (NSString *key in [userCredentials allKeys]){
        if ([name isEqualToString:key] && [userCredentials objectForKey:name] != nil)
            return true;
    }
    return false;
}

/*  Parse the string given and add as user  */
- (void)parseText: (NSString *)text file:(NSInteger)fileType {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([text isEqualToString:@""] || [text isEqualToString:@"new file XX XX"])
        return;
    
    text = [text stringByAppendingString:@" (empty) (empty) (empty)"];
    NSMutableArray *fields = [NSMutableArray arrayWithArray:[text componentsSeparatedByString:@" "]];
    if([self isAdminUser:[fields objectAtIndex:0]] || [self isStudentUser:[fields objectAtIndex:0]]){
        NSLog(@"The username %@ was repeated.", [fields objectAtIndex:0]);
        return;
    }
    
    if([fields containsObject:@"#*#"])
        [self addNewUser:adminCredentials array:[[NSMutableArray alloc]initWithArray:[fields subarrayWithRange:NSMakeRange(0, 6)]]];
    else
        [self addNewUser:userCredentials array:[[NSMutableArray alloc]initWithArray:[fields subarrayWithRange:NSMakeRange(0, 5)]]];
    if(fileType != 0)
        [self setUpDataSrc: [fields subarrayWithRange:NSMakeRange(0, [fields count])]];
}

- (void)resetUsers {
    NSString *contents = [NSString stringWithContentsOfFile:userTxtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *rows = [contents componentsSeparatedByString:@"\n"];
    for(NSString *row in rows)
        [self parseText:row file:1];
}

-(void)removeSelectedUser: (NSString *)username {
    NSString *contents = [NSString stringWithContentsOfFile:userTxtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *rows = [contents componentsSeparatedByString:@"\n"];
    contents = @"";
    for (NSString *row in rows){
        if([[row stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
            continue;
        NSArray *fields = [row componentsSeparatedByString:@" "];
        if([username isEqualToString:[fields objectAtIndex:0]])
            continue;
        contents = [contents stringByAppendingString:[[NSString alloc] initWithFormat:@"%@\n",row]];
    }
    
    [dataSrc removeAllObjects];
    [userCredentials removeAllObjects];
    [adminCredentials removeAllObjects];
    [self saveOnDisk:[contents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] clearFile:YES];
    [self uploadListFile:NO];
    [self resetUsers];
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
        if([[array objectAtIndex:i] isEqualToString:@"#*#"])
            text = [text stringByAppendingString:@" [Administrator User]"];
        if(![[array objectAtIndex:i] isEqualToString:@"(empty)"] && ![[array objectAtIndex:i] isEqualToString:@"#*#"] )
            text = [text stringByAppendingFormat:@" %@", [[array objectAtIndex:i] capitalizedString]];
    }
    NSLog(@"%@", text);
    [dataSrc addObject:text];
}

- (void)updateSelectedUser:(NSString *)text username:(NSString *)username {
    [self removeSelectedUser:username];
    [self saveUser:text];
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
