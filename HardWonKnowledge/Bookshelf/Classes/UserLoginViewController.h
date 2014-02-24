//
//  UserLoginViewController.h
//  Bookshelf
//
//  Created by Keneequa Brown on 2/20/14.
//
//

#import <UIKit/UIKit.h>

@interface UserLoginViewController : UIViewController{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
//    NSMutableArray *usernameCredentials;
//    NSMutableArray *passwordCredentials;
    NSMutableArray *firstName;
    NSMutableArray *lastName;
//    NSDictionary *userCredentials;
    NSMutableDictionary *userCredentials;
    
}
//- (IBAction)userLogin:(id)sender;
//@property (strong, nonatomic) IBOutlet UILabel *ButtonPressedNameLabel;
- (IBAction)userLogin;
@end
