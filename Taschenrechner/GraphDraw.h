//
//  GraphDraw.h
//  Taschenrechner
//
//  Created by Rincewind on 11.01.13.
//  Copyright (c) 2013 Rincewind. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GraphDraw : UIView

@property CGFloat scale;

@property CGRect graphBounds;
@property CGPoint axisOrigin;
@property NSMutableArray *expression;
@property NSMutableDictionary *dictionary;
@property BOOL graphLine;

@property CGPoint origin;
-(void)setOrigin:(CGPoint)origin;
@end
