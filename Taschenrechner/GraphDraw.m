//
//  GraphDraw.m
//  Taschenrechner
//
//  Created by Rincewind on 11.01.13.
//  Copyright (c) 2013 Rincewind. All rights reserved.
//

#import "GraphDraw.h"
#import "AxesDrawer.h"
#import "GraphViewController.h"
#import "CalculatorBrain.h"

@implementation GraphDraw


@synthesize scale;
@synthesize expression;
@synthesize dictionary;
@synthesize graphLine;

@synthesize graphBounds;

@synthesize origin=_origin;


-(void)setOrigin:(CGPoint)origin {
    if (!CGPointEqualToPoint(origin, _origin)) {
        _origin = origin;
        
        [self setNeedsDisplay];
    }
}

-(CGPoint)origin {
    if (CGPointEqualToPoint(_origin, CGPointZero)) {
        
        if (CGPointEqualToPoint(_origin, CGPointZero)) {
            _origin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        }
    }
    return _origin;
}

-(void)setup {
    self.contentMode = UIViewContentModeRedraw;
}


-(void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGFloat screenDensity = [self contentScaleFactor];
    
    CalculatorBrain *brain = [[CalculatorBrain alloc]init];
    graphBounds= self.bounds;
   
    CGFloat start =self.origin.x-graphBounds.size.width/2;
    CGPoint point = CGPointZero;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor]CGColor]);
    [AxesDrawer drawAxesInRect:graphBounds originAtPoint:self.origin scale:scale];
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor]CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor redColor]CGColor]);
    CGContextBeginPath(context);
   
    NSMutableArray * xValues =[[NSMutableArray alloc]init];
    for (float i=(0-start); i<(graphBounds.size.width-start)*screenDensity;i+=1){
        
        if (i>0-start) CGContextMoveToPoint(context, point.x/screenDensity, point.y/screenDensity);
        float x= (i-(graphBounds.size.width/2.0))/scale;
        
        [dictionary setObject:[NSNumber numberWithFloat:x] forKey:@"x"];
        
        float xCoord =i;
        xCoord+=self.origin.x-graphBounds.size.width/2;
        
        
        float y=[brain evaluateExpression:self.expression usingVariableValues:dictionary];
        CGFloat yc =y;
        if (yc == NAN || yc == INFINITY || yc == -INFINITY)
            continue;
        
        float yCoord = graphBounds.size.height/2-y*scale;
        yCoord+=self.origin.y-graphBounds.size.height/2;;
        
        [xValues addObject:[NSNumber numberWithFloat:yCoord]];
        point = CGPointMake(xCoord, yCoord);
        if (!graphLine) CGContextFillRect(context, CGRectMake((point.x-1)/screenDensity,(point.y-1)/screenDensity,2/screenDensity,2/screenDensity));
        

        if(i>0-start && graphLine) CGContextAddLineToPoint(context, point.x/screenDensity, point.y/screenDensity);
        
    }
    if (graphLine) CGContextStrokePath(context);
}



@end
