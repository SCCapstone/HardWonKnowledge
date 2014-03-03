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
    IBOutlet UITextField *data1;
    IBOutlet UITextField *data2;
    IBOutlet UITextField *data3;
    IBOutlet UITextField *data4;
    NSMutableDictionary *userCredentials;
    NSString *listFileId;
    UIViewController *adminView;
    UITableView *myTableView;
    NSMutableArray *dataSrc; //will be storing all the data
    NSMutableArray *tblData;//will be storing data that will be displayed in table
    NSMutableArray *srchedData;//will be storing data matching with the search string
    UISearchBar *sBar;//search bar
}

@end

@implementation UserLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    userCredentials = [[NSMutableDictionary alloc] init];
    dataSrc= [[NSMutableArray alloc] init];
    data1 = [[UITextField alloc]init];
    data2 = [[UITextField alloc]init];
    data3 = [[UITextField alloc]init];
    data4 = [[UITextField alloc]init];
    listFileId = [[NSString alloc]init];
    
    [self getUserData];
}

/*  Find the user credential files to parse  */
- (void)getUserData{
    // Get hard-coded passwords
    data1.text = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"txt"];
    data2.text = [NSString stringWithContentsOfFile:data1.text encoding:NSUTF8StringEncoding error:nil];
    NSArray *rows = [data2.text componentsSeparatedByString:@"\n"];
    [self parseFile:rows file:0];
    
    // Get users saved on Google Drive
    self.driveManager = [DriveManager getDriveManager];
    NSString *search = @"title contains 'NOTEBOOK_USERS_LIST'";
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = search;
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (error == nil) {
            GTLDriveFile *file = [files.items objectAtIndex:0];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            data1.text = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"users.txt"];
            data2.text = [NSString stringWithContentsOfFile:data1.text encoding:NSUTF8StringEncoding error:nil];
                NSLog(@"GETTING File Id %@",  file.identifier);
            if(file.identifier != nil)
                listFileId = file.identifier;
            if(data2.text==nil){
                NSLog(@"No File in Drive");
                [self saveOnDisk:@"new file" clearFile:YES];
                [self uploadListFile:data1.text isNewFile:YES];
                [self getUserData];
            }
            else{
                NSLog(@"File in Drive");
                if(file.identifier == nil){
                    [self getUserData];
                }
                if(![data2.text isEqualToString:@"new file"] ){
                    NSArray *userRows = [data2.text componentsSeparatedByString:@"\n"];
                    [self parseFile:userRows file:1];
                }
                [self.driveManager downloadDriveFile:file];
            }
            
        } else
            NSLog (@"An Error has occurred: %@", error);
    }];
    
}

/*  Parse the user login information  */
- (void) parseFile: (NSArray *) rows file:(NSInteger)file{
    for (int n=0; n<[rows count]; n++){
        NSString *users = [[rows objectAtIndex:n] stringByAppendingString:@" **"];
        if([[users stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@"**"])
            continue;
        NSArray *userInfo = [users componentsSeparatedByString:@" "];
        NSString *theUsername = [[userInfo objectAtIndex:0] lowercaseString];
        NSString *thePassword = [[userInfo objectAtIndex:1] lowercaseString];
        NSString *theFirstname = [[userInfo objectAtIndex:2] capitalizedString];
        NSString *theLastname = [[userInfo objectAtIndex:3] capitalizedString];
        NSLog(@"%@, %@: %@ (%@)", theLastname, theFirstname, theUsername, thePassword);
        [userCredentials setObject:thePassword forKey:theUsername];
        if(file == 1){
            if([theLastname isEqualToString:@""])
                [dataSrc addObject:[[NSString alloc] initWithFormat:@"%@ (%@)",theFirstname, theUsername]];
            else
                [dataSrc addObject:[[NSString alloc] initWithFormat:@"%@, %@ (%@)",theLastname, theFirstname, theUsername]];
        }
    }
}

/*  Log in to Drive  */
- (IBAction)driveLogin{
    [adminView dismissViewControllerAnimated:NO completion:NULL];
    [self.driveManager loginFromViewController:self];
}

/*   Log out of Drive  */
- (IBAction)driveLogout{
    NSLog(@"Drive logout");
    [self.driveManager logout];
}

/*  Close adminView using animation  */
- (IBAction)closeAnimated{
    [adminView dismissViewControllerAnimated:YES completion:NULL];
}


/*  Open adminView and set up properties  */
- (void)openView: (NSString*)title value:(BOOL)value{
    [adminView dismissViewControllerAnimated:NO completion:NULL];
    
    adminView = [[UIViewController alloc] init];
    adminView.modalPresentationStyle = UIModalPresentationFormSheet;
    adminView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:adminView animated:value completion:NULL];
    adminView.view.backgroundColor= [UIColor whiteColor];
    adminView.view.superview.frame = CGRectMake(0, 0, 300, 400);
    adminView.view.superview.center = self.view.center;
    
    [self addLabel:title x:(adminView.view.frame.size.width-200)/2 y:10.0 width:200.0 height:50.0 color:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter fontSize:18 lines:1];
}

