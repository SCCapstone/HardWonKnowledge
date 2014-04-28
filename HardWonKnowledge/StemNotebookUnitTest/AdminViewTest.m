//
//  AdminViewTest.m
//  StemNotebook
//
//  Created by Keneequa Brown on 4/28/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "AdminViewTest.h"

@implementation AdminViewTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testOpenUserLogin {
    AdminView *admin = [[AdminView alloc]init];
    STAssertNotNil(admin, @"Open of AdminView is nil");
}

- (void)testInstantiation {
    AdminView *admin = [[AdminView alloc]init];
    STAssertNotNil(admin, @"Test instance of AdminView is nil");
}

- (void)testSharedInstanceNotNil {
    AdminView *admin = [AdminView sharedInstance];
    STAssertNotNil(admin, @"sharedInstance of AdminView is nil");
}

- (void)testSharedInstanceReturnsSameSingletonObject {
    AdminView *admin1 = [AdminView sharedInstance];
    AdminView *admin2 = [AdminView sharedInstance];
    STAssertEquals(admin1, admin2, @"sharedInstance of AdminView didn't return same object twice");
}
@end
