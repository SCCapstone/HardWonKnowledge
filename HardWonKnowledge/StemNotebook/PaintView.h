//
//  PaintView.h
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView <NSCoding>

    @property CGPoint lastPoint;
    @property CGFloat red;
    @property CGFloat green;
    @property CGFloat blue;
    @property CGFloat alpha;
    @property CGFloat brush;
    @property BOOL swipe;
    @property (strong, nonatomic) UIImageView *drawImage;
    @property (strong, nonatomic) UILabel *drawLabel;
@property (strong, nonatomic) UIImageView *pasteImage;
@property (strong, nonatomic) UIImage *imageAdd;
    @property (strong, nonatomic) NSMutableArray *pages;
    @property (nonatomic) int current;
    @property (strong, nonatomic) UITextField *drawField;
    @property (strong,nonatomic) NSString *textAdd;
    @property (nonatomic) int submenuMode;
@property (nonatomic, strong) NSString *notebookName;

    


- (void)changeColorWithRed:(float)newRed Blue:(float)newBlue Green:(float)newGreen Alpha:(float)newAlpha;
- (void)changeBrushWithNumber:(float)number;
- (void)changeText:(NSString*)text;
- (void)changeImage:(UIImage*)image;
- (void)changeAlphaWithNumber:(float)newAlpha;
- (void)changeMode:(int)newMode;
- (void)saveImageView;
- (void)loadImageView;
- (void)loadFileNamed:(NSString *)name atPath:(NSString *)path;
- (void)saveFileNamed:(NSString *)name;
- (void)nextPage;
- (void)previousPage;
-(void)textMerged;
-(void)createImageView:(UIImage *)image AtX:(int) xcord AtY:(int) ycord;
- (void)mergeImage;

extern const int paintMode;
extern const int textMode;
extern const int cameraMode;
extern const int menuMode;


@end
