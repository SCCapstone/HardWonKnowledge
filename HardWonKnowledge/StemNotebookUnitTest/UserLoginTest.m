//
//  UserLoginTest.m
//  StemNotebook
//
//  Created by KENEEQUA CHONTESE BROWN on 3/24/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "UserLoginTest.h"
#import "UserLoginViewController.h"

@implementation UserLoginTest

- (void)testBlankLogin{
    UserLoginViewController *userLogin = [[UserLoginViewController alloc]init];
    STAssertNotNil(userLogin, @"")
}

@end
