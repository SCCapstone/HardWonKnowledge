//
//  UserLoginViewController.h
//  StemNotebook
//
//  Created by Keneequa Brown on 2/20/14.
//
//

#import <UIKit/UIKit.h>
#import "UserLoginBackend.h"
#import "AdminView.h"
#import "ActiveUser.h"

@interface UserLoginViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>

- (IBAction)driveButton;
- (IBAction)loginCheck;

@property (nonatomic, retain) AdminView *adminView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic)  IBOutlet UITextField *usernameField;
@property (weak, nonatomic)  IBOutlet UIButton *loginButton;
@property (nonatomic, retain) NSMutableArray *subviews;
@property (nonatomic, retain) ActiveUser *userManager;
@end
