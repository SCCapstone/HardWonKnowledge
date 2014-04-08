//
//  UserLoginBackend.h
//  StemNotebook
//
//  Created by Keneequa Brown on 3/5/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLDrive.h"
#import "DriveManager.h"
#import "ActiveUser.h"

@interface UserLoginBackend : NSObject

- (BOOL)isAdminUser: (NSString *)name;
- (BOOL)isStudentUser: (NSString *)name;
- (NSDictionary *)dataToDictionaryAtPath: (NSString *)path;
- (void)findExistingDriveFile;
- (void)findDefaultFile;
- (void)initVariables;
//- (void)parseText: (NSString *)text file:(NSInteger)fileType;
- (void)parseUser: (NSString *)user withData:(NSDictionary *)data;
- (void)resetUsers;
- (NSDictionary*)removeSelectedUser: (NSString *)username;
- (void)saveUser:(NSString *)username withData:(NSDictionary *)data;
- (void)locallySaveUser:(NSString*)username withData:(NSDictionary *)data clearExistingFile:(BOOL)clearFile;
- (void)uploadNewUserList;
- (void)updateSelectedUser:(NSString *)username withData:(NSDictionary *)data;

@property (nonatomic,retain) GTLServiceDrive *driveService;
@property (nonatomic,retain) DriveManager *driveManager;
@property (nonatomic, retain) ActiveUser *userManager;
@property (nonatomic,retain) NSMutableDictionary *adminCredentials;
@property (nonatomic,retain) NSMutableDictionary *userCredentials;
@property (nonatomic,retain) NSMutableArray *dataSrc;
@property (nonatomic,retain) NSString *listFileId;
@property (nonatomic,retain) NSString *docPath;

@end
