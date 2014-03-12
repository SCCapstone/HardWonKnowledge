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
- (void)addLabel: (NSString*)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color alignment:(UITextAlignment)align fontSize:(CGFloat)size isBold:(BOOL)bold;
- (void)addSwitch;
- (UITextField*)addTextField: (NSString*)placeholder x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)size secure:(BOOL)value capitalize:(BOOL)cap;
- (void)addTextView;
- (void)alertOneButton: (NSString*)title message:(NSString*)mssg buttonTitle:(NSString*)btn;
- (void)alertTwoButtons: (NSString*)title message:(NSString*)mssg firstButton:(NSString*)btn1 secondButton:(NSString*)btn2;
- (void)clearScreen;
- (IBAction)confirmUser;
- (void)menuAdminAdd;
- (IBAction)menuAdminEdit;
- (IBAction)menuAdminSettings;
- (void)menuAdminUpdate;
- (void)openView: (NSString*)title;
- (IBAction)promptRemoveUser;
- (IBAction)promptUpdateUser;
//tap close keyboard
//dismisskeyboard to no

@property (nonatomic, retain) UserLoginBackend *loginBackend;
@property (nonatomic,retain) NSMutableArray *subviews;
@property (nonatomic,retain) NSMutableArray *texts;
@end