/*  Add button to adminView and set up properties  */
- (UIButton*)addButton: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(x, y, width, height);
    [adminView.view addSubview:button];
    return button;
}

/*  Add label to adminView and set up properties  */
- (void)addLabel: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color alignment:(UITextAlignment)align fontSize:(CGFloat)size lines:(NSInteger)numberOfLines{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    label.text = title;
    label.textColor = color;
    label.numberOfLines = numberOfLines;
    label.textAlignment = align;
    label.font = [UIFont systemFontOfSize:size];
    [adminView.view addSubview:label];
}

/*  Add text field to adminView and set up properties */
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

/*  User log in screen set up, confirm or deny user access to notebook features  */
- (IBAction)userLogin {
    if([[userCredentials objectForKey:@"admin"]isEqualToString:passwordField.text]){
        NSLog(@"Logged in as Admin");
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
        NSLog(@"Logged in as %@", usernameField.text);
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
        if([self.driveManager isAuthorized]){
            NSLog(@"Incorrect User/Password");
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"Please enter a correct password/username combination." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            //        [alert show];
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

/*  Set up first page of the Administrative Menu for admin user  */
- (IBAction)adminMenu{
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

/*  Set up the User Settings Menu for admin user  */
- (IBAction)userSettings{
    [self openView:@"Settings" value:NO];
    
    srchedData = [[NSMutableArray alloc] init];
    [srchedData setValue:@"DUMMY_VALUE" forKey:@"First"];
    [srchedData setValue:@"DUMMY_VALUE" forKey:@"Last"];
    [srchedData setValue:@"DUMMY_VALUE" forKey:@"User"];
    [srchedData setValue:@"DUMMY_VALUE" forKey:@"Pass"];
    data1.text = nil;
    data2.text = nil;
    data3.text = nil;
    data4.text = nil;
    
    UIButton *button1 = [self addButton:@"Add New User" x:(adminView.view.frame.size.width-200)/2 y:100.0 width:200.0 height:35.0];
    UIButton *button2 = [self addButton:@"Update/Remove User" x:(adminView.view.frame.size.width-200)/2 y:150.0 width:200.0 height:35.0];
    UIButton *button3 = [self addButton:@"Cancel" x:(adminView.view.frame.size.width-200)/2 y:250.0 width:200.0 height:35.0];
    
    [button1 addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(editUser) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(adminMenu) forControlEvents:UIControlEventTouchUpInside];
}

/*  The Add User Menu for adding users to the users list  */
- (IBAction)addUser{
    
    if(data1.text == nil)
        [self openView:@"Add New User" value:NO];
    else if(data1.text != NULL){
        [self openView:@"Update User" value:NO];
        NSString *text = [[NSString alloc]initWithFormat:@"First Name: %@\nLast Name: %@\nUsername: %@\nPassword: %@",data1.text,data2.text,data3.text,data4.text];
        [self addLabel:text x:50 y:200 width:200 height:100 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:14 lines:4];
    }
    
    data1 = [self addTextField:@"First Name (Required)" x:50.0 y:100.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:YES];
    data2 = [self addTextField:@"Last Name" x:50.0 y:130.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:YES];
    data3 = [self addTextField:@"Username (Required)" x:50.0 y:160.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:NO];
    data4 = [self addTextField:@"Password (Required)" x:50.0 y:190.0 width:200.0 height:20.0 fontSize:12 secure:YES capitalize:NO];
    
    UIButton *button1 = [self addButton:@"Add" x:50.0 y:300.0 width:100.0 height:35.0];
    UIButton *button2 = [self addButton:@"Cancel" x:160.0 y:300.0 width:100.0 height:35.0];
    [button1 addTarget:self action:@selector(viewUser) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
}

/*  The Edit Users Menu for updating users to or removing users from the users list  */
- (IBAction)editUser{
    if([userCredentials count]<3){
        UIAlertView * alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"Error";
        alert.message = [[NSString alloc] initWithFormat:@"You must add users before you can use this feature."];
        [alert addButtonWithTitle:@"Dismiss"];
        [alert show];
        return;
    }
    
    [tblData removeAllObjects];
    [myTableView reloadData];
    [self openView:@"Update/Remove User" value:NO];
    
    sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10,60,280,35.0)];
    sBar.delegate = self;
    [adminView.view addSubview:sBar];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(25, 95, 250, 250)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    [adminView.view addSubview:myTableView];
    
    srchedData = [[NSMutableArray alloc]init];
    tblData = [[NSMutableArray alloc]init];
    [tblData addObjectsFromArray:dataSrc];
    
    for(NSString *s in dataSrc){
        NSLog(@"%@", s);
    }
    
    UIButton *button1 = [self addButton:@"Update" x:20.0 y:350.0 width:75.0 height:35.0];
    UIButton *button2 = [self addButton:@"Remove" x:100.0 y:350.0 width:75.0 height:35.0];
    UIButton *button3 = [self addButton:@"Cancel" x:200.0 y:350.0 width:75.0 height:35.0];
    [button1 addTarget:self action:@selector(updateUser) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(removeUser) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(userSettings) forControlEvents:UIControlEventTouchUpInside];
}

/*  Update the properties of existing user  */
- (IBAction)updateUser{
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"Update User";
    alert.message = [[NSString alloc] initWithFormat:@"Are you sure you want to update %@?", [srchedData objectAtIndex:0]];
    [alert addButtonWithTitle:@"Update"];
    [alert addButtonWithTitle:@"Dismiss"];
    [alert show];
    return;
}

/*  The Remove Users prompt  */
- (IBAction)removeUser{
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"Remove User";
    alert.message = [[NSString alloc] initWithFormat:@"Are you sure you want to delete %@?", [srchedData objectAtIndex:0]];
    [alert addButtonWithTitle:@"Remove"];
    [alert addButtonWithTitle:@"Dismiss"];
    [alert show];
    return;
}

/*  Review the newly added user before submit  */
- (IBAction)viewUser{
    if(data1.text == NULL || data3.text == NULL || data4.text == NULL){
        UIAlertView * alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"Input Error";
        alert.message = @"Please enter values\nin required fields.";
        [alert addButtonWithTitle:@"Dismiss"];
        [alert show];
        return;
    }
    for (id key in [userCredentials allKeys]) {
        if([key isEqualToString:data3.text] && ![key isEqualToString:nil]){
            UIAlertView * alert = [[UIAlertView alloc] init];
            alert.delegate = self;
            alert.title = @"Input Error";
            alert.message = @"This username is already taken";
            [alert addButtonWithTitle:@"Dismiss"];
            [alert show];
            return;
        }
    }
    
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"Insert Confirmation";
    alert.message = [[NSString alloc]initWithFormat:@"First Name: %@\nLast Name: %@\nUsername: %@\nPassword: %@", data1.text,data2.text,data3.text,data4.text];
    [alert addButtonWithTitle:@"Submit"];
    [alert addButtonWithTitle:@"Dismiss"];
    [alert show];
    return;
}

/*  Save added user to file on disk  */
- (void)submitUser{
    [userCredentials setObject:data4.text forKey:data3.text];
    if([data2.text isEqualToString:@""])
        [dataSrc addObject:[[NSString alloc] initWithFormat:@"%@ (%@)",data1.text, data3.text]];
    else
        [dataSrc addObject:[[NSString alloc] initWithFormat:@"%@, %@ (%@)",data2.text, data1.text, data3.text]];
    
    NSString *text = [[NSString alloc]initWithFormat:@"%@ %@ %@ %@", data3.text, data4.text, data1.text, data2.text];
    text = [self saveOnDisk:text clearFile:NO];
    [self uploadListFile:text isNewFile:NO];
    [self viewDidLoad];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-100)/2, (adminView.view.frame.size.width-100)/2, 100, 100)];
    alert.delegate = self;
    alert.title = @"User Added Successfully";
    alert.message = nil;
    [alert addButtonWithTitle:@"Okay"];
    [alert show];
}

