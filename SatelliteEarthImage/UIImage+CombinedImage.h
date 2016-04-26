//
//  UIImage+CombinedImage.h
//  TestProject
//
//  Created by Gnatyuk Ivan on 25.04.16.
//  Copyright © 2016 Gnatyuk Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CombinedImage)

+ (UIImage *)imageCombinedByImages:(NSArray *)arrImages andGridDimension:(int)itemInRow;

@end
