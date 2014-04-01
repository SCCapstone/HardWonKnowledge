//
//  ActiveUser.h
//  StemNotebook
//
//  Created by Keneequa on 4/1/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveUser : NSObject{
    NSString *username;
    NSString *firstName;
    NSString *midInitial;
    NSString *lastName;
    NSString *folderId;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *midInitial;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *folderId;

+ (id)userManager;

@end
