//
//  PaintViewTest.m
//  StemNotebook
//
//  Created by JACOB MICHAEL WOOD on 3/24/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "PaintViewTest.h"
#import "PaintView.h"

@implementation PaintViewTest

- (void)testPageTurn
{
    PaintView *testView = [[PaintView alloc]init];
    
    [testView previousPage];
    STAssertEquals(testView.current, 0, @"Page turned past start");
    
    for(int i = 0; i < 30; i++)
    {
        [testView nextPage];
    }
    STAssertEquals(testView.current, 24, @"Page turned past end");
}


- (void)testChangeMode
{
    PaintView *testView = [[PaintView alloc]init];
    
    [testView changeMode:paintMode];
    STAssertEquals(testView.submenuMode, paintMode, @"Paint Mode Not Entered");
    
    [testView changeMode:textMode];
    STAssertEquals(testView.submenuMode, textMode, @"Text Mode Not Entered");
    
    [testView changeMode:cameraMode];
    STAssertEquals(testView.submenuMode, cameraMode, @"Camera Mode Not Entered");
    
    [testView changeMode:menuMode];
    STAssertEquals(testView.submenuMode, menuMode, @"Menu Mode Not Entered");
    
    [testView changeMode:1000];
    STAssertEquals(testView.submenuMode, menuMode, @"Invaild Mode Entered");
}



@end
