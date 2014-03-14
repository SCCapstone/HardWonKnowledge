//
//  UserLoginBackend.h
//  StemNotebook
//
//  Created by Keneequa Brown on  on 3/5/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLDrive.h"
#import "DriveManager.h"

@interface UserLoginBackend : NSObject
//    IBOutlet UITextField *data1;
//    IBOutlet UITextField *data2;
//    IBOutlet UITextField *data3;
//    IBOutlet UITextField *data4;
//    UIViewController *adminView;
//    UITableView *myTableView;
//    NSMutableArray *dataSrc; //will be storing all the data
//    NSMutableArray *tblData;//will be storing data that will be displayed in table
//    NSMutableArray *srchedData;//will be storing data matching with the search string
//    UISearchBar *sBar;//search bar

- (void)findDriveData;
- (void)findBundleData;
- (void)initVariables;
- (BOOL)isAdminUser: (NSString *)name;
- (BOOL)isStudentUser: (NSString *)name;
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
