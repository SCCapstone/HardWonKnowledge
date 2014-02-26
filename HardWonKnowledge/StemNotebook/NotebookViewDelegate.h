//
//  NotebookViewDelegate.h
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 11/6/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NotebookViewDelegate <NSObject>

- (void)PaintViewButtonPressed;
- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen Alpha:(float)newAlpha;
- (void)changeBrushWithNumber:(float)newAlpha;



-(void)nextPage;
-(void)previousPage;




- (void)showPaintSubmenu;
- (void)showMenuSubmenu;
- (void)encodePaintView;
- (void)decodePaintView;
- (void)uploadButtonClicked;
- (void)loginButtonClicked;
- (void)logoutButtonClicked;

@end
