//
//  UserLoginViewController.m
//  StemNotebook
//
//  Created by Keneequa Brown on 2/20/14.
//
//

#import "UserLoginViewController.h"
//#import "BookshelfGridViewController.h"

@interface UserLoginViewController (){
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    NSMutableArray *subviews;
}

@end

@implementation UserLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    subviews = [[NSMutableArray alloc]init];
    self.adminView = [[AdminView alloc]initWithNibName:nil bundle:nil];
}

- (UIButton*)addButton: (NSString*)title y:(CGFloat)y {
    UIButton *book = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [book setTitle:title forState:UIControlStateNormal];
    book.frame = CGRectMake((self.view.frame.size.width-250)/2 , y, 250, 50);
    book.titleLabel.font = [UIFont systemFontOfSize:18];
    book.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:book];
    [subviews addObject:book];
    return book;
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

- (void)showAdmin{
    [usernameField removeFromSuperview];
    [passwordField removeFromSuperview];
    
    UIButton *notebook = [self addButton:@"STEM Notebook" y:self.loginButton.frame.origin.y-300];
    [notebook addTarget:self action:@selector(openNotebook) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *adminView = [self addButton:@"User Settings" y:self.loginButton.frame.origin.y-200];
    [adminView addTarget:self action:@selector(openAdminSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *drive = [self addButton:@"Google Drive Connectivity" y:self.loginButton.frame.origin.y-100];
    [drive addTarget:self action:@selector(driveButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *logout = [self addButton:@"Notebook Log Out" y:self.loginButton.frame.origin.y];
    [logout addTarget:self action:@selector(logoutAdmin) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)openAdminSettings{
    [self presentViewController:self.adminView animated:YES completion:NULL];
    [self.adminView menuAdminSettings];
}

- (IBAction)openNotebook{
    if([self.adminView.loginBackend.driveManager isAuthorized]){
//        [self dismissViewControllerAnimated:NO completion:NULL];
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
        [self showAdmin];
        
    }
    else if([[[self.adminView.loginBackend.userCredentials objectForKey:usernameField.text] objectAtIndex:1]isEqualToString:[passwordField.text lowercaseString]]){
        NSLog(@"Student logged in as %@", usernameField.text);
        if([self.adminView.loginBackend.driveManager isAuthorized]){
            BookshelfGridViewController *bookshelf = [[BookshelfGridViewController alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:bookshelf animated:NO completion:NULL];
        }
        else{
            [self alertDriveConnection];
        }
    }
    else {
//        if([self.adminView.loginBackend.driveManager isAuthorized]){
            //            NSLog(@"Incorrect User/Password");
            //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"Please enter a correct password/username combination." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            //                    [alert show];
            [self showAdmin];
//        }
//        else{
//            [self alertDriveConnection];
//        }
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
    else if([buttonPressedName isEqualToString: @"Sign Out"])
        [self driveLogout];
}

@end