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

- (ActiveUser *)getSharedInstance {
    
    return [ActiveUser sharedInstance];
    
}

#pragma mark - tests

- (void)testSingletonSharedInstanceCreated {
    
    XCTAssertNotNil([self getSharedInstance]);
    
}

- (void)testSingletonUniqueInstanceCreated {
    
    XCTAssertNotNil([self createUniqueInstance]);
    
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    
    ActiveUser *s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
    
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    
    ActiveUser *s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    
    ActiveUser *s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

@end
