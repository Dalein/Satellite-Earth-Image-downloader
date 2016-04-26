//
//  ViewController.m
//  SatelliteEarthImage
//
//  Created by Gnatyuk Ivan on 25.04.16.
//  Copyright © 2016 Gnatyuk Ivan. All rights reserved.
//

#import "ViewController.h"
#import "GISatelliteDownloader.h"
#import "UIView+Extension.h"

@interface ViewController () <SatelliteDownloaderDelegate>

@end

@implementation ViewController {
    GISatelliteDownloader *satDownloader;
    UIImage *imageEarth;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    satDownloader = [[GISatelliteDownloader alloc] init];
    satDownloader.delegate = self;
    [_btnStartDownload addCornerBorderWithColor:[UIColor whiteColor]];
}


#pragma satelliteDownloader  Delegate

- (void)satelliteImageLoaded:(UIImage *)image withError:(NSError *)error {
    
    UIImage *imageToSet = nil;
    if (error) {
       NSLog(@"Error: %@", error);
       imageToSet = [UIImage imageNamed:@"downloadErrorIco"];
    }
    else {
        imageEarth = image;
        imageToSet = imageEarth;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = imageToSet;
        
        _btnStartDownload.enabled = YES;
        [_btnStartDownload setTitle:@"Start download" forState:UIControlStateNormal];
    });
}

- (void)satelliteImageDownloadProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
       _progressLine.progress = progress;
    });
}


#pragma IBActions

- (IBAction)startDownloading:(id)sender {
    _progressLine.progress = 0.0;
    _btnStartDownload.enabled = NO;
    [_btnStartDownload setTitle:@"in progress..." forState:UIControlStateNormal];
    
   [satDownloader downloadEarthImage];
}

- (IBAction)saveToCameraRoll:(id)sender {
    if (imageEarth) {
        UIImageWriteToSavedPhotosAlbum(imageEarth,
                                       self,
                                       @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:),
                                       NULL);
    }
    else {
        NSLog(@"No image yet");
    }
}


#pragma UIImageWriteToSavedPhotosAlbum handler

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        NSLog(@"Error saving to camera roll: %@", error.localizedDescription);
    } else {
        NSLog(@"Photo has been saved!");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
