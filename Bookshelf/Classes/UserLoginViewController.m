//
//  UserLoginViewController.m
//  Bookshelf
//
//  Created by Saraswati on 2/20/14.
//
//

#import "UserLoginViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

// Login Alert
//- (IBAction)userLogin:(id)sender{
//    UIAlertView * credentialAlert = [[UIAlertView alloc] init];
//    credentialAlert.delegate = self;
//    credentialAlert.title = @"Sign In";
//    credentialAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//    credentialAlert.message = @"Please Enter Your Username and Password";
//    [credentialAlert addButtonWithTitle:@"Continue"];
//    [credentialAlert addButtonWithTitle:@"Cancel"];
//    [credentialAlert show];
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
//    
//    if([buttonPressedName isEqualToString:@"Sign In"]){
//        
//        if([[credentials objectForKey:username.text]isEqualToString:password.text]){
//            
//        }
//        
////        if ([username.text isEqualToString:@"Camp"] && [password isEqualToString:@"123"]) {
////            self.ButtonPressedNameLabel.text = @"Credentials received";
////        }
////        else{
////            self.ButtonPressedNameLabel.text = @"Please enter a correct username and password";
////        }
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userCredentials = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"password", @"123", nil] forKeys:[NSArray arrayWithObjects:@"username", @"mn", nil]];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)userLogin{
//    if([[userCredentials objectForKey:usernameField.text]isEqualToString:passwordField.text]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Correct Password" message:@"This password is correct." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//        [alert show];
//    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"This password is incorrect." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//        [alert show];
//    }
}

@end
