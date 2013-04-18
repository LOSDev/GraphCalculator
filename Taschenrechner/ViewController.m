//
//  ViewController.m
//  Taschenrechner
//
//  Created by Rincewind on 27.12.12.
//  Copyright (c) 2012 Rincewind. All rights reserved.
//

#import "ViewController.h"
#import "GraphViewController.h"
#import "SplitViewBarButtonItemPresenter.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize brain=_brain;
@synthesize calcScreen;
@synthesize userIsTyping;



//set instance variables
-(void)awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;

}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

-(BOOL)splitViewController:(UISplitViewController *)svc
  shouldHideViewController:(UIViewController *)vc
             inOrientation:(UIInterfaceOrientation)orientation{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}
-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc{

    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
    

}

- (GraphViewController *)graph
{
	if (!graph) graph = [[GraphViewController alloc] init];
	return graph;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.brain = [[CalculatorBrain alloc] init];
    self.title=@"Calculator";
       
    if ([self iPad]) {
        graph = [self.splitViewController.viewControllers lastObject];
        [graph viewDidLoad];
        
    }   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Display the new number on the screen depending on the nachKomma variable
- (IBAction) numberPressed: (id) sender{
    NSString *number = [NSString stringWithFormat:@"%d",[sender tag]];
    if(userIsTyping){
       calcScreen.text = [calcScreen.text stringByAppendingString:number];
       
    }else{
        calcScreen.text=number;
        userIsTyping=YES;
    }
}

//set the operation selected
- (IBAction) operationPressed: (id) sender{
    NSString *operation = [[sender titleLabel] text];
    [self performOperationWithString:operation];
}


-(void) showMessage:(NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                message:message
                delegate:self
                cancelButtonTitle:@"OK"
                otherButtonTitles:nil];
    [alert show];

}


//sets a point if there is none already in the display
- (IBAction) afterDot{
    if ([calcScreen.text rangeOfString:@"."].location == NSNotFound && userIsTyping==YES) {
        NSString *komma = @".";
        calcScreen.text = [calcScreen.text stringByAppendingString:komma];
    }else if (userIsTyping==NO){
        calcScreen.text = @"0.";
        userIsTyping=YES;
    }
}

- (IBAction)variablePressed:(id)sender {
    [self.brain setVariableAsOperand: [[sender titleLabel] text]];
    calcScreen.text = [self.brain descriptionOfExpression:self.brain.internalExpression];
}


- (BOOL)iPad{
    
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (IBAction)graphPressed:(id)sender {
    
           
    if (userIsTyping){
        double screenNumber =[calcScreen.text doubleValue];
        [self.brain.internalExpression addObject:[NSNumber numberWithDouble:screenNumber]];
        userIsTyping=NO;
    }
    
    [self deleteEquals];
    [self.brain.internalExpression addObject:@"="];
    NSString *stringOfExpression = [self.brain descriptionOfExpression:self.brain.internalExpression];
    graph.functionText=stringOfExpression;
    graph.expression = self.brain.internalExpression;
    
    [graph drawGraph];
    
}

-(GraphViewController *) splitViewGraphViewController{
    id helper= [self.splitViewController.viewControllers lastObject];
    if (![helper isKindOfClass:[GraphViewController class]]){
        helper = nil;
    }
    return helper;
}

-(void) deleteEquals{
    
    NSMutableArray *expr =[NSMutableArray arrayWithArray:self.brain.internalExpression];
    for (int i=0;i<[expr count];i++){
        if ([expr[i] isKindOfClass:[NSString class]]){
            if ([expr[i] isEqualToString:@"="]){
                [expr removeObject:expr[i]];
            }
        }
    }
    self.brain.internalExpression=expr;

}

-(void)performOperationWithString:(NSString *) op{
    if (userIsTyping) {
        self.brain.operand=[calcScreen.text doubleValue];
        userIsTyping = NO;
    }
    
    double result = [self.brain performOperation:op];
   
    if([self.brain variablesInExpression:self.brain.internalExpression] ==nil){
        calcScreen.text=[NSString stringWithFormat:@"%g", result];
    }else{
        NSString *txt = [self.brain descriptionOfExpression:self.brain.internalExpression];
        calcScreen.text=txt;
    }

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"graphSegue"]) {
        if (userIsTyping){
            double screenNumber =[calcScreen.text doubleValue];
            [self.brain.internalExpression addObject:[NSNumber numberWithDouble:screenNumber]];
            userIsTyping=NO;
        }
        graph = [segue destinationViewController];
        [self deleteEquals];
        [self.brain.internalExpression addObject:@"="];
        NSString *stringOfExpression = [self.brain descriptionOfExpression:self.brain.internalExpression];
        graph.functionText=stringOfExpression;
        graph.expression = self.brain.internalExpression;
        
    }

}




@end
    
