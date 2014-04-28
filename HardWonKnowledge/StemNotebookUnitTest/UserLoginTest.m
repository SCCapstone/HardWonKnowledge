//
//  UserLoginTest.m
//  StemNotebook
//
//  Created by KENEEQUA BROWN on 3/24/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "UserLoginTest.h"
#import "UserLoginViewController.h"

@implementation UserLoginTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testOpenUserLogin {
    UserLoginViewController *userLogin = [[UserLoginViewController alloc]init];
    STAssertNotNil(userLogin, @"Open of UserLoginViewController is nil");
}

- (void)testInstantiation {
    UserLoginViewController *userLogin = [[UserLoginViewController alloc]init];
    STAssertNotNil(userLogin, @"Test instance of UserLoginViewController is nil");
}

- (void)testSharedInstanceNotNil {
    UserLoginViewController *userLogin = [UserLoginViewController sharedInstance];
    STAssertNotNil(userLogin, @"sharedInstance of UserLoginViewController is nil");
}

- (void)testSharedInstanceReturnsSameSingletonObject {
    UserLoginViewController *userLogin1 = [UserLoginViewController sharedInstance];
    UserLoginViewController *userLogin2 = [UserLoginViewController sharedInstance];
    STAssertEquals(userLogin1, userLogin2, @"sharedInstance of UserLoginViewController didn't return same object twice");
}

@end
