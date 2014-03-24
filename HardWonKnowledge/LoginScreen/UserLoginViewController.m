//
//  UserLoginViewController.m
//  StemNotebook
//
//  Created by Keneequa Brown on 2/20/14.
//
//

#import "UserLoginViewController.h"
//#import "BookshelfGridViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

@synthesize passwordField;
@synthesize usernameField;
@synthesize subviews;

- (void)viewDidLoad{
    [super viewDidLoad];
    subviews = [[NSMutableArray alloc]init];
    self.adminView = [[AdminView alloc]initWithNibName:nil bundle:nil];
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.delegate = self;
}

- (void)addButton: (NSString*)title y:(CGFloat)y action:(SEL)target {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake((self.view.frame.size.width-250)/2 , y, 250, 50);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [subviews addObject:button];
}

- (void)alertDriveConnection{
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"Cloud Connection Error";
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alert.message = @"Please have the instructor enter the administrator password.";
    [alert addButtonWithTitle:@"Log In"];
    [alert show];
}

/*  Remove items on the view  */
- (void)clearScreen{
    for(UIView *view in subviews)
        [view removeFromSuperview];
}

/*  Log in to Drive  */
- (IBAction)driveLogin{
    [self.adminView.loginBackend.driveManager loginFromViewController:self];
}

/*   Log out of Drive  */
- (IBAction)driveLogout{
    NSLog(@"Drive logout");
    [self.adminView.loginBackend.driveManager logout];
}

- (IBAction)driveButton{
    if([self.adminView.loginBackend.driveManager isAuthorized]){
        UIAlertView * alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"Google Drive Sign Out";
        alert.message = @"Are you sure you want to sign out of your Google Drive account?";
        [alert addButtonWithTitle:@"Sign Out"];
        [alert addButtonWithTitle:@"Dismiss"];
        [alert show];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"Google Drive Sign In";
        alert.message = @"Are you sure you want to sign in to your Google Drive account?";
        [alert addButtonWithTitle:@"Sign In"];
        [alert addButtonWithTitle:@"Dismiss"];
        [alert show];
    }
}

- (void)driveAlert{
    UIView *alertview = [[UIView alloc] initWithFrame:CGRectMake(0, -999, self.view.frame.size.width, 50)];
    UILabel *theMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(alertview.bounds), CGRectGetHeight(alertview.bounds))];
    
    theMessage.backgroundColor = [UIColor colorWithRed:178.0/255 green:34.0/255 blue:34.0/255 alpha:1];
    theMessage.font = [UIFont boldSystemFontOfSize:18];
    theMessage.textAlignment = NSTextAlignmentCenter;
    theMessage.textColor = [UIColor whiteColor];
    theMessage.text = @"Please connect to a Google Drive account.";
    [alertview addSubview:theMessage];
    
    if(![self.adminView.loginBackend.driveManager isAuthorized]){
        [self.view addSubview:alertview];
        [subviews addObject:alertview];
        CGRect newFrm = alertview.frame;
        newFrm.origin.y = 44;
        [UIView animateWithDuration:1.0f animations:^{ alertview.frame = newFrm; }];
    }
}



- (void)showAdmin{
    [usernameField removeFromSuperview];
    [passwordField removeFromSuperview];
    
    [self addButton:@"STEM Notebook" y:self.loginButton.frame.origin.y-300 action:@selector(openNotebook)];
    
    [self addButton:@"User Settings" y:self.loginButton.frame.origin.y-200 action:@selector(openAdminSettings)];
    
    [self addButton:@"Google Drive Connectivity" y:self.loginButton.frame.origin.y-100 action:@selector(driveButton)];
    
    [self addButton:@"Notebook Log Out" y:self.loginButton.frame.origin.y action:@selector(logoutAdmin)];
}

- (IBAction)openAdminSettings{
    [self presentViewController:self.adminView animated:YES completion:NULL];
    [self.adminView menuAdminSettings];
}

- (IBAction)openNotebook{
    if([self.adminView.loginBackend.driveManager isAuthorized]){
        BookshelfGridViewController *bookshelf = [[BookshelfGridViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:bookshelf animated:NO completion:NULL];
    }
}

- (IBAction)logoutAdmin{
    [self clearScreen];
    [self.view addSubview:usernameField];
    [self.view addSubview:passwordField];
}

/*  User log in screen set up, confirm or deny user access to notebook features  */
- (IBAction)menuLoginScreen {
    if([[[self.adminView.loginBackend.adminCredentials objectForKey:usernameField.text] objectAtIndex:1]isEqualToString:[passwordField.text lowercaseString]]){
        NSLog(@"Admin logged in as %@", usernameField.text);
        usernameField.text = @"";
        passwordField.text = @"";
        [self showAdmin];
        
    }
    else if([[[self.adminView.loginBackend.userCredentials objectForKey:usernameField.text] objectAtIndex:1]isEqualToString:[passwordField.text lowercaseString]]){
        NSLog(@"Student logged in as %@", usernameField.text);
        if([self.adminView.loginBackend.driveManager isAuthorized]){
            usernameField.text = @"";
            passwordField.text = @"";
            BookshelfGridViewController *bookshelf = [[BookshelfGridViewController alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:bookshelf animated:NO completion:NULL];
        }
        else{
            [self alertDriveConnection];
        }
    }
    else {
        if([self.adminView.loginBackend.driveManager isAuthorized]){
            NSLog(@"Incorrect User/Password");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"Please enter a correct password/username combination." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            //            [self showAdmin];
        }
        else{
            [self alertDriveConnection];
        }
    }
}

/*  Alert View responses  */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonPressedName isEqualToString: @"Log In"]){
        UITextField *promptUser = [alertView textFieldAtIndex:0];
        UITextField *promptPass = [alertView textFieldAtIndex:1];
        if([[[self.adminView.loginBackend.adminCredentials objectForKey:promptUser.text] objectAtIndex:1]isEqualToString:promptPass.text]){
            [self driveLogin];
        }
        else{
            [self alertDriveConnection];
        }
    }
    else if([buttonPressedName isEqualToString: @"Sign In"])
        [self driveLogin];
    else if([buttonPressedName isEqualToString: @"Sign Out"]){
        [self driveLogout];
        [self driveAlert];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == passwordField) {
        [self menuLoginScreen];
    }
    return YES;
}

/*  Hide cursor when click outside of input field.  */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

///*  Hide keyboard when not in user  */
//- (BOOL)disablesAutomaticKeyboardDismissal {
//    return NO;
//}

@end