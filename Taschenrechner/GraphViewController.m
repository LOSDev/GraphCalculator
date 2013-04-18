//
//  GraphViewController.m
//  Taschenrechner
//
//  Created by Rincewind on 11.01.13.
//  Copyright (c) 2013 Rincewind. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController () 

@end

@implementation GraphViewController

@synthesize graphD;
@synthesize expression;
@synthesize dictionary;
@synthesize graphSwitch;
@synthesize functionLabel;
@synthesize functionText;
@synthesize toolBar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [toolBar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        toolBar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [graphSwitch setOn:NO];
    self.title=@"Graph";
   
    graphD.scale=19.0;
    [self drawGraph];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)zoomOut:(id)sender {
    if(graphD.scale>1){
        graphD.scale=graphD.scale-3;
        [graphD setNeedsDisplay];
    }
}

- (IBAction)zoomIn:(id)sender {
    graphD.scale=graphD.scale+3;
    [graphD setNeedsDisplay];
}

- (IBAction)switched:(id)sender {
    if(graphSwitch.on) graphD.graphLine=YES;
    else graphD.graphLine=NO;
    [graphD setNeedsDisplay];
}

-(void) drawGraph{
    functionLabel.text=functionText;
    if(graphSwitch.on) graphD.graphLine=YES;
    else graphD.graphLine=NO;
    graphD.expression=self.expression;
    graphD.dictionary=[[NSMutableDictionary alloc]initWithDictionary:self.dictionary copyItems:YES];
    [graphD setNeedsDisplay];
    

}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender {
    CGFloat newScale = sender.scale*10;
    if (newScale>1) {
        graphD.scale=(int)newScale;
        [graphD setNeedsDisplay];
    }
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
        if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded)) {
        graphD.origin = CGPointMake(graphD.origin.x+[sender translationInView:graphD].x, graphD.origin.y+[sender translationInView:graphD].y);
        [sender setTranslation:CGPointMake(0.0, 0.0) inView:graphD];
        
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        graphD.origin = [sender locationInView:graphD];
    }
}

@end
