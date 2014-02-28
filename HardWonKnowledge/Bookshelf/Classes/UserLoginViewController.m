//
//  UserLoginViewController.m
//  Bookshelf
//
//  Created by Keneequa Brown on 2/20/14.
//
//

#import "UserLoginViewController.h"
#import "BookshelfGridViewController.h"

@interface UserLoginViewController (){
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    //    NSMutableArray *firstName;
    //    NSMutableArray *lastName;
    NSMutableDictionary *userCredentials;
    UIViewController *adminView;
    IBOutlet UITextField *inputFirst;
    IBOutlet UITextField *inputLast;
    IBOutlet UITextField *inputUser;
    IBOutlet UITextField *inputPass;
    BOOL isAddUser;
}

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
        NSString *thePassword = [userInfo objectAtIndex:1];
        thePassword = [thePassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [userCredentials setObject:thePassword forKey:theUsername];
        //        [firstName addObject:[userInfo objectAtIndex:2]];
        //        [lastName addObject:[userInfo objectAtIndex:3]];
        
        self.driveManager = [DriveManager getDriveManager];
    }
}

- (IBAction)userLogin {
    if([[userCredentials objectForKey:@"admin"]isEqualToString:passwordField.text]){
        
    }
    else if([[userCredentials objectForKey:usernameField.text]isEqualToString:passwordField.text]){
        if([self.driveManager isAuthorized]){
            BookshelfGridViewController *bookshelf = [[BookshelfGridViewController alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:bookshelf animated:NO completion:NULL];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc] init];
            alert.delegate = self;
            alert.title = @"Cloud Connection Error";
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            alert.message = @"Please have the instructor enter the administrator password.";
            [alert addButtonWithTitle:@"Log In"];
            [alert show];
        }
    }
    else{
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"Please enter a correct password/username combination." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        //        [alert show];
        adminView = [[UIViewController alloc] init];
        adminView.modalPresentationStyle = UIModalPresentationFormSheet;
        adminView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:adminView animated:YES completion:NULL];
        adminView.view.backgroundColor= [UIColor whiteColor];
        adminView.view.superview.frame = CGRectMake(0, 0, 300, 400);
        adminView.view.superview.center = self.view.center;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-200)/2, 10, 200.0, 50.0)];
        title.text = @"Administrative Menu";
        title.textColor = [UIColor darkGrayColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:18];
        [adminView.view addSubview:title];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button1 setTitle:@"Settings" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
        button1.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 100, 200.0, 35.0);
        [adminView.view addSubview:button1];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button2 setTitle:@"Log In to Google Drive" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(driveLogin) forControlEvents:UIControlEventTouchUpInside];
        button2.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 150, 200.0, 35.0);
        [adminView.view addSubview:button2];
        
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button3 setTitle:@"Log Out of Google Drive" forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(driveLogout) forControlEvents:UIControlEventTouchUpInside];
        button3.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 200, 200.0, 35.0);
        [adminView.view addSubview:button3];
        
        UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button4 setTitle:@"Close" forState:UIControlStateNormal];
        [button4 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        button4.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 250, 200.0, 35.0);
        [adminView.view addSubview:button4];
    }
}

- (IBAction)driveLogin{
    [self.driveManager loginFromViewController:self];
}

- (IBAction)driveLogout{
    [self.driveManager logout];
}

- (IBAction)userSettings{
    [adminView dismissViewControllerAnimated:NO completion:NULL];
    adminView = [[UIViewController alloc] init];
    adminView.modalPresentationStyle = UIModalPresentationFormSheet;
    adminView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:adminView animated:NO completion:NULL];
    adminView.view.backgroundColor= [UIColor whiteColor];
    adminView.view.superview.frame = CGRectMake(0, 0, 300, 400);
    adminView.view.superview.center = self.view.center;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-200)/2, 10, 200.0, 50.0)];
    title.text = @"Settings";
    title.textColor = [UIColor darkGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    [adminView.view addSubview:title];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Add New User" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 100, 200.0, 35.0);
    [adminView.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Remove Existing User" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 150, 200.0, 35.0);
    [adminView.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"Update Existing User" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(editUser) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 200, 200.0, 35.0);
    [adminView.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 setTitle:@"Close" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    button4.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 250, 200.0, 35.0);
    [adminView.view addSubview:button4];
}

- (IBAction)closeView{
    [adminView dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addUser{
    [adminView dismissViewControllerAnimated:NO completion:NULL];
    adminView = [[UIViewController alloc] init];
    adminView.modalPresentationStyle = UIModalPresentationFormSheet;
    adminView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:adminView animated:NO completion:NULL];
    adminView.view.backgroundColor= [UIColor whiteColor];
    adminView.view.superview.frame = CGRectMake(0, 0, 300, 400);
    adminView.view.superview.center = self.view.center;
    
    isAddUser = TRUE;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-200)/2, 10, 200.0, 50.0)];
    title.text = @"Add New User";
    title.textColor = [UIColor darkGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    [adminView.view addSubview:title];
    
    inputFirst = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 200, 20)];
    inputFirst.borderStyle = UITextBorderStyleBezel;
    inputFirst.placeholder = @"First Name";
    inputFirst.font = [UIFont systemFontOfSize:12];
    
    inputLast = [[UITextField alloc] initWithFrame:CGRectMake(50, 130, 200, 20)];
    inputLast.borderStyle = UITextBorderStyleBezel;
    inputLast.placeholder = @"Last Name";
    inputLast.font = [UIFont systemFontOfSize:12];
    
    inputUser = [[UITextField alloc] initWithFrame:CGRectMake(50, 160, 200, 20)];
    inputUser.borderStyle = UITextBorderStyleBezel;
    inputUser.placeholder = @"Username (Required)";
    inputUser.font = [UIFont systemFontOfSize:12];
    
    inputPass = [[UITextField alloc] initWithFrame:CGRectMake(50, 190, 200, 20)];
    inputPass.borderStyle = UITextBorderStyleBezel;
    inputPass.placeholder = @"Password (Required)";
    inputPass.font = [UIFont systemFontOfSize:12];
    
    [adminView.view addSubview: inputFirst];
    [adminView.view addSubview: inputLast];
    [adminView.view addSubview: inputUser];
    [adminView.view addSubview: inputPass];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Continue" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(viewUser) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(50, 300, 100.0, 35.0);
    [adminView.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Cancel" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(160, 300, 100.0, 35.0);
    [adminView.view addSubview:button2];
}

