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

@interface UserLoginViewController : UIViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

- (void)parseFile: (NSArray *)rows;
- (IBAction)driveLogin;
- (IBAction)driveLogout;
- (IBAction)closeAnimated;
- (IBAction)closePlain;
- (void)openView: (NSString*)title value:(BOOL)value;
- (UIButton*)addButton: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (void)addLabel: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color alignment:(UITextAlignment)align fontSize:(CGFloat)size lines:(NSInteger)numberOfLines;
- (UITextField*)addTextField: (NSString*)placeholder x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size secure:(BOOL)value capitalize:(BOOL)cap;
- (IBAction)userLogin;
- (IBAction)adminMenu;
- (IBAction)userSettings;
- (IBAction)addUser;
- (IBAction)editUser;
- (IBAction)viewUser;
- (IBAction)submitUser;
- (void)uploadListFile: (NSString*)filePath exists:(BOOL)value;

@property (weak, nonatomic) IBOutlet UIButton *LogInButton;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) DriveManager *driveManager;
@end
