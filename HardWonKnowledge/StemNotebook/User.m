//
//  User.m
//  StemNotebook
//
//  Created by Colton Waters on 3/31/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize username;
@synthesize firstName;
@synthesize lastName;

//Get the uninitialized current user, then initialize variables based on correct data. **Should work**
-(User *)getCurrentUser
{
    static User *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[User alloc]init];
    });
    return currentUser;
}


-(NSString *)getFullName
{
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    return fullName;
}
@end
