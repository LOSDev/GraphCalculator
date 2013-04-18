//
//  CalculatorBrain.h
//  Taschenrechner
//
//  Created by Rincewind on 07.01.13.
//  Copyright (c) 2013 Rincewind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject 
@property (nonatomic)double operand;
@property NSString *waitingOperation;
@property (nonatomic)double waitingOperand;
@property (nonatomic)double memory;
@property (readonly) id expression;
@property NSMutableArray *internalExpression;
@property NSDictionary *variables;


- (void)setOperand:(double)anOperand;
- (double)performOperation:(NSString *)operation;
- (void)setVariableAsOperand:(NSString *)variableName;
- (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables;
- (NSSet *)variablesInExpression:(id)anExpression;
- (NSString *)descriptionOfExpression:(id)anExpression;
+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
