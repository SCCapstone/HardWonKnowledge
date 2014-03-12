//
//  AdminView.m
//  StemNotebook
//
//  Created by Saraswati on 3/11/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "AdminView.h"

@interface AdminView ()

@end

@implementation AdminView

@synthesize subviews;
@synthesize texts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.loginBackend = [[UserLoginBackend alloc]init];
        [self.loginBackend initVariables];
        [self.loginBackend findBundleData];
        [self.loginBackend findDriveData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    subviews = [[NSMutableArray alloc]init];
    texts = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*  Add button to adminView and set up properties  */
- (UIButton*)addButton: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(x, y, width, height);
    [self.view addSubview:button];
    [subviews addObject:button];
    return button;
}

/*  Add label to adminView and set up properties  */
- (void)addLabel: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color alignment:(UITextAlignment)align fontSize:(CGFloat)size isBold:(BOOL)bold {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    label.text = title;
    label.textColor = color;
    label.textAlignment = align;
    label.font = [UIFont systemFontOfSize:size];
    label.font = [UIFont boldSystemFontOfSize:size];
    [self.view addSubview:label];
    [subviews addObject:label];
}

/*  Add switch to adminView and set up properties */
- (void)addSwitch{
    //  SWITCH DETAILS  //
}

/*  Add text field to adminView and set up properties */
- (UITextField*)addTextField: (NSString*)placeholder x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size secure:(BOOL)value capitalize:(BOOL)cap {
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
    [self.view addSubview: text];
    [subviews addObject:text];
    return text;
}

/*  Add text view to adminView and set up properties */
- (void)addTextView{
        //  TEXT VIEW DETAILS  //
}

/*  Method for creating alert with a single button  */
- (void)alertOneButton: (NSString*)title message:(NSString*)mssg buttonTitle:(NSString*)btn {
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = title;
    alert.message = mssg;
    [alert addButtonWithTitle:btn];
    [alert show];
}

/*  Method for creating alert with two buttons  */
- (void)alertTwoButtons:(NSString *)title message:(NSString *)mssg firstButton:(NSString *)btn1 secondButton:(NSString *)btn2 {
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = title;
    alert.message = mssg;
    [alert addButtonWithTitle:btn1];
    [alert addButtonWithTitle:btn2];
    [alert show];
}

/*  Remove UIViews from the interface  */
- (void)clearScreen {
    for(UIView *view in subviews)
       [view removeFromSuperview];
}

