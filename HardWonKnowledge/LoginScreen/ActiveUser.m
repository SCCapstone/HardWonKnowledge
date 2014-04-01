//
//  ActiveUser.m
//  StemNotebook
//
//  Created by Keneequa Brown on 4/1/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "ActiveUser.h"

@implementation ActiveUser

@synthesize username;
@synthesize firstName;
@synthesize midInitial;
@synthesize lastName;
@synthesize folderId;

#pragma mark -
#pragma mark Singleton Methods
+ (id)userManager {
    static ActiveUser *theActiveUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theActiveUser = [[self alloc] init];
    });
    return theActiveUser;
}

- (id)init {
    if (self = [super init]) {
        username = @"Default Property Value";
        firstName = @"Default Property Value";
        midInitial = @"Default Property Value";
        lastName = @"Default Property Value";
        folderId = @"Default Property Value";
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
