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

@synthesize xCoord;
@synthesize yCoord;

@synthesize delegate;

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
    self.sMin = 100;
    self.vMin = 100;
    self.hMax = 15;
    self.sMax = 255;
    self.vMax = 255;

    return self;
}

- (void)showProcessedImage:(bool)show
{
    self.videoHandler.showRaw = !show;
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

- (void)updateCoordinates:(NSInteger)x screenCoordinates:(NSInteger)y
{
    self.xCoord = x;
    self.yCoord = y;
    [delegate targetCoordinatesChanged:x screenCoordinates:y];
}


@end