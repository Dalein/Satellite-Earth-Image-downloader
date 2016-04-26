//
//  UIImage+CombinedImage.m
//  TestProject
//
//  Created by Gnatyuk Ivan on 25.04.16.
//  Copyright © 2016 Gnatyuk Ivan. All rights reserved.
//

#import "UIImage+CombinedImage.h"

@implementation UIImage (CombinedImage)

+ (UIImage *)imageCombinedByImages:(NSArray *)arrImages andGridDimension:(int)itemInRow {
    
    NSUInteger imageCount = arrImages.count;
    
    UIImage *image0 = [arrImages firstObject];
    CGSize sizeImage = CGSizeMake(image0.size.width, image0.size.height); //Assume all images has same size
    CGSize sizeFinal = CGSizeMake(itemInRow * image0.size.width, itemInRow * image0.size.height);
    
    UIGraphicsBeginImageContext(sizeFinal);

    for (int indx = 0; indx < imageCount; indx++) {
        UIImage *image = arrImages[indx];
        float posX = sizeImage.width * (indx % itemInRow);
        float posY = sizeImage.height * (indx / itemInRow); 
        [image drawInRect:CGRectMake(posX, posY, sizeImage.width, sizeImage.height)];
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

@end