/*  Close adminView using animation  */
- (IBAction)closeAnimated {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*  Review the newly added user before submit  */
- (IBAction)confirmUser {
    if(tf0.text == NULL || tf3.text == NULL || tf4.text == NULL){
        [self alertOneButton:@"Input Error" message:@"Please enter values\nin required fields." buttonTitle:@"Dismiss"];
        return;
    }
    if([self.loginBackend isStudentUser:tf3.text] || [self.loginBackend isAdminUser:tf3.text]){
        [self alertOneButton:@"Input Error" message:@"This username is already taken" buttonTitle:@"Dismiss"];        
        return;
    }
    
    if([tf1.text length] > 1)
        tf1.text = [tf1.text substringToIndex:1];
    
    [self alertTwoButtons:@"Insert Confirmation" message:[[NSString alloc]initWithFormat:@"First Name: %@\nMiddle Initial: %@\nLast Name: %@\nUsername: %@\nPassword: %@", tf0.text,tf1.text,tf2.text,tf3.text,tf4.text] firstButton:@"Add" secondButton:@"Dismiss"];
}

/*  The Add User Menu for adding users to the users list  */
- (IBAction)menuAdminAdd {
    
    //    if(data1.text == nil)
    [self openView:@"Add New User" value:NO];
    //    else {
    //        [self openView:@"Update User" value:NO];
    //        NSString *text = [[NSString alloc]initWithFormat:@"First Name: %@\nLast Name: %@\nUsername: %@\nPassword: %@",data1.text,data2.text,data3.text,data4.text];
    //        [self addLabel:text x:50 y:200 width:200 height:100 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:14 lines:4];
    //    }
    
    data1 = [self addTextField:@"First Name (Required)" x:50.0 y:100.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:YES];
    data2 = [self addTextField:@"Last Name" x:50.0 y:130.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:YES];
    data3 = [self addTextField:@"Username (Required)" x:50.0 y:160.0 width:200.0 height:20.0 fontSize:12 secure:NO capitalize:NO];
    data4 = [self addTextField:@"Password (Required)" x:50.0 y:190.0 width:200.0 height:20.0 fontSize:12 secure:YES capitalize:NO];
    
    UIButton *button1 = [self addButton:@"Submit" x:50.0 y:300.0 width:100.0 height:35.0];
    UIButton *button2 = [self addButton:@"Cancel" x:160.0 y:300.0 width:100.0 height:35.0];
    [button1 addTarget:self action:@selector(confirmSubmittedUser) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(menuAdminSettings) forControlEvents:UIControlEventTouchUpInside];
}

/*  The Edit Users Menu for updating users to or removing users from the users list  */
- (IBAction)menuAdminEdit {
    if([dataSrc count]==0){
        UIAlertView * alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"Error";
        alert.message = [[NSString alloc] initWithFormat:@"You must add users before you can use this feature."];
        [alert addButtonWithTitle:@"Dismiss"];
        [alert show];
        return;
    }
    
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
    
    UIButton *button3 = [self addButton:@"Cancel" x:200.0 y:350.0 width:75.0 height:35.0];
    [button3 addTarget:self action:@selector(menuAdminSettings) forControlEvents:UIControlEventTouchUpInside];
}

/*  Set up the User Settings Menu for admin user  */
- (IBAction)menuAdminSettings {
    [self openView:@"Settings" value:NO];
    [self uploadListFile:NO];
    
    srchedData = [[NSMutableArray alloc] init];
    data1.text = nil;
    data2.text = nil;
    data3.text = nil;
    data4.text = nil;
    
    UIButton *button1 = [self addButton:@"Add New User" x:(adminView.view.frame.size.width-200)/2 y:100.0 width:200.0 height:35.0];
    //    UIButton *button2 = [self addButton:@"Update/Remove User" x:(adminView.view.frame.size.width-200)/2 y:150.0 width:200.0 height:35.0];
    UIButton *button3 = [self addButton:@"Cancel" x:(adminView.view.frame.size.width-200)/2 y:250.0 width:200.0 height:35.0];
    
    [button1 addTarget:self action:@selector(menuAdminAdd) forControlEvents:UIControlEventTouchUpInside];
    //    [button2 addTarget:self action:@selector(menuAdminUpdate) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(menuAdminMain) forControlEvents:UIControlEventTouchUpInside];
}

/*  Open adminView and set up properties  */
- (void)openView: (NSString*)title value:(BOOL)value{
    [self clearScreen];
    
    [self addLabel:title x:(adminView.view.frame.size.width-200)/2 y:10.0 width:200.0 height:50.0 color:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter fontSize:18 lines:1];
}

/*  The remove user prompt  */
- (IBAction)promptRemoveUser {
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"Remove User";
    alert.message = [[NSString alloc] initWithFormat:@"Are you sure you want to delete %@?", [srchedData objectAtIndex:0]];
    [alert addButtonWithTitle:@"Remove"];
    [alert addButtonWithTitle:@"Dismiss"];
    [alert show];
    return;
}

/*  The update user prompt  */
- (IBAction)promptUpdateUser {
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"Update User";
    alert.message = [[NSString alloc] initWithFormat:@"Are you sure you want to update %@?", [srchedData objectAtIndex:0]];
    [alert addButtonWithTitle:@"Update"];
    [alert addButtonWithTitle:@"Dismiss"];
    [alert show];
    return;
}

/*  Alert View responses  */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonPressedName isEqualToString:@"Okay"]){
        [self menuAdminAdd];
    }
    else if([buttonPressedName isEqualToString:@"Update"]){
//        NSString *contents = [NSString stringWithContentsOfFile:userTxtPath encoding:NSUTF8StringEncoding error:nil];////////////////////////////////////////////
//        NSArray *rows = [contents componentsSeparatedByString:@"\n"];
//        for (int n=0; n<[rows count]; n++){
//            NSString *users = [rows objectAtIndex:n];
//            NSArray *userInfo = [users componentsSeparatedByString:@" "];
//            data3.text = [[userInfo objectAtIndex:0] lowercaseString];
//            if([data3.text isEqualToString:[srchedData objectAtIndex:0]]){
//                data4.text = [[userInfo objectAtIndex:1] lowercaseString];
//                data1.text = [[userInfo objectAtIndex:2] capitalizedString];
//                data2.text = [[userInfo objectAtIndex:3] capitalizedString];
//                break;
//            }
//        }
//        [self menuAdminAdd];
        NSLog(@"Update");
    }
    else if([buttonPressedName isEqualToString:@"Add"]){
//        [self saveConfirmedUser];
//        
//        UIAlertView * alert = [[UIAlertView alloc] initWithFrame:CGRectMake((adminView.view.frame.size.width-100)/2, (adminView.view.frame.size.width-100)/2, 100, 100)];
//        alert.delegate = self;
//        alert.title = @"User Added Successfully";
//        alert.message = nil;
//        [alert addButtonWithTitle:@"Okay"];
//        [alert show];
        NSLog(@"Add");
    }
    else if([buttonPressedName isEqualToString:@"Remove"]){
//        [self promptRemoveUser];
//        UIAlertView * alert = [[UIAlertView alloc]
//                               initWithFrame:CGRectMake((adminView.view.frame.size.width-100)/2, (adminView.view.frame.size.width-100)/2, 100, 100)];
//        alert.delegate = self;
//        alert.title = @"User Deleted Successfully";
//        alert.message = nil;
//        [alert addButtonWithTitle:@"Dismiss"];
//        [alert show];
//        [self menuAdminUpdate];
        NSLog(@"Remove");
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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // only show the status bar's cancel button while in edit mode
    sBar.showsCancelButton = YES;
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [tblData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    sBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [tblData removeAllObjects];
    [tblData addObjectsFromArray:dataSrc];
    [srchedData setObject:@"DUMMY_VALUE" atIndexedSubscript:0];
    @try{
        [myTableView reloadData];
    }
    @catch(NSException *e){
    }
    [sBar resignFirstResponder];
    sBar.text = @"";
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
            
            UIButton *button1 = [self addButton:@"Update" x:20.0 y:350.0 width:75.0 height:35.0];
            UIButton *button2 = [self addButton:@"Remove" x:100.0 y:350.0 width:75.0 height:35.0];
            [button1 addTarget:self action:@selector(promptUpdateUser) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(promptRemoveUser) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

@end