- (IBAction)editUser{
    [adminView dismissViewControllerAnimated:NO completion:NULL];
    adminView = [[UIViewController alloc] init];
    adminView.modalPresentationStyle = UIModalPresentationFormSheet;
    adminView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:adminView animated:NO completion:NULL];
    adminView.view.backgroundColor= [UIColor whiteColor];
    adminView.view.superview.frame = CGRectMake(0, 0, 300, 400);
    adminView.view.superview.center = self.view.center;
    
    isAddUser = FALSE;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-200)/2, 10, 200.0, 50.0)];
    title.text = @"Update Existing User";
    title.textColor = [UIColor darkGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    [adminView.view addSubview:title];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Add New User" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 100, 200.0, 35.0);
    [adminView.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Remove Existing User" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake((adminView.view.frame.size.width-200)/2, 150, 200.0, 35.0);
    [adminView.view addSubview:button2];
}

- (IBAction)viewUser{
    if(inputFirst.text==nil || inputUser.text==nil || inputPass.text==nil){
        UIAlertView * alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"Input Error";
        alert.message = @"Please enter values in required fields.";
        [alert addButtonWithTitle:@"Dismiss"];
        [alert show];
        return;
    }
    [adminView dismissViewControllerAnimated:NO completion:NULL];
    adminView = [[UIViewController alloc] init];
    adminView.modalPresentationStyle = UIModalPresentationFormSheet;
    adminView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:adminView animated:NO completion:NULL];
    adminView.view.backgroundColor= [UIColor whiteColor];
    adminView.view.superview.frame = CGRectMake(0, 0, 300, 400);
    adminView.view.superview.center = self.view.center;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-200)/2, 10, 200.0, 50.0)];
    title.text = @"Administrative Menu";
    title.textColor = [UIColor darkGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    [adminView.view addSubview:title];
    
    NSString *info = [[NSString alloc]initWithFormat:@"First Name: %@\nLast Name: %@\nUsername: %@\nPassword: %@", inputFirst.text,inputLast.text,inputUser.text,inputPass.text];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-200)/2, 20, 200.0, 300.0)];
    label1.text = info;
    label1.numberOfLines = 4;
    label1.textColor = [UIColor darkGrayColor];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:12];
    [adminView.view addSubview:label1];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Back" forState:UIControlStateNormal];
    if(isAddUser){
        [button1 addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [button1 addTarget:self action:@selector(editUser) forControlEvents:UIControlEventTouchUpInside];
    }
    button1.frame = CGRectMake(20, 300, 75.0, 35.0);
    [adminView.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Submit" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(submitUser) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(100, 300, 75.0, 35.0);
    [adminView.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"Cancel" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(200, 300, 75.0, 35.0);
    [adminView.view addSubview:button3];
}

- (IBAction)submitUser{
    NSString *text = [[NSString alloc]initWithFormat:@"\n%@ %@ %@ %@", inputUser.text,inputPass.text,inputFirst.text,inputLast.text];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"txt"];
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    contents = [contents stringByAppendingString:text];
    [contents writeToFile:filePath atomically:YES encoding: NSUnicodeStringEncoding error:nil];
//    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
//    [fileHandler seekToEndOfFile];
//    [fileHandler writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
//    [fileHandler closeFile];
    
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"User Added";
    alert.message = nil;
    [alert addButtonWithTitle:@"Dismiss"];
    [alert show];
    
    [self userSettings];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonPressedName isEqualToString: @"Log In"]){
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
            [alert addButtonWithTitle:@"Log In"];
            [alert show];
        }
    }
}

@end
