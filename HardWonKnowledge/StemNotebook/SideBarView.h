//
//  testView.h
//  StemNotebook
//
//  Created by Colton Waters and Jacob Wood on 11/1/13.
//  Copyright (c) 2013 HardWonKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotebookViewDelegate.h"

@interface SideBarView: UIView

@property (nonatomic, strong) id <NotebookViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *pageNumber;

-(void) changePageNumber:(NSString *)newNumber;
@end
