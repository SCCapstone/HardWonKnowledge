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
//@synthesize texts;
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
//    texts = [[NSMutableArray alloc]init];
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
    button.titleLabel.font = [UIFont systemFontOfSize:18];
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
    if(bold)
        label.font = [UIFont boldSystemFontOfSize:size];
    [self.view addSubview:label];
    [subviews addObject:label];
}

/*  Add switch to adminView and set up properties */
- (void)addSwitch: (BOOL)useYes x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [aSwitch setOnImage: [UIImage imageNamed:@"UISwitch-Yes"]];
    [aSwitch setOffImage:[UIImage imageNamed:@"UISwitch-No"]];
    [aSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:aSwitch];
    [subviews addObject:aSwitch];
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

/*  Responder to switch manupulation  */
- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        NSLog(@"Switch is ON");
        isAdmin = YES;
    }
    else{
        NSLog(@"Switch is OFF");
        isAdmin = NO;
    }
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

/*  Review the newly added user before submit  */
- (IBAction)confirmUser {
    if(tf0.text == nil || tf3.text == nil || tf4.text == nil){
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
- (void)menuAdminAdd {
    [self openView:@"Add New User"];
    isAdmin = NO;
    
    [self addLabel:@"First Name:" x:20 y:150 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    tf0 = [self addTextField:@"Required Field **" x:120.0 y:150.0 width:315.0 height:30.0 fontSize:18 secure:NO capitalize:YES];
    
    [self addLabel:@"M.I.:" x:440 y:150 width:40 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    tf1 = [self addTextField:nil x:480 y:150.0 width:40.0 height:30.0 fontSize:18 secure:NO capitalize:YES];
    
    [self addLabel:@"Last Name:" x:20 y:200 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    tf2 = [self addTextField:nil x:120.0 y:200.0 width:400.0 height:30.0 fontSize:18 secure:NO capitalize:YES];
    
    [self addLabel:@"Username:" x:20 y:275 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    tf3 = [self addTextField:@"Required Field **" x:120 y:275 width:400.0 height:30.0 fontSize:18 secure:NO capitalize:NO];
    
    [self addLabel:@"Password:" x:20 y:325 width:100 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    tf4 = [self addTextField:@"Required Field **" x:120 y:325 width:400.0 height:30.0 fontSize:18 secure:YES capitalize:NO];
    
    [self addLabel:@"Is this an administrator account?" x:20 y:400 width:300 height:30 color:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft fontSize:18 isBold:NO];
    [self addSwitch:YES x:320 y:400 width:200 height:30];
    
    UIButton *button1 = [self addButton:@"Submit" x:50.0 y:550.0 width:200.0 height:50.0];
    [button1 addTarget:self action:@selector(confirmUser) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [self addButton:@"Cancel" x:(self.view.frame.size.width-250) y:550.0 width:200.0 height:50.0];
    [button2 addTarget:self action:@selector(menuAdminSettings) forControlEvents:UIControlEventTouchUpInside];
}

/*  The Edit Users Menu for updating users to or removing users from the users list  */
- (IBAction)menuAdminEdit {
    if([self.loginBackend.dataSrc count]==0){
        [self alertOneButton:@"Error" message:@"You must add users before you can use this feature." buttonTitle:@"Dismiss"];
        return;
    }
    
    [self openView:@"Update/Remove User"];
    
    sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,150,self.view.frame.size.width,50.0)];
    sBar.delegate = self;
    [self.view addSubview:sBar];
    [subviews addObject:sBar];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, 300)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    [self.view addSubview:myTableView];
    [subviews addObject:myTableView];
    
    srchedData = [[NSMutableArray alloc]init];
    tblData = [[NSMutableArray alloc]init];
    [tblData addObjectsFromArray:self.loginBackend.dataSrc];
    [tblData sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [myTableView reloadData];
    
    UIButton *button3 = [self addButton:@"Cancel" x:self.view.frame.size.width-160 y:550.0 width:150.0 height:50.0];
    [button3 addTarget:self action:@selector(menuAdminSettings) forControlEvents:UIControlEventTouchUpInside];
}

/*  Set up the User Settings Menu for admin user  */
- (IBAction)menuAdminSettings {
    [self openView:@"Settings"];
    
    srchedData = [[NSMutableArray alloc] init];
    
    UIButton *button1 = [self addButton:@"Add New User" x:(self.view.frame.size.width-250)/2 y:150.0 width:250.0 height:50.0];
    [button1 addTarget:self action:@selector(menuAdminAdd) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [self addButton:@"Update/Remove User" x:(self.view.frame.size.width-250)/2 y:250.0 width:250.0 height:50.0];
    [button2 addTarget:self action:@selector(menuAdminEdit) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [self addButton:@"Cancel" x:(self.view.frame.size.width-250)/2 y:350.0 width:250.0 height:50.0];
    [button3 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
}

/*  The Edit Users Menu for updating users to or removing users from the users list  */
- (void)menuAdminUpdate {
    //  UPDATE CODE
}

/*  Open adminView and set up properties  */
- (void)openView: (NSString*)title {
    [self clearScreen];
    
    [self addLabel:title x:0 y:50.0 width:self.view.frame.size.width height:50.0 color:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter fontSize:28 isBold:YES];
}

/*  The remove user prompt  */
- (IBAction)promptRemoveUser {
    [self alertTwoButtons:@"Remove User" message:[[NSString alloc] initWithFormat:@"Are you sure you want to delete %@?", [srchedData objectAtIndex:0]] firstButton:@"Remove" secondButton:@"Dismiss"];
}

/*  The update user prompt  */
- (IBAction)promptUpdateUser {
    [self alertTwoButtons:@"Update User" message:[[NSString alloc] initWithFormat:@"Are you sure you want to update %@?", [srchedData objectAtIndex:0]] firstButton:@"Update" secondButton:@"Dismiss"];
}

/*  Alert View responses  */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonPressedName isEqualToString:@"Okay"]){
        tf0.text = nil;
        tf1.text = nil;
        tf2.text = nil;
        tf3.text = nil;
        tf4.text = nil;
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
        if([[tf1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
            tf1.text = @"(empty)";
        
        if([[tf2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
            tf2.text = @"(empty)";
        
        if(isAdmin)
            tf2.text = [tf2.text stringByAppendingString:@" #*#"];
        
        NSString *text = [[NSString alloc]initWithFormat:@"%@ %@ %@ %@ %@", tf3.text,tf4.text,tf0.text,tf1.text,tf2.text];
        [self.loginBackend saveUser:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [self alertOneButton:@"User Added Successfully" message:nil buttonTitle:@"Okay"];
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
    sBar.text = cell.textLabel.text;
    NSLog(@"%@ Selected",cell.textLabel.text);

    for(NSString *row in self.loginBackend.dataSrc){
        NSRange r = [[row lowercaseString] rangeOfString:[cell.textLabel.text lowercaseString]];
        if(r.location != NSNotFound){
            NSArray *array = [row componentsSeparatedByString:@" "];
            [srchedData setObject:array atIndexedSubscript:0];
        }
    }
    
    UIButton *button1 = [self addButton:@"Update" x:10.0 y:550.0 width:150.0 height:50.0];
    [button1 addTarget:self action:@selector(promptUpdateUser) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [self addButton:@"Remove" x:170.0 y:550.0 width:150.0 height:50.0];
    [button2 addTarget:self action:@selector(promptRemoveUser) forControlEvents:UIControlEventTouchUpInside];
}

@end