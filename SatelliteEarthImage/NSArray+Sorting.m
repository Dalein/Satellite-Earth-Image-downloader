//
//  NSArray+Sorting.m
//  RationalApe
//
//  Created by Gnatyuk Ivan on 08.04.16.
//  Copyright © 2016 daleijn. All rights reserved.
//

#import "NSArray+Sorting.h"

@implementation NSArray (Sorting)

- (NSArray *)sortArrayByObjectValue:(NSString *)objVal ascending:(BOOL)ascending {
    
    NSComparisonResult currentComparison1 = ascending ? NSOrderedDescending : NSOrderedAscending;
    NSComparisonResult currentComparison2 = ascending ? NSOrderedAscending : NSOrderedDescending;
    
    NSArray *sortedArray = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1[objVal] floatValue] > [obj2[objVal] floatValue])
            return currentComparison1;
        else if ([obj1[objVal] floatValue] < [obj2[objVal] floatValue])
            return currentComparison2;
        return NSOrderedSame;
    }];
    
    return sortedArray;
}

@end
