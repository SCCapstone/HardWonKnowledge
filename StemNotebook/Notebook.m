//
//  Notebook.m
//  StemNotebook
//
//  Created by Jacob on 1/23/14.
//  Copyright (c) 2014 HardWonKnowledge. All rights reserved.
//

#import "Notebook.h"
#import "PaintView.h"

@implementation Notebook

-(id)init
{
    self = [super init];
    index = 0;
    book = [NSMutableArray array];
    for(NSInteger i = 0; i < 25; i++)
    {
        PaintView *view = [[PaintView alloc] init];
        [book addObject:view];
    }
    return self;
}

-(PaintView *) getCurrentPage
{
    return [book objectAtIndex:index];
}

-(PaintView *) pageFoward
{
    index = (index+1);//%25;
    return [book objectAtIndex:index];
}

-(PaintView *) pageBack
{
    index = (index-1);
    if(index<0)
    {
        index = 24;
    }
    
    return [book objectAtIndex:index];
}

@end
