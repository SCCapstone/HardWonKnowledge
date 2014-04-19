//
//  AdminView.m
//  StemNotebook
//
//  Created by Keneequa Brown on 3/5/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "AdminView.h"
#import <QuartzCore/QuartzCore.h>

@interface AdminView ()

@end

@implementation AdminView

@synthesize subviews;
@synthesize savedText;
@synthesize srchedData;
@synthesize tblData;
@synthesize sBar;
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.view.backgroundColor= [UIColor whiteColor];
        self.view.superview.center = self.view.center;
        UINavigationBar *nav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0) ];
        [self.view addSubview:nav];
        
        self.driveManager = [DriveManager getDriveManager];
        self.userManager = [ActiveUser userManager];
        self.loginBackend = [[UserLoginBackend alloc]init];
        [self.loginBackend initVariables];
        [self.loginBackend findExistingDriveFile];
        if([self.loginBackend.adminCredentials count]==0)
            [self.loginBackend findDefaultFile];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    subviews = [[NSMutableArray alloc]init];
    savedText = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Interface Objects
/*  Add button to adminView and set up properties  */
- (void)addButton:(NSInteger)index title:(NSString*)title action:(SEL)action x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(x, y, width, height);
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController setSelectedIndex:index];
    [self.view addSubview:button];
    [subviews setObject:button atIndexedSubscript:index];
}

/*  Add label to adminView and set up properties  */
- (void)addLabel: (NSInteger)index title:(NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color alignment:(UITextAlignment)align fontSize:(CGFloat)size isBold:(BOOL)bold {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    label.text = title;
    label.textColor = color;
    label.textAlignment = align;
    label.font = [UIFont systemFontOfSize:size];
    if(bold)
        label.font = [UIFont boldSystemFontOfSize:size];
    [self.view addSubview:label];
    [subviews setObject:label atIndexedSubscript:index];
}

/*  Add switch to adminView and set up properties */
- (void)addSwitch: (NSInteger)index isOn:(BOOL)isON x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [aSwitch setOnImage: [UIImage imageNamed:@"UISwitch-Yes"]];
    [aSwitch setOffImage:[UIImage imageNamed:@"UISwitch-No"]];
    if(isON)
        [aSwitch setOn:isON animated:YES];
    [aSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:aSwitch];
    [subviews setObject:aSwitch atIndexedSubscript:index];
}

/*  Add text field to adminView and set up properties */
- (void)addTextField: (NSInteger)index placeholder:(NSString*)placeholder x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size secure:(BOOL)value capitalize:(BOOL)cap {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if(cap)
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    else
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleLine;
    [textField.layer setBorderWidth:1.0];
    textField.placeholder = placeholder;
    textField.secureTextEntry = value;
    textField.font = [UIFont systemFontOfSize:size];
    [textField.layer setCornerRadius:10];
    [self.tabBarController setSelectedIndex:index];
    [self.view addSubview: textField];
    [subviews setObject:textField atIndexedSubscript:index];
}

