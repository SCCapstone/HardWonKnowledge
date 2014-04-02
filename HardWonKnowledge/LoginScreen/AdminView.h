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
    BOOL isAdmin;
}

- (void)addButton: (NSInteger)index title:(NSString*)title action:(SEL)action x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (void)addTextField: (NSInteger)index placeholder:(NSString*)placeholder x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size secure:(BOOL)value capitalize:(BOOL)cap;
- (void)addTextView: (NSInteger)index text:(NSString*)text x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size editable:(BOOL)edit;

- (void)addLabel: (NSInteger)index title:(NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color alignment:(UITextAlignment)align fontSize:(CGFloat)size isBold:(BOOL)bold;
- (void)addSwitch: (NSInteger)index isOn:(BOOL)isOn x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (void)alertOneButton: (NSString*)title message:(NSString*)mssg buttonTitle:(NSString*)btn;
- (void)alertTwoButtons: (NSString*)title message:(NSString*)mssg firstButton:(NSString*)btn1 secondButton:(NSString*)btn2;
- (void)changeSwitch:(id)sender;
- (void)clearScreen;
- (void)configUpdateUser;
- (void)confirmUserInsertion: (NSString*)method;
- (void)menuAdminAdd;
- (void)openView: (NSString*)title;
- (void)submitAddedUser;
- (void)submitUpdatedUser;

- (IBAction)closeView;
- (IBAction)menuAdminEdit;
- (IBAction)menuAdminSettings;
- (IBAction)menuAdminUpdate;
- (IBAction)promptAddUser;
- (IBAction)promptRemoveUser;
- (IBAction)promptUpdateUser;

@property (nonatomic, retain) UserLoginBackend *loginBackend;
@property (nonatomic,retain) NSMutableArray *subviews;
@property (nonatomic,retain) NSMutableArray *savedText;
@property (nonatomic,retain) NSMutableArray *srchedData;
@property (nonatomic,retain) NSMutableArray *tblData;
@property (nonatomic,retain) UISearchBar *sBar;
@property (nonatomic,retain) UITableView *myTableView;
@end
