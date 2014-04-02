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
- (NSDictionary *)dataToDictionary: (NSString *)path;
- (void)findDriveFile;
- (void)findBundleFile;
- (void)initVariables;
//- (void)parseText: (NSString *)text file:(NSInteger)fileType;
- (void)parseXML: (NSString *)key data:(NSDictionary *)data;
- (void)resetUsers;
- (NSDictionary*)removeSelectedUser: (NSString *)username;
- (void)saveUser:(NSString *)username data:(NSDictionary *)data;
- (void)saveOnDisk:(NSString*)username data:(NSDictionary *)data clearFile:(BOOL)clearFile;
- (void)uploadListFile;
- (void)updateSelectedUser:(NSDictionary *)data username:(NSString *)username ;

@property (nonatomic,retain) GTLServiceDrive *driveService;
@property (nonatomic,retain) DriveManager *driveManager;
@property (nonatomic, retain) ActiveUser *userManager;
@property (nonatomic,retain) NSMutableDictionary *adminCredentials;
@property (nonatomic,retain) NSMutableDictionary *userCredentials;
@property (nonatomic,retain) NSMutableArray *dataSrc;
@property (nonatomic,retain) NSString *listFileId;
@property (nonatomic,retain) NSString *docPath;

@end
