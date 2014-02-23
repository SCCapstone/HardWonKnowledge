//
//  AppDelegate.h
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 10/27/13.
//  Modified by Keneequa Brown on 2/23/14.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Bookshelf/Classes/UserLoginViewController.h"
@class UserLoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UserLoginViewController *viewController;

@end