/*  Add text view to adminView and set up properties */
- (void)addTextView: (NSInteger)index text:(NSString*)text x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size editable:(BOOL)edit{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [textView.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [textView.layer setBorderWidth:1.0];
    textView.font = [UIFont systemFontOfSize:size];
    [textView.layer setCornerRadius:10];
    [textView setClipsToBounds: YES];
    [textView setEditable:edit];
    [textView setScrollEnabled:NO];
    if([[text lowercaseString]isEqualToString:@"(empty)"])
        textView.text = @"";
    else
        textView.text = text;
    [self.view addSubview:textView];
    [subviews setObject:textView atIndexedSubscript:index];
}

#pragma mark -
#pragma mark Interface Actions
/*  Responder to switch manupulation  */
- (void)changeSwitch:(id)sender{
    if([sender isOn])
        isAdmin = YES;
    else
        isAdmin = NO;
}

/*  Remove UIViews from the interface  */
- (void)clearScreen {
    for(UIView *view in subviews)
        [view removeFromSuperview];
}

/*  Close adminView using animation  */
- (IBAction)closeView {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -
#pragma mark Functions For Editing User
- (void)mapUserInfoToDictionary{
    UITextField *textField = nil;
    NSArray *keys = [NSArray arrayWithObjects:@"First Name", @"Middle Initial", @"Last Name", @"Username", @"Password", nil];
    NSLog(@"array %@",keys);
    for(int i=1; i<=5; i++){
        textField = [subviews objectAtIndex:i];
        NSLog(@"textfield %i %@",i,textField.text);
        [savedText setValue:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:[keys objectAtIndex:i-1]];
    }
    NSLog(@"array %@",savedText);
}

/*  Review the newly added user before submit  */
- (void)promptUserForMethod: (NSString*)method {
    [self mapUserInfoToDictionary];
    
    if([[savedText objectForKey:@"First Name"] length] < 1 || [[savedText objectForKey:@"Username"] length] < 1 || [[savedText objectForKey:@"Password"]length] < 1){
        [self alertOneButtonWithTitle:@"Input Error" message:@"Please enter values\nin required fields." buttonTitle:@"Dismiss"];
        [savedText removeAllObjects];
        return;
    }
    if(![method isEqualToString:@"Update"] && ([self.loginBackend isStudentUser:[savedText objectForKey:@"Username"]] || [self.loginBackend isAdminUser:[savedText objectForKey:@"Username"]])){
        [self alertOneButtonWithTitle:@"Input Error" message:@"This username is already taken" buttonTitle:@"Dismiss"];
        [savedText removeAllObjects];
        return;
    }
    if([[savedText objectForKey:@"Middle Initial"] length] > 1)
        [savedText setValue:[[savedText objectForKey:@"Middle Initial"] substringToIndex:1] forKey:@"Middle Initial"];
    
    [self alertTwoButtonsWithTitle:@"Insert Confirmation" message:[NSString stringWithFormat:@"First Name: %@\nMiddle Initial: %@\nLast Name: %@\nUsername: %@\nPassword: %@",[savedText objectForKey:@"First Name"],[savedText objectForKey:@"Middle Initial"],[savedText objectForKey:@"Last Name"],[savedText objectForKey:@"Username"],[savedText objectForKey:@"Password"]] firstButton:method secondButton:@"Dismiss"];
}

- (IBAction)addUserButton {
    [self promptUserForMethod:@"Add"];
}

/*  The remove user prompt  */
- (IBAction)removeUserButton {
    if([[srchedData objectAtIndex:0]isEqualToString:@"nil"])
        return;
    if([[srchedData objectAtIndex:0]isEqualToString:[self.userManager username]]){
        [self alertOneButtonWithTitle:@"Error" message:@"User cannot remove own account" buttonTitle:@"Dismiss"];
        return;
    }
    
    [self alertTwoButtonsWithTitle:nil message:[NSString stringWithFormat:@"Delete %@?", [srchedData objectAtIndex:0]] firstButton:@"Remove" secondButton:@"Dismiss"];
}

/*  The update user prompt  */
- (IBAction)updateUserButton {
    [self promptUserForMethod:@"Update"];
}

/*  Setting up user details to be added into user list  */
- (void)submitAddedUser {
    if(isAdmin)
        [savedText setValue:@YES forKey:@"isAdmin"];
    else
        [savedText setValue:@NO forKey:@"isAdmin"];
    [self.loginBackend saveUser:[savedText objectForKey:@"Username"] withData:savedText];
}

/*  Setting up user details to be updated in user list  */
- (void)submitUpdatedUser {
    if(isAdmin)
        
        [savedText setValue:@YES forKey:@"isAdmin"];
    else
        [savedText setValue:@NO forKey:@"isAdmin"];
    [self.loginBackend updateSelectedUser:[srchedData objectAtIndex:0] withData:savedText];
}

/*  Getting user details for updating process  */
- (void)configUpdateUser {
    [savedText removeAllObjects];
    
    if([self.loginBackend isAdminUser:[srchedData objectAtIndex:0]]){
        isAdmin = YES;
        savedText = [self.loginBackend.adminCredentials objectForKey:[srchedData objectAtIndex:0]];
    }
    else{
        isAdmin = NO;
        savedText = [self.loginBackend.userCredentials objectForKey:[srchedData objectAtIndex:0]];
    }
}

#pragma mark -
#pragma mark Interface Views
/*  The Add User Menu for adding users to the users list  */
- (void)menuAdminAdd {
    [self openView:@"Create New User"];
    isAdmin = NO;
    
    [self addTextField:1 placeholder:@"Required Field **" x:120.0 y:150.0 width:315.0 height:30.0 fontSize:18 secure:NO capitalize:YES];
    [self addTextField:2 placeholder:nil x:480 y:150.0 width:40.0 height:30.0 fontSize:18 secure:NO capitalize:YES];
    [self addTextField:3 placeholder:nil x:120.0 y:200.0 width:400.0 height:30.0 fontSize:18 secure:NO capitalize:YES];
    [self addTextField:4 placeholder:@"Required Field **" x:120 y:275 width:400.0 height:30.0 fontSize:18 secure:NO capitalize:NO];
    [self addTextField:5 placeholder:@"Required Field **" x:120 y:325 width:400.0 height:30.0 fontSize:18 secure:YES capitalize:NO];
    
    [self addButton:6 title:@"Submit" action:@selector(addUserButton) x:50.0 y:550.0 width:200.0 height:50.0];
    [self addButton:7 title:@"Cancel" action:@selector(menuAdminSettings) x:(self.view.frame.size.width-250) y:550.0 width:200.0 height:50.0];
    
    [self addLabel:8 title:@"First Name:" x:20 y:150 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:9 title:@"M.I.:" x:440 y:150 width:40 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:10 title:@"Last Name:" x:20 y:200 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:11 title:@"Username:" x:20 y:275 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:12 title:@"Password:" x:20 y:325 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:13 title:@"Is this an administrator account?" x:20 y:400 width:300 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    
    [self addSwitch:14 isOn:NO x:320 y:400 width:200 height:30];
}

/*  The Edit Users Menu for updating users to or removing users from the users list  */
- (IBAction)menuAdminEdit {
    if([self.loginBackend.dataSrc count]==0){
        [self alertOneButtonWithTitle:@"Error" message:@"You must add users before you can use this feature." buttonTitle:@"Dismiss"];
        return;
    }
    
    [self openView:@"View/Edit Users"];
    
    [self generateTableAndSearchBar];
    //    [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [self addButton:3 title:@"Update" action:@selector(menuAdminUpdate) x:10.0 y:550.0 width:150.0 height:50.0];
    [self addButton:4 title:@"Remove" action:@selector(removeUserButton) x:170.0 y:550.0 width:150.0 height:50.0];
    [self addButton:5 title:@"Cancel" action:@selector(menuAdminSettings) x:self.view.frame.size.width-160 y:550.0 width:150.0 height:50.0];
}

/*  Set up the User Settings Menu for admin user  */
- (IBAction)menuAdminSettings {
    [self openView:@"Settings"];
    
    srchedData = [[NSMutableArray alloc] init];
    [self addButton:1 title:@"Add New User" action:@selector(menuAdminAdd) x:(self.view.frame.size.width-250)/2 y:150.0 width:250.0 height:50.0];
    [self addButton:2 title:@"View/Edit Users" action:@selector(menuAdminEdit) x:(self.view.frame.size.width-250)/2 y:250.0 width:250.0 height:50.0];
    [self addButton:3 title:@"Cancel" action:@selector(closeView) x:(self.view.frame.size.width-250)/2 y:350.0 width:250.0 height:50.0];
}

- (IBAction)menuAdminOffline {
    [self openView:@"Offline Users"];
    [self addButton:1 title:@"Close" action:@selector(closeView) x:(self.view.frame.size.width-200)/2 y:550.0 width:200.0 height:50.0];
    
    if([self.loginBackend.dataSrc count]==0){
        [self alertOneButtonWithTitle:@"Error" message:@"You must add users before you can use this feature." buttonTitle:@"Dismiss"];
        return;
    }
    [self generateTableAndSearchBar];
}

/*  The Edit Users Menu for updating users to or removing users from the users list  */
- (IBAction)menuAdminUpdate {
    if([[srchedData objectAtIndex:0]isEqualToString:@"nil"]){
        //        NSLog(@"Nothing Selected");
        return;
    }
    
    [self openView:@"Update Existing User"];
    
    [self addTextView:1 text:[savedText objectForKey:@"First Name"] x:120.0 y:150.0 width:315.0 height:30.0 fontSize:18 editable:YES];
    [self addTextView:2 text:[savedText objectForKey:@"Middle Initial"] x:480 y:150.0 width:40.0 height:30.0 fontSize:18 editable:YES];
    [self addTextView:3 text:[savedText objectForKey:@"Last Name"] x:120.0 y:200.0 width:400.0 height:30.0 fontSize:18 editable:YES];
    [self addTextView:4 text:[savedText objectForKey:@"Username"] x:120 y:275 width:400.0 height:30.0 fontSize:18 editable:NO];
    [self addTextView:5 text:[savedText objectForKey:@"Password"] x:120 y:325 width:400.0 height:30.0 fontSize:18 editable:YES];
    
    [self addButton:6 title:@"Submit" action:@selector(updateUserButton) x:50.0 y:550.0 width:200.0 height:50.0];
    [self addButton:7 title:@"Cancel" action:@selector(menuAdminEdit) x:(self.view.frame.size.width-250) y:550.0 width:200.0 height:50.0];
    
    [self addLabel:8 title:@"First Name:" x:20 y:150 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:9 title:@"M.I.:" x:440 y:150 width:40 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:10 title:@"Last Name:" x:20 y:200 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:11 title:@"Username:" x:20 y:275 width:100 height:30 color:[UIColor redColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:12 title:@"Password:" x:20 y:325 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addLabel:13 title:@"Is this an administrator account?" x:20 y:400 width:300 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    
    [self addSwitch:14 isOn:isAdmin x:320 y:400 width:200 height:30];
    [savedText removeAllObjects];
}

/*  Open adminView and set up properties  */
- (void)openView: (NSString*)title {
    [self clearScreen];
    
    [self addLabel:0 title:title x:0 y:50.0 width:self.view.frame.size.width height:50.0 color:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter fontSize:28 isBold:YES];
}

#pragma mark -
#pragma mark Alert view
/*  Method for creating alert with a single button  */
- (void)alertOneButtonWithTitle: (NSString*)title message:(NSString*)mssg buttonTitle:(NSString*)btn {
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = title;
    alert.message = mssg;
    [alert addButtonWithTitle:btn];
    [alert show];
}

/*  Method for creating alert with two buttons  */
- (void)alertTwoButtonsWithTitle:(NSString *)title message:(NSString *)mssg firstButton:(NSString *)btn1 secondButton:(NSString *)btn2 {
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = title;
    alert.message = mssg;
    [alert addButtonWithTitle:btn1];
    [alert addButtonWithTitle:btn2];
    [alert show];
}

/*  Alert View responses  */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonPressedName isEqualToString:@"Dismiss"]){
        return;
    }
    else if([buttonPressedName isEqualToString:@"Add"]){
        [self submitAddedUser];
        [self menuAdminSettings];
    }
    else if([buttonPressedName isEqualToString:@"Update"]){
        if(!isAdmin){
            [self.loginBackend.adminCredentials removeObjectForKey:[srchedData objectAtIndex:0]];
            //            NSLog(@"Removed from Admin");
        }
        else{
            [self.loginBackend.userCredentials removeObjectForKey:[srchedData objectAtIndex:0]];
            //            NSLog(@"Removed from Student");
        }
        [self submitUpdatedUser];
        [myTableView reloadData];
        [self menuAdminEdit];
    }
    else if([buttonPressedName isEqualToString:@"Remove"]){
        [self.loginBackend removeSelectedUser:[srchedData objectAtIndex:0]];
        [myTableView reloadData];
        [self menuAdminEdit];
    }
}

#pragma mark -
#pragma mark Backend Functions
/*  Hide cursor when click outside of input field.  */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UIView *view in subviews){
        if([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UISearchBar class]] || [view isKindOfClass:[UITextView class]] )
            [view resignFirstResponder];
    }
    [self.view endEditing:YES];
}

