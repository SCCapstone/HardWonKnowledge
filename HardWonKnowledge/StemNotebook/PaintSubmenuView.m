//
//  PaintSubmenuView.m
//  StemNotebook
//
//  Created by Jacob Wood on 11/3/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import "PaintSubmenuView.h"

@implementation PaintSubmenuView

@synthesize delegate;
@synthesize redBtn;
@synthesize blueBtn;
@synthesize yellowBtn;
@synthesize blackBtn;
@synthesize greenBtn;
@synthesize purpleBtn;
@synthesize orangeBtn;
@synthesize brownBtn;
@synthesize eraseBtn;
@synthesize buttons;


//initialized in code, so initWithFrame is used
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView *paintSubmenuViewIB = [[[NSBundle mainBundle] loadNibNamed:@"PaintSubmenuView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:paintSubmenuViewIB];
        
        buttons = [NSArray arrayWithObjects:redBtn, blueBtn, yellowBtn, blackBtn, greenBtn, purpleBtn, orangeBtn, brownBtn, eraseBtn, nil];
        blackBtn.selected = YES;
    }
    return self;
}


- (IBAction)Red:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:0 Green:0 Alpha:1];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
    

}

- (IBAction)Blue:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:255 Green:0 Alpha:1.0];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}
- (IBAction)Green:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:0 Green:255 Alpha:1.0];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}
- (IBAction)Black:(id)sender {
    [self.delegate changeColorWithRed:0 Blue:0 Green:0 Alpha:1.0];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}

- (IBAction)White:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:255 Green:255 Alpha:1.0];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}

- (IBAction)Yellow:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:0 Green:255 Alpha:1.0];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}

- (IBAction)Purple:(id)sender {
    [self.delegate changeColorWithRed:255 Blue:255 Green:0 Alpha:1.0];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}

- (IBAction)Orange:(id)sender {
    CGFloat red, green, blue, alpha;
    UIColor* color = [UIColor orangeColor];
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    [self.delegate changeColorWithRed:red Blue:blue Green:green Alpha:alpha];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}

- (IBAction)Brown:(id)sender {
    CGFloat red, green, blue, alpha;
    UIColor* color = [UIColor brownColor];
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    [self.delegate changeColorWithRed:red Blue:blue Green:green Alpha:alpha];
    
    for(UIButton *button in buttons)
    {
        if(button == sender)
        {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}




- (IBAction)Small:(id)sender {
    [self.delegate changeBrushWithNumber:2.5];
}
- (IBAction)Normal:(id)sender {
    [self.delegate changeBrushWithNumber:10];
}

- (IBAction)Large:(id)sender {
    [self.delegate changeBrushWithNumber:30];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
