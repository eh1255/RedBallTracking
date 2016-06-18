//
//  OpenCVWrapper.m
//  RedBallTrackingiOS
//
//  Created by Erik Hornberger on 2016/06/18.
//  Copyright © 2016年 EExT. All rights reserved.
//

#include "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"

#include <opencv2/opencv.hpp>
#include <opencv2/videoio/cap_ios.h>

using namespace cv;
using namespace std;

@implementation OpenCVWrapper : NSObject

@synthesize videoHandler;
@synthesize videoCamera;

@synthesize hMin;
@synthesize hMax;
@synthesize sMin;
@synthesize sMax;
@synthesize vMin;
@synthesize vMax;

// This is how a singlegton is created in Objective-C
static OpenCVWrapper *sharedInstance = nil;
+ (OpenCVWrapper *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

// Initialize the variables
// hue is from 0 to 180, saturation and value go from 0 to 255
-(id) init {
    self = [super init];
    self.hMin = 0;
    self.sMin = 0;
    self.vMin = 0;
    self.hMax = 180;
    self.sMax = 255;
    self.vMax = 255;
    return self;
}

- (UIImage *)processImageWithOpenCV:(UIImage*)inputImage
{
    Mat image = [inputImage CVMat];
    
    // Convert to grayscale
    cvtColor(image, image, COLOR_BGR2GRAY);
    
    // Go float
    image.convertTo(image, CV_64FC1);
    
    Mat padded;                            //expand input image to optimal size
    int m = getOptimalDFTSize( image.rows );
    int n = getOptimalDFTSize( image.cols ); // on the border add zero values
    copyMakeBorder(image, padded, 0, m - image.rows, 0, n - image.cols, BORDER_CONSTANT, Scalar::all(0));
    
    Mat planes[] = {Mat_<float>(padded), Mat::zeros(padded.size(), CV_32F)};
    Mat complexI;
    merge(planes, 2, complexI);         // Add to the expanded another plane with zeros. complexI is the output array.
    
    dft(complexI, complexI);            // this way the result may fit in the source matrix
    
    // compute the magnitude and switch to logarithmic scale
    // => log(1 + sqrt(Re(DFT(I))^2 + Im(DFT(I))^2))
    split(complexI, planes);                   // planes[0] = Re(DFT(I), planes[1] = Im(DFT(I))
    magnitude(planes[0], planes[1], planes[0]);// planes[0] = magnitude
    Mat magI = planes[0];
    
    magI += Scalar::all(1);                    // switch to logarithmic scale
    log(magI, magI);
    
    // crop the spectrum, if it has an odd number of rows or columns
    magI = magI(cv::Rect(0, 0, magI.cols & -2, magI.rows & -2));
    
    // rearrange the quadrants of Fourier image  so that the origin is at the image center
    int cx = magI.cols/2;
    int cy = magI.rows/2;
    
    Mat q0(magI, cv::Rect(0, 0, cx, cy));   // Top-Left - Create a ROI per quadrant
    Mat q1(magI, cv::Rect(cx, 0, cx, cy));  // Top-Right
    Mat q2(magI, cv::Rect(0, cy, cx, cy));  // Bottom-Left
    Mat q3(magI, cv::Rect(cx, cy, cx, cy)); // Bottom-Right
    
    Mat tmp;                           // swap quadrants (Top-Left with Bottom-Right)
    q0.copyTo(tmp);
    q3.copyTo(q0);
    tmp.copyTo(q3);
    
    q1.copyTo(tmp);                    // swap quadrant (Top-Right with Bottom-Left)
    q2.copyTo(q1);
    tmp.copyTo(q2);
    
    normalize(magI, magI, 0, 1, CV_MINMAX); // Transform the matrix with float values into a
    
    return [UIImage imageWithCVMat:magI];
}


- (void)setupVideoCamera:(UIView *) parentView
{
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView: parentView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    
    self.videoHandler = [[VideoHandler alloc] init];
    self.videoCamera.delegate = self.videoHandler;
    [self.videoCamera start];
}


@end