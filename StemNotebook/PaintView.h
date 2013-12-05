//
//  PaintView.h
//  StemNotebook
//
//  Created by Colton Waters on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView <NSCoding>

    @property CGPoint lastPoint;
    @property CGFloat red;
    @property CGFloat green;
    @property CGFloat blue;
    @property CGFloat brush;
    @property BOOL swipe;
    @property (strong, nonatomic) UIImageView *drawImage;


- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen;
- (void)changeBrushWithNumber:(float)number;
- (void)saveImageView;
- (void)loadImageView;

@end
