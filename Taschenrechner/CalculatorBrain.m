//
//  CalculatorBrain.m
//  Taschenrechner
//
//  Created by Rincewind on 07.01.13.
//  Copyright (c) 2013 Rincewind. All rights reserved.
//




#import "CalculatorBrain.h"

@implementation CalculatorBrain

@synthesize waitingOperation;
@synthesize operand=_operand;
@synthesize memory;
@synthesize internalExpression;
@synthesize waitingOperand=_waitingOperand;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    internalExpression =[[NSMutableArray alloc]init];
    return self;
}



- (void)performWaitingOperation
{
    if ([@"+" isEqual:self.waitingOperation]) {
        _operand = _waitingOperand + self.operand;
    } else if ([@"-" isEqual:waitingOperation]) {
        _operand = self.waitingOperand - _operand;
    } else if ([@"*" isEqual:waitingOperation]) {
        _operand = _waitingOperand * _operand;
    } else if ([@"/" isEqual:waitingOperation]) {
        if (_operand) {
            _operand = _waitingOperand / _operand;
        }else _operand=NAN;
    }
}

- (double)performOperation:(NSString *)operation
{
    if ([operation isEqual:@"sqrt"]) {
        if(_operand>=0){
        _operand = sqrt(_operand);
        }else _operand=NAN;
    } else if ([operation isEqual:@"Pi"]) {
        _operand = M_PI;
    } else if ([operation isEqual:@"Store"]) {
        memory = _operand;
    } else if ([operation isEqual:@"Recall"]) {
        _operand = memory;
    } else if ([operation isEqual:@"Mem +"]) {
        memory += _operand;
    } else if ([operation isEqual:@"C"]) {
        _operand = 0;
        _waitingOperand = 0;
        waitingOperation = 0;
        memory = 0;
        [internalExpression removeAllObjects];
    } else if ([operation isEqual:@"+/-"]) {
        _operand = _operand * -1;
    } else if ([operation isEqual:@"1/x"]) {
        if (_operand != 0) {
            _operand = 1 / _operand;
        }else _operand=NAN;
    } else if ([operation isEqual:@"sin"]) {
        _operand = sin(_operand);
    } else if ([operation isEqual:@"cos"]) {
        _operand = cos(_operand);
    } else {
        [self performWaitingOperation];
        waitingOperation = operation;
        _waitingOperand = _operand;
    }
    
    if(![operation isEqual:@"C"])
        [internalExpression addObject:operation];
    
    return _operand;
}

-(void) setOperand:(double)anOperand{

    _operand =anOperand;
    
    [internalExpression addObject:[[NSNumber alloc] initWithDouble:anOperand]];
}

- (void)setVariableAsOperand:(NSString *)variableName{
    NSString *vp = @"%";
    vp=[vp stringByAppendingString:variableName];
    [internalExpression addObject:vp];
   
}

-(id) getExpression{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:internalExpression copyItems:YES];
    
    return newArray;
}

- (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables{
   
   
    CalculatorBrain *helper = [[CalculatorBrain alloc]init];
    
    for (id obj in anExpression) {
        
        if ([obj isKindOfClass:[NSNumber class]]){
            helper.operand = [obj doubleValue];
            
        }else if ([obj isKindOfClass:[NSString class]]){
            if([obj hasPrefix:@"%"]){
                NSString *sub = [obj substringFromIndex:1];
               
                helper.operand = [[variables objectForKey:sub] doubleValue];
            }else{
                helper.operand = [helper performOperation:obj];
            }
        
        }
    }
    
    return helper.operand;

}

- (NSSet *)variablesInExpression:(id)anExpression{
    
    NSMutableSet *set = [[NSMutableSet alloc]init];
    for (id obj in anExpression) {
        if ([obj isKindOfClass:[NSString class]]) {
            
            // if the string object is a variable that is marked by the sign '$'
            
            if ([obj rangeOfString:@"%"].location != NSNotFound) {
                NSString *sub = [obj substringFromIndex:1];
             
                [set addObject:sub];
            }
        }
    }
    return [set count]==0 ? nil:set;
}

- (NSString *)descriptionOfExpression:(id)anExpression{
    NSString *str = @"";
    
    for (id obj in anExpression) {
        str = [str stringByAppendingString:@" "];
        if ([obj isKindOfClass:[NSString class]]){
            if([obj characterAtIndex:0] == '%') {
                
                NSString *value = [obj substringFromIndex:1];
             
                str =[str stringByAppendingString:value];
            }else{
                NSString *value =obj;
              
                str = [str stringByAppendingString:value];
            }
            
        }else{
            
            NSString *value = [obj stringValue];
         
            str =[str stringByAppendingString:value];
            
        }         
    }
    
    return (str.length==0) ? nil:str;
}

+ (id)propertyListForExpression:(id)anExpression{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:anExpression copyItems:YES];
    return newArray;
}

+ (id)expressionForPropertyList:(id)propertyList{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:propertyList copyItems:YES];
    return newArray;
}



@end
