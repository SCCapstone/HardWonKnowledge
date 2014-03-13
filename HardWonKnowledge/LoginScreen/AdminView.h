//
//  AdminView.h
//  StemNotebook
//
//  Created by Keneequa Brown on 3/5/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLoginBackend.h"
#import "BookshelfGridViewController.h"

@interface AdminView : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate, UITextViewDelegate>{
    UITextField *tf0;
    UITextField *tf1;
    UITextField *tf2;
    UITextField *tf3;
    UITextField *tf4;
    BOOL isAdmin;
}

- (UIButton*)addButton: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (UITextField*)addTextField: (NSString*)placeholder x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size secure:(BOOL)value capitalize:(BOOL)cap;
- (void)addTextView: (NSString*)text x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size;

- (void)addLabel: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color alignment:(UITextAlignment)align fontSize:(CGFloat)size isBold:(BOOL)bold;
- (void)addSwitch: (BOOL)useYes x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (void)alertOneButton: (NSString*)title message:(NSString*)mssg buttonTitle:(NSString*)btn;
- (void)alertTwoButtons: (NSString*)title message:(NSString*)mssg firstButton:(NSString*)btn1 secondButton:(NSString*)btn2;
- (void)changeSwitch:(id)sender;
- (void)clearScreen;
- (void)menuAdminAdd;
- (IBAction)menuAdminUpdate;
- (void)openView: (NSString*)title;
- (void)configUpdateUser;

- (IBAction)closeView;
- (IBAction)confirmUser;
- (IBAction)menuAdminEdit;
- (IBAction)menuAdminSettings;
- (IBAction)promptRemoveUser;
- (IBAction)promptUpdateUser;

@property (nonatomic, retain) UserLoginBackend *loginBackend;
@property (nonatomic,retain) NSMutableArray *subviews;
//@property (nonatomic,retain) NSMutableArray *texts;
@property (nonatomic,retain) NSMutableArray *srchedData;
@property (nonatomic,retain) NSMutableArray *tblData;
@property (nonatomic,retain) UISearchBar *sBar;
@property (nonatomic,retain) UITableView *myTableView;
@end
