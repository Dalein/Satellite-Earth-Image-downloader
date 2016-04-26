//
//  GISatelliteDownloader.m
//  SatelliteEarthImage
//
//  Created by Gnatyuk Ivan on 25.04.16.
//  Copyright © 2016 Gnatyuk Ivan. All rights reserved.
//

#import "GISatelliteDownloader.h"
#import "UIImage+CombinedImage.h"
#import "NSArray+Sorting.h"

static NSString * const kErrorDomain = @"GISatelliteDownloaderErrorDomain";

@implementation GISatelliteDownloader {
    NSOperationQueue *operationQueue;
    NSMutableArray *arrEarthImages;
    
    int totalDownloadImagesCount;
    int downloadImagesCount;
}

- (id)init {
    if (self = [super init]) {
        operationQueue = [[NSOperationQueue alloc] init];
        arrEarthImages = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)downloadEarthImage {
    NSLog(@"downloadEarthImage begin...");
    [arrEarthImages removeAllObjects];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd/HHmmss";
    
    NSDateFormatter *dtFormatterSatelliteInfo = [[NSDateFormatter alloc] init];
    dtFormatterSatelliteInfo.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // Config satellite request
    int width = 550;
    int numblocks = 4; //this apparently corresponds directly with the level, keep this exactly the same as level without the 'd'
    NSString *level = [NSString stringWithFormat:@"%dd", numblocks]; // Level can be 4d, 8d, 16d, 20d
    
    
    // Download images from server block
    void (^processSatelliteResponse)(NSData*) = ^(NSData* data) {
        NSError *error = nil;
        NSDictionary *dictParsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (!error) {
            NSDate *dateLastInfo = [dtFormatterSatelliteInfo dateFromString:dictParsedObject[@"date"]];
            
            NSString *timeStamp = [dateFormatter stringFromDate:dateLastInfo];
            NSString *baseURL = [NSString stringWithFormat:@"http://himawari8-dl.nict.go.jp/himawari8/img/D531106/%@/%d/%@", level,
                                 width, timeStamp];
            
            totalDownloadImagesCount = numblocks*numblocks;
            downloadImagesCount = totalDownloadImagesCount;
            
            // Create operations for downloading image parts
            for (int x = 0; x < numblocks; x++) {
                for (int y = 0; y < numblocks; y++) {
                    
                    NSString *thisURL = [NSString stringWithFormat:@"%@_%d_%d.png", baseURL, y, x];
                    NSURL *url = [NSURL URLWithString:thisURL];
                    
                    int pos = 10*x + y;
                    [self downloadImageWithURL:url atIndx:pos];
                }
            }
        }
        else {
            [self.delegate satelliteImageDownloadProgress:1.0];
            NSError *error = [NSError errorWithDomain:kErrorDomain code:100
                                userInfo:@{NSLocalizedDescriptionKey : @"Can't parse the data"}];
            [self.delegate satelliteImageLoaded:nil withError:error];
        }
    };
    
    // Get latest Satellite data info
    NSURL *url = [NSURL URLWithString:@"http://himawari8-dl.nict.go.jp/himawari8/img/D531106/latest.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (data) {
                                          processSatelliteResponse(data);
                                      } else {
                                          [self.delegate satelliteImageDownloadProgress:1.0];
                                          NSError *error = [NSError errorWithDomain:kErrorDomain code:100
                                                                           userInfo:@{NSLocalizedDescriptionKey : @"No latest data"}];
                                          [self.delegate satelliteImageLoaded:nil withError:error];
                                      }
                                  }];
    [task resume];
}

- (void)downloadImageWithURL:(NSURL *)url atIndx:(int)point {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                        completionHandler:
                                    ^(NSData *imageData, NSURLResponse *response, NSError *error) {
                                        if (imageData) {
                                            UIImage *image = [UIImage imageWithData:imageData];
                                            if (image) {
                                               //NSLog(@"Add image with pos: %d", point);
                                                [arrEarthImages addObject:@{@"pos" : @(point),
                                                                            @"image" : image
                                                                            }];
                                            }
                                            
                                            downloadImagesCount--;
                                            float progress =  1.0 - (float)downloadImagesCount/(float)totalDownloadImagesCount;
                                            [self.delegate satelliteImageDownloadProgress:progress];
                                            if (downloadImagesCount == 0) {
                                                [self.delegate satelliteImageLoaded:[self combineImage] withError:nil];
                                            }
                                        }
                                    }];
        [task resume];
}


- (UIImage *)combineImage {
        arrEarthImages = [[arrEarthImages sortArrayByObjectValue:@"pos" ascending:YES] mutableCopy];
        UIImage *imageFullEarth = [UIImage imageCombinedByImages:[arrEarthImages valueForKey:@"image"]
                                                andGridDimension:4];
       return imageFullEarth;
}


@end
