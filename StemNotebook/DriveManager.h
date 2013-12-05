//
//  DriveManager.h
//  StemNotebook
//
//  Created by Colton Waters on 12/5/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "NotebookViewDelegate.h"
#import "GTLDrive.h"

@interface DriveManager : NSObject

@property (nonatomic, retain) GTLServiceDrive *driveService;

+ (DriveManager*) getDriveManager;

@end