/*  Save the file to disk before upload  */
- (NSString*)saveOnDisk: (NSString *)text clearFile:(BOOL)clearFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"users.txt"];
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", contents);
    if(clearFile || [contents isEqualToString:@"new file"])
        text = [[NSString alloc]initWithFormat:@"%@", text];
    else
        text = [[NSString alloc]initWithFormat:@"%@\n%@", contents, text];
    
    [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Saved to disk");
    return filePath;
}

/*  Upload file to Google Drive  */
- (void)uploadListFile: (NSString*)filePath isNewFile:(BOOL)isNewFile{
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = @"NOTEBOOK_USERS_LIST.txt";
    file.descriptionProperty = @"Text file of STEM Notebook users.";
    file.mimeType = @"text/plain";
    
    NSData *data = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    else
        NSLog(@"File does not exist");
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query;
    if(isNewFile)
        query = [GTLQueryDrive queryForFilesInsertWithObject:file uploadParameters:uploadParameters];
    else
        query = [GTLQueryDrive queryForFilesUpdateWithObject:file fileId:listFileId uploadParameters:uploadParameters];

    UIAlertView *waitIndicator = [self.driveManager showWaitIndicator:@"Loading"];
    [self.driveManager.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFile *insertedFile, NSError *error) {
        [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
        if (error == nil){
            NSLog(@"Google Drive: File Saved");
            if(file.identifier != nil){
                listFileId = file.identifier;
            }
        }
        else
            NSLog(@"An error occurred: %@", error);
    }];
}

