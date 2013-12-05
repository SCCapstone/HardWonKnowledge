//
//  NotebookViewDelegate.h
//  StemNotebook
//
//  Created by Colton Waters on 11/6/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NotebookViewDelegate <NSObject>

- (void)PaintViewButtonPressed;
- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen;
- (void)changeBrushWithNumber:(float)number;
- (void)showPaintSubmenu;
- (void)showMenuSubmenu;
- (void)encodePaintView;
- (void)decodePaintView;

@end
