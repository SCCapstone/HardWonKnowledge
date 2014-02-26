//
//  UserLoginViewController.m
//  Bookshelf
//
//  Created by Keneequa Brown on 2/20/14.
//
//

#import "UserLoginViewController.h"
#import "BookshelfGridViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* rows = [fileContents componentsSeparatedByString:@"\n"];
    
    userCredentials = [[NSMutableDictionary alloc] init];
    for (int n=0; n<[rows count]; n++){
        NSString* users = [rows objectAtIndex:n];
        NSArray* userInfo = [users componentsSeparatedByString:@" "];
        
        NSString *theUsername = [userInfo objectAtIndex:0];
        theUsername= [theUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        theUsername = [theUsername lowercaseString];
        //        [usernameCredentials addObject:theUsername];
        NSString *thePassword = [userInfo objectAtIndex:1];
        thePassword = [thePassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //        [passwordCredentials addObject:thePassword];
        [userCredentials setObject:thePassword forKey:theUsername];
        //        [firstName addObject:[userInfo objectAtIndex:2]];
        //        [lastName addObject:[userInfo objectAtIndex:3]];
        
        self.driveManager = [DriveManager getDriveManager];
    }
}

- (IBAction)userLogin{
    if([[userCredentials objectForKey:@"admin"]isEqualToString:passwordField.text]){
        UIAlertView * multibutton = [[UIAlertView alloc] init];
        multibutton.delegate = self;
        multibutton.title = @"Administrator View";
        multibutton.alertViewStyle = UIAlertViewStyleDefault;
        [multibutton addButtonWithTitle:@"Sign In to Google Drive"];
        [multibutton addButtonWithTitle:@"Sign Out of Google Drive"];
        [multibutton addButtonWithTitle:@"Edit Users"];
        [multibutton addButtonWithTitle:@"Exit"];
        [multibutton show];
    }
    else if([[userCredentials objectForKey:usernameField.text]isEqualToString:passwordField.text]){
        if([self.driveManager isAuthorized]){
//            [self.driveManager downloadDriveFile:<#(GTLDriveFile *)#>];
            BookshelfGridViewController *bookshelf = [[BookshelfGridViewController alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:bookshelf animated:NO completion:NULL];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc] init];
            alert.delegate = self;
            alert.title = @"Cloud Connection Error";
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            alert.message = @"Please have the instructor enter the administrator password.";
            [alert addButtonWithTitle:@"Sign In"];
            [alert show];
            
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"Please enter a correct password/username combination." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonPressedName isEqualToString: @"Sign In"]){
        UITextField *promptField = [alertView textFieldAtIndex:buttonIndex];
        if([[userCredentials objectForKey:@"admin"]isEqualToString:promptField.text]){
            [self.driveManager loginFromViewController:self];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc] init];
            alert.delegate = self;
            alert.title = @"Cloud Connection Error";
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            alert.message = @"Please have the instructor enter the administrator password.";
            [alert addButtonWithTitle:@"Sign In"];
            [alert show];
        }
    }
    else if([buttonPressedName isEqualToString:@"Sign In to Google Drive"]){
        [self.driveManager loginFromViewController:self];
    }
    else if([buttonPressedName isEqualToString:@"Sign Out of Google Drive"]){
        [self.driveManager logout];
    }
    else if([buttonPressedName isEqualToString:@"Edit Users"]){
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"txt"];
//        NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        UIAlertView * alert = [[UIAlertView alloc] init];
//        alert.delegate = self;
//        alert.title = @"User Information";
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
////        alert.message = @"Please have the instructor enter the administrator password.";
//        UITextField *textField = [alert textFieldAtIndex:0];
//        textField.placeholder = fileContents;
//        [alert addButtonWithTitle:@"Save"];
//        [alert show];
    }
}

@end
