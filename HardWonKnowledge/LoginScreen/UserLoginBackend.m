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
@synthesize docPath;

- (void)initVariables{
    userCredentials = [[NSMutableDictionary alloc] init];
    adminCredentials = [[NSMutableDictionary alloc] init];
    dataSrc = [[NSMutableArray alloc] init];
    listFileId = @"Default String Data";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserList.plist"];
//    NSLog(@"%@", docPath);
    
}

#pragma mark -
#pragma mark Google Drive
/*  Find the user credential files to parse  */
- (void)findExistingDriveFile{
    self.driveManager = [DriveManager getDriveManager];
    NSString *search = @"title contains 'UserList'";
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            GTLDriveFile *file = [files.items objectAtIndex:0];
            if(file.identifier != nil) {
                listFileId = file.identifier;
                [self.driveManager downloadDriveFile:file];
                NSDictionary *temp = [self dataToDictionaryAtPath:docPath];
                for(id key in temp)
                    [self parseUser:key withData:[temp objectForKey:key]];
            }
//            NSLog(@"ID: %@ %@",listFileId, file.identifier);
        } else
            NSLog (@"An Error has occurred: %@", error);
    }];
}

/*  Upload file to Google Drive  */
- (void)uploadNewUserList {
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = @"UserList.plist";
    file.descriptionProperty = @"List of STEM Notebook users.";
    file.mimeType = @"mimeType = 'application/x-plist'";
    
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:docPath])
        data = [[NSFileManager defaultManager] contentsAtPath:docPath];
    else
        NSLog(@"File does not exist");
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query;
    if([listFileId isEqualToString:@"Default String Data"])
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

#pragma mark -
#pragma mark Local Data
- (void)findDefaultFile{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultUserList" ofType:@"plist"];
    NSDictionary *temp = [self dataToDictionaryAtPath:path];
    for(id key in temp)
        [self parseUser:key withData:[temp objectForKey:key]];
}

/*  Save the file to disk before upload  */
- (void)locallySaveUser:(NSString*)username withData:(NSDictionary *)data clearExistingFile:(BOOL)clearFile {
    NSMutableDictionary *temp;
    if(clearFile)
        temp = [NSMutableDictionary dictionaryWithDictionary:data];
    else{
        temp = [[NSMutableDictionary alloc] initWithDictionary:[self dataToDictionaryAtPath:docPath]];;
        [temp setValue:data forKey:username];
    }

    NSData *contents = [NSPropertyListSerialization dataFromPropertyList:temp
                                                                  format:NSPropertyListXMLFormat_v1_0
                                                        errorDescription:nil];
    if(contents)
        [contents writeToFile:docPath atomically:YES];
    
//    NSLog(@"Saved to disk");
}

/*  Save added user to file on disk  */
- (void)saveUser:(NSString *)username withData:(NSDictionary *)data {
    [self parseUser:username withData:data];
    [self locallySaveUser:username withData:data clearExistingFile:NO];
    [self uploadNewUserList];
}

#pragma mark -
#pragma mark Parsing
- (void)parseUser: (NSString *)user withData:(NSDictionary *)data {
    if([data count]==0 || [user length]==0)
        return;
    if([[data objectForKey:@"isAdmin"]isEqual:@YES])
        [adminCredentials setValue:data forKey:user];
    else
        [userCredentials setValue:data forKey:user];
    
    if(![[data objectForKey:@"Last Name"]isEqual:@"DEFAULT_USER_ENTRY"]){
        [self datasrcAddEntry:data];
    }
}

- (void)datasrcAddEntry: (NSDictionary*)data{
    NSString *text = [[NSString alloc]initWithFormat:@"%@ -",[[data objectForKey:@"Username"] lowercaseString]];
    NSMutableArray *array = [NSArray arrayWithObjects:@"First Name", @"Middle Initial", @"Last Name", nil];
    for(int i=0; i<[array count]; i++) {
            text = [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@" %@", [[data objectForKey:[array objectAtIndex:i]] capitalizedString]];
    }
    if([[data objectForKey:@"isAdmin"]isEqual:@YES])
        text = [text stringByAppendingString:@" [Administrator User]"];
    [dataSrc addObject:text];
}

- (NSDictionary *)dataToDictionaryAtPath: (NSString *)path {
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSPropertyListFormat format;
    NSDictionary *temp = (NSMutableDictionary *)[NSPropertyListSerialization
                                                 propertyListFromData:data
                                                 mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                 format:&format
                                                 errorDescription:nil];
    if (!temp) 
        NSLog(@"Error reading plist: %@, format: %d", nil, format);
    
    return temp;
}

#pragma mark -
#pragma mark Editing User
- (void)resetUsers {
    NSDictionary *temp = [self dataToDictionaryAtPath:docPath];
    for(id key in temp){
        [self parseUser:key withData:[temp objectForKey:key]];
    }
}

-(NSDictionary*)removeSelectedUser: (NSString *)username {
    NSDictionary *temp = [self dataToDictionaryAtPath:docPath];
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    for(id key in temp){
        if(![key isEqualToString:username])
            [newData setValue:[temp objectForKey:key] forKey:key];
    }
    
    [dataSrc removeAllObjects];
    [userCredentials removeAllObjects];
    [adminCredentials removeAllObjects];
    [self locallySaveUser:@"" withData:newData clearExistingFile:YES];
    [self uploadNewUserList];
    [self resetUsers];
    return newData;
}

- (void)updateSelectedUser:(NSString *)username withData:(NSDictionary *)data {
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:[self removeSelectedUser:username]];
    [temp setValue:data forKey:username];
    [self saveUser:username withData:data];
}

#pragma mark -
#pragma mark Other
/*  Search if administrator username is in keys  */
- (BOOL)isAdminUser: (NSString *) name{
    for (NSString *key in [adminCredentials allKeys]){
        if ([name isEqualToString:key] && [adminCredentials objectForKey:name] != nil){
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


@end
