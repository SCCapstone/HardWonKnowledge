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

@interface UserLoginViewController : UIViewController<UIAlertViewDelegate, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>  {

    
}
@property(nonatomic,retain)NSMutableArray *dataSource;


- (void) parseFile: (NSArray *) rows file:(NSInteger)file;
- (IBAction)userLogin;
- (IBAction)adminMenu;
- (IBAction)userSettings;
- (IBAction)addUser;
- (IBAction)editUser;
- (IBAction)viewUser;
- (void)submitUser;
- (NSString*)saveOnDisk: (NSString *)text clearFile:(BOOL)clearFile;
- (void)uploadListFile: (NSString*)filePath isNewFile:(BOOL)isNewFile;

@property (weak, nonatomic) IBOutlet UIButton *LogInButton;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) DriveManager *driveManager;
@end
