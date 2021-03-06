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
- (void)changeBrushWithNumber:(float)number;
- (void)changeText:(NSString*)text;
- (void)changeMode:(int)newMode;
- (void)textMerged;
- (void)nextPage;
- (void)previousPage;
- (void)changeAlphaWithNumber:(float)newAlpha;
- (void)showPaintSubmenu;
- (void)showMenuSubmenu;
- (void)showTypeSubmenu;
- (void)showCameraSubmenu;
- (void)encodePaintView;
- (void)decodePaintView;
- (void)uploadButtonClicked;
- (void)loginButtonClicked;
- (void)logoutButtonClicked;
- (void)backButtonClicked;
- (void)importButtonClicked;
- (void)cameraButtonClicked;
- (void)pasteButtonClicked;
- (void)saveFileNamed:(NSString *)name;
- (void)doneButtonPressed;
- (void)changePageNumber:(NSString *) newNumber;

@end
