# Satellite Earth Image downloader 
![Earth](https://raw.githubusercontent.com/Dalein/Satellite-earth-image-downloader/master/Earth.jpg)
Fetch realtime (more or less) Earth photo from Japanese weather satellite [Himawari8](https://en.wikipedia.org/wiki/Himawari_8).  

#Example
Just init SatelliteDownloader object and call ```downloadEarthImage```. It has two delegate methods for handling events.
```objectivec
GISatelliteDownloader *satDownloader = [[GISatelliteDownloader alloc] init];
satDownloader.delegate = self;
    
#pragma satelliteDownloader  Delegate

- (void)satelliteImageLoaded:(UIImage *)image withError:(NSError *)error {
    if (error) {
       NSLog(@"Error: %@", error);
    }
    else {
       dispatch_async(dispatch_get_main_queue(), ^{
       _imageView.image = imageToSet;   
       });
    }
}

- (void)satelliteImageDownloadProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
       _progressLine.progress = progress;
    });
}
```

#Usage
Copy GISatelliteDownloader folder into your project.

# License 
Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:

 If you happen to meet one of the copyright holders in a bar you are obligated
 to buy them one pint of beer.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
