//
//  ViewController.h
//  Taschenrechner
//
//  Created by Rincewind on 27.12.12.
//  Copyright (c) 2012 Rincewind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface ViewController : UIViewController <UISplitViewControllerDelegate>{

GraphViewController *graph;
}

@property IBOutlet UITextField *calcScreen;
@property BOOL userIsTyping;
@property CalculatorBrain *brain;
@property (readonly) GraphViewController *graph;




- (IBAction) numberPressed: (id) sender;
- (IBAction) operationPressed: (id) sender;
- (IBAction) afterDot;
- (IBAction) variablePressed:(id)sender;
- (IBAction) graphPressed:(id)sender;

@end
