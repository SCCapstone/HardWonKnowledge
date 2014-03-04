//
//  UserLoginViewController.h
//  Bookshelf
//
//  Created by Keneequa Brown on 2/20/14.
//
//

#import <UIKit/UIKit.h>
#import "GTLDrive.h"
#import "DriveManager.h"

@interface UserLoginViewController : UIViewController<UIAlertViewDelegate, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>   

@property(nonatomic,retain)NSMutableArray *dataSource;

- (IBAction)menuLoginScreen;
- (IBAction)menuAdminMain;
- (IBAction)menuAdminSettings;
- (IBAction)menuAdminAdd;
- (IBAction)menuAdminUpdate;
- (IBAction)confirmSubmittedUser;
- (void)saveConfirmedUser;
- (void)removeSelectedUser;
- (void)parseText: (NSString *)text;
- (void)saveOnDisk: (NSString *)text clearFile:(BOOL)clearFile;
- (void)uploadListFile: (BOOL)isNewFile;

@property (weak, nonatomic) IBOutlet UIButton *LogInButton;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) DriveManager *driveManager;
@end
