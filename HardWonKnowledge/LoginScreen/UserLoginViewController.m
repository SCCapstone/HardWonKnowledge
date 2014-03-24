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

- (void)addButton: (NSString*)title y:(CGFloat)y action:(SEL)target{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake((self.view.frame.size.width-250)/2 , y, 250, 50);
    button.titleLabel.font = [UIFont systemFontOfSize:18];
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

- (void)showAdmin{
    [usernameField removeFromSuperview];
    [passwordField removeFromSuperview];
    
    [self addButton:@"STEM Notebook" y:self.loginButton.frame.origin.y-300 action:@selector(openNotebook)];
//    [notebook addTarget:self action:@selector(openNotebook) forControlEvents:UIControlEventTouchUpInside];
    
    [self addButton:@"User Settings" y:self.loginButton.frame.origin.y-200 action:@selector(openAdminSettings)];
//    [adminView addTarget:self action:@selector(openAdminSettings) forControlEvents:UIControlEventTouchUpInside];
    
    [self addButton:@"Google Drive Connectivity" y:self.loginButton.frame.origin.y-100 action:@selector(driveButton)];
//    [drive addTarget:self action:@selector(driveButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addButton:@"Notebook Log Out" y:self.loginButton.frame.origin.y action:@selector(logoutAdmin)];
//    [logout addTarget:self action:@selector(logoutAdmin) forControlEvents:UIControlEventTouchUpInside];
    
        [self driveAlert];
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

- (void)driveAlert{
    //Create a view to hold the label and add images or whatever, place it off screen at -100
    UIView *alertview = [[UIView alloc] initWithFrame:CGRectMake(0, -999, self.view.frame.size.width, 50)];
    
    //Create a label to display the message and add it to the alertView
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
        
        [UIView animateWithDuration:1.0f animations:^{
            alertview.frame = newFrm;
        }];
    }
}

- (IBAction)logoutAdmin{
    [self clearScreen];
    [self.view addSubview:usernameField];
    [self.view addSubview:passwordField];
}

/*  User log in screen set up, confirm or deny user access to notebook features  */
- (IBAction)menuLoginScreen {
    if([[[self.adminView.loginBackend.adminCredentials objectForKey:[usernameField.text lowercaseString]] objectAtIndex:1]isEqualToString:passwordField.text]){
        usernameField.text = @"";
        passwordField.text = @"";
        [self showAdmin];
        
    }
    else if([[[self.adminView.loginBackend.userCredentials objectForKey:[usernameField.text lowercaseString]] objectAtIndex:1]isEqualToString:passwordField.text]){
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
    else if([buttonPressedName isEqualToString: @"Sign In"]){
        [self driveLogin];
        for(UIView *view in subviews){
            if(![view isKindOfClass:[UIButton class]])
              [view removeFromSuperview];
        }
//        [subviews removeLastObject];
    }
    else if([buttonPressedName isEqualToString: @"Sign Out"]){
        [self driveLogout];
        [self driveAlert];
    }
}

@end