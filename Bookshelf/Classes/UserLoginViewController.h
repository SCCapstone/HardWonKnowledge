//
//  UserLoginViewController.h
//  Bookshelf
//
//  Created by Saraswati on 2/20/14.
//
//

#import <UIKit/UIKit.h>

@interface UserLoginViewController : UIViewController{
//    IBOutlet UITextField *usernameField;
//    IBOutlet UITextField *passwordField;
    NSDictionary *userCredentials;
}
//- (IBAction)userLogin:(id)sender;
//@property (strong, nonatomic) IBOutlet UILabel *ButtonPressedNameLabel;
- (IBAction)userLogin;
@end