/*  Alert View responses  */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"users.txt"];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *rows = [contents componentsSeparatedByString:@"\n"];
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
    else if ([buttonPressedName isEqualToString:@"Okay"]){
        data1.text = nil;
        data2.text = nil;
        data3.text = nil;
        data4.text = nil;
        [self addUser];
    }
    else if([buttonPressedName isEqualToString:@"Update"]){
            for (int n=0; n<[rows count]; n++){
                NSString *users = [rows objectAtIndex:n];
                NSArray *userInfo = [users componentsSeparatedByString:@" "];
                data3.text = [[userInfo objectAtIndex:0] lowercaseString];
                if([data3.text isEqualToString:[srchedData objectAtIndex:0]]){
                    data4.text = [[userInfo objectAtIndex:1] lowercaseString];
                    data1.text = [[userInfo objectAtIndex:2] capitalizedString];
                    data2.text = [[userInfo objectAtIndex:3] capitalizedString];
                    break;
                }
            }
            [self addUser];
    }
    else if([buttonPressedName isEqualToString:@"Submit"]){
        [self submitUser];
    }
    else if([buttonPressedName isEqualToString:@"Remove"]){
        // Update values and save new file without deleted user
        if([[srchedData objectAtIndex:0]isEqualToString:@""]){
            contents = @"";
            for (int n=0; n<[rows count]; n++){
                NSString *users = [rows objectAtIndex:n];
                if([[users stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""])
                    break;
                NSArray *userInfo = [users componentsSeparatedByString:@" "];
                if([[srchedData objectAtIndex:0]isEqualToString:[userInfo objectAtIndex:0]]){
                    continue;
                }
                contents = [contents stringByAppendingString:[[NSString alloc] initWithFormat:@"%@\n",users]];
            }
            [dataSrc removeAllObjects];
            [userCredentials removeAllObjects];
            [tblData removeAllObjects];
            [self saveOnDisk:contents clearFile:YES];
            [self uploadListFile:path isNewFile:NO];
            rows = [contents componentsSeparatedByString:@"\n"];
            [self parseFile:rows file:1];
            [myTableView reloadData];
            
            // Alert user to success
            UIAlertView * alert = [[UIAlertView alloc]
                                   initWithFrame:CGRectMake((adminView.view.frame.size.width-100)/2, (adminView.view.frame.size.width-100)/2, 100, 100)];
            alert.delegate = self;
            alert.title = @"User Deleted Successfully";
            alert.message = nil;
            [alert addButtonWithTitle:@"Dismiss"];
            [alert show];
                        [self editUser];
        }
    }
}

/*
 *  Autofill Search Table Methods
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"contacts error in num of row");
    return [tblData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.textLabel.text = [tblData objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // only show the status bar's cancel button while in edit mode
    sBar.showsCancelButton = YES;
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [tblData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    sBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [tblData removeAllObjects];// remove all data that belongs to previous search
    if([searchText isEqualToString:@""]||searchText==nil){
        [myTableView reloadData];
        return;
    }
    NSInteger counter = 0;
    for(NSString *name in dataSrc){
        NSRange r = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
        if(r.location != NSNotFound)
            [tblData addObject:name];
        counter++;
    }
    [myTableView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [tblData removeAllObjects];
    [tblData addObjectsFromArray:dataSrc];
    @try{
        [myTableView reloadData];
    }
    @catch(NSException *e){
    }
    [sBar resignFirstResponder];
    sBar.text = @"";
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    sBar.text = cell.textLabel.text;
    NSLog(@"%@ Selected",cell.textLabel.text);
    NSArray *u;
    NSString *s;
    for(NSString *user in dataSrc){
        NSRange r = [[user lowercaseString] rangeOfString:[cell.textLabel.text lowercaseString]];
        if(r.location != NSNotFound){
            u = [user componentsSeparatedByString:@" "];
            if([u count] == 2)
                s = [u objectAtIndex:1];
            else if([u count] == 3)
                s = [u objectAtIndex:2];
            s = [[s substringToIndex: s.length-1] substringFromIndex:1];
            [srchedData setObject:s atIndexedSubscript:0];
        }
    }
}

@end