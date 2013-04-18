//
//  GraphViewController.h
//  Taschenrechner
//
//  Created by Rincewind on 11.01.13.
//  Copyright (c) 2013 Rincewind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphDraw.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>


@property (weak, nonatomic) IBOutlet GraphDraw *graphD;
@property (weak, nonatomic) IBOutlet UISwitch *graphSwitch;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property NSMutableArray *expression;
@property NSDictionary *dictionary;
@property NSString *functionText;

- (IBAction)zoomOut:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)switched:(id)sender;
- (void) drawGraph;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;
- (IBAction)handleTap:(UITapGestureRecognizer *)sender;

@end
