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

@interface UserLoginBackend : NSObject

- (BOOL)isAdminUser: (NSString *)name;
- (BOOL)isStudentUser: (NSString *)name;

- (void)findDriveData;
- (void)findBundleData;
- (void)initVariables;
- (void)parseText: (NSString *)text file:(NSInteger)fileType;
- (void)resetUsers;
- (void)removeSelectedUser: (NSString *)username;
- (void)saveUser: (NSString *)user;
- (void)saveOnDisk: (NSString *)text clearFile:(BOOL)clearFile;
- (void)uploadListFile: (BOOL)isNewFile;
- (void)updateSelectedUser: (NSString*)text username:(NSString*)username;

@property (nonatomic,retain) GTLServiceDrive *driveService;
@property (nonatomic,retain) DriveManager *driveManager;
@property (nonatomic,retain) NSMutableDictionary *adminCredentials;
@property (nonatomic,retain) NSMutableDictionary *userCredentials;
@property (nonatomic,retain) NSMutableArray *dataSrc;
@property (nonatomic,retain) NSString *listFileId;
@property (nonatomic,retain) NSString *userTxtPath;

@end