/*  Hide keyboard when not in user  */
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

/*
 *  Autofill Search Table Methods
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -
#pragma mark Table View
- (void)generateTableAndSearchBar {
    sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,150,self.view.frame.size.width,50.0)];
    sBar.delegate = self;
    [self.view addSubview:sBar];
    [subviews setObject:sBar atIndexedSubscript:1];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [subviews setObject:myTableView atIndexedSubscript:2];
    
    srchedData = [[NSMutableArray alloc]init];
    tblData = [[NSMutableArray alloc]init];
    [tblData addObjectsFromArray:self.loginBackend.dataSrc];
    [tblData sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [myTableView reloadData];
    
    [srchedData addObject:@"nil"];
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
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = (indexPath.row%2)
    ? [UIColor lightGrayColor] : [UIColor whiteColor];
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
    for(NSString *name in self.loginBackend.dataSrc){
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
    [tblData addObjectsFromArray:self.loginBackend.dataSrc];
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
    
    NSString *text = @"";
    NSArray *array = [cell.textLabel.text componentsSeparatedByString:@" "];
    for(NSString *string in array){
        text = [text stringByAppendingFormat:@"%@ ",string];
    }
    
    sBar.text = text;
    [srchedData setObject:[array objectAtIndex:0] atIndexedSubscript:0];
    [self configUpdateUser];
}

@end