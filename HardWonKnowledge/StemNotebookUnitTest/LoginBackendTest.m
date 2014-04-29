//
//  LoginBackendTest.m
//  StemNotebook
//
//  Created by Keneequa Brown on 4/28/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "LoginBackendTest.h"

@implementation LoginBackendTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testOpenUserLogin {
    UserLoginBackend *backend = [[UserLoginBackend alloc]init];
    STAssertNotNil(backend, @"Open of UserLoginBackend is nil");
}

- (void)testInstantiation {
    UserLoginBackend *backend = [[UserLoginBackend alloc]init];
    STAssertNotNil(backend, @"Test instance of UserLoginBackend is nil");
}

- (void)testSharedInstanceNotNil {
    UserLoginBackend *backend = [UserLoginBackend sharedInstance];
    STAssertNotNil(backend, @"sharedInstance of UserLoginBackend is nil");
}

- (void)testSharedInstanceReturnsSameSingletonObject {
    UserLoginBackend *backend1 = [UserLoginBackend sharedInstance];
    UserLoginBackend *backend2 = [UserLoginBackend sharedInstance];
    STAssertEquals(backend1, backend2, @"sharedInstance of UserLoginBackend didn't return same object twice");
}

@end
