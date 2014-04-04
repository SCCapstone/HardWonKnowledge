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

@interface UserLoginViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>

- (IBAction)driveButton;
- (IBAction)menuLoginScreen;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) AdminView *adminView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic)  IBOutlet UITextField *usernameField;
@property (nonatomic, retain) NSMutableArray *subviews;
@end
