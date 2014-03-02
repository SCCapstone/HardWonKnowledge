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
    IBOutlet UITextField *inputFirst;
    IBOutlet UITextField *inputLast;
    IBOutlet UITextField *inputUser;
    IBOutlet UITextField *inputPass;
    NSMutableDictionary *userCredentials;
    NSMutableArray *userInfoRow;
    NSMutableArray *prevInput;
    NSString *listFileId;
    UIViewController *adminView;
    UITableView *autocompleteTableView;
    BOOL isAddUser;
}

@end

@implementation UserLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    userCredentials = [[NSMutableDictionary alloc] init];
    prevInput = [[NSMutableArray alloc] init];
    [prevInput setValue:@"DUMMY_VALUE" forKey:@"First"];
    [prevInput setValue:@"DUMMY_VALUE" forKey:@"Last"];
    [prevInput setValue:@"DUMMY_VALUE" forKey:@"User"];
    [prevInput setValue:@"DUMMY_VALUE" forKey:@"Pass"];
    userInfoRow = [[NSMutableArray alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *rows = [fileContents componentsSeparatedByString:@"\n"];
    [self parseFile:rows];
    
    self.driveManager = [DriveManager getDriveManager];
    NSString *search = @"title contains 'NOTEBOOK_USERS_LIST'";
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            GTLDriveFile *file = [files.items objectAtIndex:0];
            [self.driveManager downloadDriveFile:file];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"users.txt"];
            NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSArray *userRows = [contents componentsSeparatedByString:@"\n"];
            listFileId = file.identifier;
            [self parseFile:userRows];
        } else
            NSLog (@"An Error has occurred: %@", error);
    }];
}

- (void) parseFile: (NSArray *) rows{
    for (int n=0; n<[rows count]; n++){
        NSString *users = [rows objectAtIndex:n];
        NSArray *userInfo = [users componentsSeparatedByString:@" "];
        NSString *theUsername = [userInfo objectAtIndex:0];
        NSString *thePassword = [userInfo objectAtIndex:1];
        NSLog(@"XXXXX %@ %@", theUsername, thePassword);
        [userCredentials setObject:thePassword forKey:theUsername];
        NSLog(@"Credentials forX%@XisX%@X", theUsername, [userCredentials objectForKey:theUsername]);
        [userInfoRow addObject:users];
    }
    
}

- (IBAction)driveLogin{
    [self closePlain];
    [self.driveManager loginFromViewController:self];
}

- (IBAction)driveLogout{
    [self.driveManager logout];
}

- (IBAction)closeAnimated{
    [adminView dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)closePlain{
    [adminView dismissViewControllerAnimated:NO completion:NULL];
}

- (void)openView: (NSString*)title value:(BOOL)value{
    adminView = [[UIViewController alloc] init];
    adminView.modalPresentationStyle = UIModalPresentationFormSheet;
    adminView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:adminView animated:value completion:NULL];
    adminView.view.backgroundColor= [UIColor whiteColor];
    adminView.view.superview.frame = CGRectMake(0, 0, 300, 400);
    adminView.view.superview.center = self.view.center;
    
    [self addLabel:title x:(adminView.view.frame.size.width-200)/2 y:10.0 width:200.0 height:50.0 color:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter fontSize:18 lines:1];
}

- (UIButton*)addButton: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(x, y, width, height);
    [adminView.view addSubview:button];
    return button;
}

- (void)addLabel: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color alignment:(UITextAlignment)align fontSize:(CGFloat)size lines:(NSInteger)numberOfLines{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    label.text = title;
    label.textColor = color;
    label.numberOfLines = numberOfLines;
    label.textAlignment = align;
    label.font = [UIFont systemFontOfSize:size];
    [adminView.view addSubview:label];
}

- (UITextField*)addTextField: (NSString*)placeholder x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size secure:(BOOL)value capitalize:(BOOL)cap{
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if(cap)
        text.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    else
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.autocorrectionType = UITextAutocorrectionTypeNo;
    text.borderStyle = UITextBorderStyleBezel;
    text.placeholder = placeholder;
    text.secureTextEntry = value;
    text.font = [UIFont systemFontOfSize:size];
    [adminView.view addSubview: text];
    return text;
}

