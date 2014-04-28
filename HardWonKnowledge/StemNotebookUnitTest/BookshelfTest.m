//
//  BookshelfTest.m
//  StemNotebook
//
//  Created by Keneequa Brown on 4/28/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "BookshelfTest.h"

@implementation BookshelfTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testOpenUserLogin {
    BookshelfGridViewController *bookshelf = [[BookshelfGridViewController alloc]init];
    STAssertNotNil(bookshelf, @"Open of BookshelfGridViewController is nil");
}

- (void)testInstantiation {
    BookshelfGridViewController *bookshelf = [[BookshelfGridViewController alloc]init];
    STAssertNotNil(bookshelf, @"Test instance of BookshelfGridViewController is nil");
}

- (void)testSharedInstanceNotNil {
    BookshelfGridViewController *bookshelf = [BookshelfGridViewController sharedInstance];
    STAssertNotNil(bookshelf, @"sharedInstance of BookshelfGridViewController is nil");
}

- (void)testSharedInstanceReturnsSameSingletonObject {
    BookshelfGridViewController *bookshelf1 = [BookshelfGridViewController sharedInstance];
    BookshelfGridViewController *bookshelf2 = [BookshelfGridViewController sharedInstance];
    STAssertEquals(bookshelf1, bookshelf2, @"sharedInstance of BookshelfGridViewController didn't return same object twice");
}

@end
