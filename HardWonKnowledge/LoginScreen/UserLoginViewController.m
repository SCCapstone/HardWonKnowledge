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

- (void)driveButton: (UIButton*)button{
    if([self.adminView.loginBackend.driveManager isAuthorized]){
        [button setTitle:@"Log Out of Drive" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(driveLogout) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [button setTitle:@"Log In to Drive" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(driveLogin) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showAdmin{
    [usernameField removeFromSuperview];
    [passwordField removeFromSuperview];
    
    UIButton *notebook = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [notebook setTitle:@"STEM Notebook" forState:UIControlStateNormal];
    notebook.frame = CGRectMake((self.view.frame.size.width-250)/2 , self.loginButton.frame.origin.y-300, 250, 50);
    [self.view addSubview:notebook];
    [notebook addTarget:self action:@selector(openNotebook) forControlEvents:UIControlEventTouchUpInside];
    [subviews addObject:notebook];
    
    UIButton *adminView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [adminView setTitle:@"User Settings" forState:UIControlStateNormal];
    adminView.frame = CGRectMake((self.view.frame.size.width-250)/2 , self.loginButton.frame.origin.y-200, 250, 50);
    [self.view addSubview:adminView];
    [adminView addTarget:self action:@selector(openAdminSettings) forControlEvents:UIControlEventTouchUpInside];
    [subviews addObject:adminView];
    
    UIButton *drive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    drive.frame = CGRectMake((self.view.frame.size.width-250)/2 , self.loginButton.frame.origin.y-100, 250, 50);
    [self.view addSubview:drive];
    [subviews addObject:drive];
    [self driveButton:drive];
    
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logout setTitle:@"Admin Log Out" forState:UIControlStateNormal];
    logout.frame = CGRectMake((self.view.frame.size.width-250)/2 ,self.loginButton.frame.origin.y, 250, 50);
    [self.view addSubview:logout];
    [logout addTarget:self action:@selector(logoutAdmin) forControlEvents:UIControlEventTouchUpInside];
    [subviews addObject:logout];
}

- (IBAction)openAdminSettings{
    [self presentViewController:self.adminView animated:YES completion:NULL];
    [self.adminView menuAdminSettings];
}

- (IBAction)openNotebook{
    if([self.adminView.loginBackend.driveManager isAuthorized]){
        [self dismissViewControllerAnimated:NO completion:NULL];
        
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
        if([self.adminView.loginBackend.driveManager isAuthorized]){
            //            NSLog(@"Incorrect User/Password");
            //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"Please enter a correct password/username combination." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            //                    [alert show];
            [self showAdmin];
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
            [self.adminView.loginBackend.driveManager loginFromViewController:self];
        }
        else{
            [self alertDriveConnection];
        }
    }
}

@end