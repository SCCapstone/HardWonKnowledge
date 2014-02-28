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

@interface UserLoginViewController : UIViewController<UIAlertViewDelegate>

- (IBAction)userLogin;
- (IBAction)driveLogin;
- (IBAction)driveLogout;
- (IBAction)userSettings;
- (IBAction)closeView;
- (IBAction)addUser;
- (IBAction)viewUser;
- (IBAction)submitUser;
- (IBAction)editUser;
@property (weak, nonatomic) IBOutlet UIButton *LogInButton;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) DriveManager *driveManager;
@end
