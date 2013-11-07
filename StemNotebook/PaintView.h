//
//  PaintView.h
//  StemNotebook
//
//  Created by Colton Waters on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView
{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    BOOL swipe;
    UIImageView *drawImage;
}

@end
