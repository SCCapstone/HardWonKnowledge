//
//  User.h
//  StemNotebook
//
//  Created by Colton Waters on 3/31/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSString *username;
@property NSString *firstName;
@property NSString *lastName;

-(User *)getCurrentUser;
-(NSString *)getFullName;

@end
