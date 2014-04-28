//
//  ActiveUserTest.m
//  StemNotebook
//
//  Created by Keneequa Brown on 4/28/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "ActiveUserTest.h"
#import "ActiveUser.h"

@implementation ActiveUserTest

#pragma mark - helper methods

- (ActiveUser *)createUniqueInstance {
    
    return [[ActiveUser alloc] init];
    
}

- (ActiveUser *)getUserManager {
    
    return [ActiveUser userManager];
    
}

#pragma mark - tests

- (void)testSingletonUserManagerCreated {
    
    STAssertNotNil([self getUserManager],@"User Manager created is Nil");
    
}

- (void)testSingletonUniqueInstanceCreated {
    
   STAssertNotNil([self createUniqueInstance],@"Unique Instance of User Manager is Nil");
    
}

- (void)testSingletonReturnsSameUserManagerTwice {
    
    ActiveUser *s1 = [self getUserManager];
    STAssertEquals(s1, [self getUserManager],@"Same User returned twice");
    
}

- (void)testSingletonUserManagerSeparateFromUniqueInstance {
    
    ActiveUser *s1 = [self getUserManager];
    STAssertEquals(s1, [self createUniqueInstance],@"User Manager not separate from Unique Instance");
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    
    ActiveUser *s1 = [self createUniqueInstance];
    STAssertEquals(s1, [self createUniqueInstance],@"Does not return separate Unique Instance");
}

@end