- (IBAction)userLogin {
//    [self viewDidLoad];
    if([[userCredentials objectForKey:@"admin"]isEqualToString:passwordField.text]){
        NSLog(@"admin");
        [self openView:@"Administrative Menu" value:YES];
        
        UIButton *button1 = [self addButton:@"Settings" x:(adminView.view.frame.size.width-200)/2 y:100.0 width:200.0 height:35.0];
        UIButton *button2 =[self addButton:@"Log In to Google Drive" x:(adminView.view.frame.size.width-200)/2 y:150.0 width:200.0 height:35.0];
        UIButton *button3 = [self addButton:@"Log Out of Google Drive" x:(adminView.view.frame.size.width-200)/2 y:200.0 width:200.0 height:35.0];
        UIButton *button4 = [self addButton:@"Close" x:(adminView.view.frame.size.width-200)/2 y:250.0 width:200.0 height:35.0];
        
        [button1 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(driveLogin) forControlEvents:UIControlEventTouchUpInside];
        [button3 addTarget:self action:@selector(driveLogout) forControlEvents:UIControlEventTouchUpInside];
        [button4 addTarget:self action:@selector(closeAnimated) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([[userCredentials objectForKey:usernameField.text]isEqualToString:passwordField.text]){
        NSLog(@"Input is good");
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
    else if(![[userCredentials objectForKey:usernameField.text]isEqualToString:passwordField.text]){
        NSLog(@"Incorrect User/Password");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"Please enter a correct password/username combination." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        //        [self openView:@"Administrative Menu" value:YES];
        //
        //        UIButton *button1 = [self addButton:@"Settings" x:(adminView.view.frame.size.width-200)/2 y:100.0 width:200.0 height:35.0];
        //        UIButton *button2 =[self addButton:@"Log In to Google Drive" x:(adminView.view.frame.size.width-200)/2 y:150.0 width:200.0 height:35.0];
        //        UIButton *button3 = [self addButton:@"Log Out of Google Drive" x:(adminView.view.frame.size.width-200)/2 y:200.0 width:200.0 height:35.0];
        //        UIButton *button4 = [self addButton:@"Close" x:(adminView.view.frame.size.width-200)/2 y:250.0 width:200.0 height:35.0];
        //
        //        [button1 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
        //        [button2 addTarget:self action:@selector(driveLogin) forControlEvents:UIControlEventTouchUpInside];
        //        [button3 addTarget:self action:@selector(driveLogout) forControlEvents:UIControlEventTouchUpInside];
        //        [button4 addTarget:self action:@selector(closeAnimated) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)adminMenu{
    [self closePlain];
    [self openView:@"Administrative Menu" value:NO];
    
    UIButton *button1 = [self addButton:@"Settings" x:(adminView.view.frame.size.width-200)/2 y:100.0 width:200.0 height:35.0];
    UIButton *button2 =[self addButton:@"Log In to Google Drive" x:(adminView.view.frame.size.width-200)/2 y:150.0 width:200.0 height:35.0];
    UIButton *button3 = [self addButton:@"Log Out of Google Drive" x:(adminView.view.frame.size.width-200)/2 y:200.0 width:200.0 height:35.0];
    UIButton *button4 = [self addButton:@"Close" x:(adminView.view.frame.size.width-200)/2 y:250.0 width:200.0 height:35.0];
    
    [button1 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(driveLogin) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(driveLogout) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(closeAnimated) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)userSettings{
    [self closePlain];
    [self openView:@"Settings" value:NO];
    
    UIButton *button1 = [self addButton:@"Add New User" x:(adminView.view.frame.size.width-200)/2 y:100.0 width:200.0 height:35.0];
    UIButton *button2 = [self addButton:@"Update/Remove User" x:(adminView.view.frame.size.width-200)/2 y:150.0 width:200.0 height:35.0];
    UIButton *button3 = [self addButton:@"Cancel" x:(adminView.view.frame.size.width-200)/2 y:250.0 width:200.0 height:35.0];
    
    [button1 addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(editUser) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(adminMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)addUser{
    [self closePlain];
    [self openView:@"Add New User" value:NO];
    
    if(inputFirst.text != NULL){
        NSString *text = [[NSString alloc]initWithFormat:@"First Name: %@\nLast Name: %@\nUsername: %@\nPassword: %@", inputFirst.text,inputLast.text,inputUser.text,inputPass.text];
        [self addLabel:text x:50 y:200 width:200 height:100 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:12 lines:4];
    }
    
    isAddUser = TRUE;
    inputFirst = [self addTextField:@"First Name (Required)" x:50.0 y:100.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:YES];
    inputLast = [self addTextField:@"Last Name" x:50.0 y:130.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:YES];
    inputUser = [self addTextField:@"Username (Required)" x:50.0 y:160.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:NO];
    inputPass = [self addTextField:@"Password (Required)" x:50.0 y:190.0 width:200.0 height:20.0 fontSize:12 secure:YES capitalize:NO];
    
    UIButton *button1 = [self addButton:@"Continue" x:50.0 y:300.0 width:100.0 height:35.0];
    UIButton *button2 = [self addButton:@"Cancel" x:160.0 y:300.0 width:100.0 height:35.0];
    [button1 addTarget:self action:@selector(viewUser) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)editUser{
    [self closePlain];
    [self openView:@"Update/Remove User" value:NO];
    
    isAddUser = FALSE;
}

- (IBAction)viewUser{
    NSInteger correctInput = 0;
    if(inputFirst.text != NULL){
        [prevInput setValue:[inputFirst.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"First"];
        correctInput++;
    }
    if(inputLast.text != NULL)
        [prevInput setValue:[inputLast.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"Last"];
    if(inputUser.text != NULL){
        [prevInput setValue:[[inputUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] forKey:@"User"];
        correctInput++;
    }
    if(inputPass.text != NULL){
        [prevInput setValue:[inputPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"Pass"];
        correctInput++;
    }
    
    if(correctInput != 3){
        UIAlertView * alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"Input Error";
        alert.message = @"Please enter values in required fields.";
        [alert addButtonWithTitle:@"Dismiss"];
        [alert show];
        return;
    }
    for (id key in [userCredentials allKeys]) {
        if([key isEqualToString:inputUser.text]){
            UIAlertView * alert = [[UIAlertView alloc] init];
            alert.delegate = self;
            alert.title = @"Input Error";
            alert.message = @"This username is already taken";
            [alert addButtonWithTitle:@"Dismiss"];
            [alert show];
            return;
        }
    }
    
    [self closePlain];
    [self openView:@"User Confirmation" value:NO];
    NSString *text = [[NSString alloc]initWithFormat:@"First Name: %@\nLast Name: %@\nUsername: %@\nPassword: %@", inputFirst.text,inputLast.text,inputUser.text,inputPass.text];
    [self addLabel:text x:(adminView.view.frame.size.width-200)/2 y:20.0 width:200.0 height:300.0 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:12 lines:4];
    
    UIButton *button1 = [self addButton:@"Back" x:20.0 y:300.0 width:75.0 height:35.0];
    UIButton *button2 = [self addButton:@"Submit" x:100.0 y:300.0 width:75.0 height:35.0];
    UIButton *button3 = [self addButton:@"Cancel" x:200.0 y:300.0 width:75.0 height:35.0];
    if(isAddUser)
        [button1 addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    else
        [button1 addTarget:self action:@selector(editUser) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(submitUser) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)submitUser{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"users.txt"];
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *text;
    bool value;
    if ( contents != NULL){
        text = [[NSString alloc]initWithFormat:@"%@\n%@ %@ %@ %@", contents,inputUser.text,inputPass.text,inputFirst.text,inputLast.text];
        value = TRUE;
    }
    else{
        text = [[NSString alloc]initWithFormat:@"%@ %@ %@ %@", inputUser.text,inputPass.text,inputFirst.text,inputLast.text];
        value = FALSE;
    }
    [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self uploadListFile:filePath exists:value];
}

- (void)uploadListFile: (NSString*)filePath exists:(BOOL)value{
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = @"NOTEBOOK_USERS_LIST.txt";
    file.descriptionProperty = @"Text file of STEM Notebook users.";
    file.mimeType = @"text/plain";
    
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    else
        NSLog(@"File does not exists");
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query;
    if(value)
        query = [GTLQueryDrive queryForFilesUpdateWithObject:file fileId:listFileId uploadParameters:uploadParameters];
    else
        query = [GTLQueryDrive queryForFilesInsertWithObject:file uploadParameters:uploadParameters];
    UIAlertView *waitIndicator = [self.driveManager showWaitIndicator:@"Uploading to Google Drive"];
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                                           GTLDriveFile *insertedFile, NSError *error) {
        [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
        if (error == nil)
        {
            NSLog(@"Google Drive: File Saved");
            UIAlertView * alert = [[UIAlertView alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-200)/2, (adminView.view.frame.size.width-200)/2, 200, 200)];
            alert.delegate = self;
            alert.title = @"User Added Successfully";
            alert.message = nil;
            [alert addButtonWithTitle:@"Okay"];
            [alert show];
            [self viewDidLoad];
        }
        else
            NSLog(@"An error occurred: %@", error);
    }];
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
    else if([buttonPressedName isEqualToString:@"Okay"]){
        [self userSettings];
    }
}

@end
