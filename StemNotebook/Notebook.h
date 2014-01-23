//
//  Notebook.h
//  StemNotebook
//
//  Created by Jacob on 1/23/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintView.h"

@interface Notebook : NSObject
{
    NSMutableArray *book;
    PaintView *currentPage;
    int index;    
}

-(PaintView *) getCurrentPage;
-(PaintView *) pageFoward;
-(PaintView *) pageBack;
@end
