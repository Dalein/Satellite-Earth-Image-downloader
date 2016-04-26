//
//  UIView+Extension.m
//  My DayLog
//
//  Created by Gnatyuk Ivan on 22.02.16.
//  Copyright © 2016 daleijn. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)addCornerBorderWithColor:(nonnull UIColor *)color {
    [self addCornerBorderWithColor:color andRadius:3.0];
}

- (void)addCornerBorderWithColor:(nonnull UIColor *)color andRadius:(float)radius {
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = color.CGColor;
}

@end
