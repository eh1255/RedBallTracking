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

@synthesize hMin1;
@synthesize hMax1;
@synthesize sMin1;
@synthesize sMax1;
@synthesize vMin1;
@synthesize vMax1;

@synthesize hMin2;
@synthesize hMax2;
@synthesize sMin2;
@synthesize sMax2;
@synthesize vMin2;
@synthesize vMax2;

@synthesize hMin3;
@synthesize hMax3;
@synthesize sMin3;
@synthesize sMax3;
@synthesize vMin3;
@synthesize vMax3;

@synthesize xCoordRED;
@synthesize yCoordRED;

@synthesize xCoordBLUE;
@synthesize yCoordBLUE;

@synthesize xCoordYELLOW;
@synthesize yCoordYELLOW;

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
    
    // Initialize RED filters
    self.hMin1 = 0;
    self.sMin1 = 100;
    self.vMin1 = 100;
    self.hMax1 = 15;
    self.sMax1 = 255;
    self.vMax1 = 255;
    
    // Initialize BLUE filters
    self.hMin2 = 185;
    self.sMin2 = 100;
    self.vMin2 = 100;
    self.hMax2 = 260;
    self.sMax2 = 255;
    self.vMax2 = 255;
    
    // Initialize YELLOW filters
    self.hMin3 = 50;
    self.sMin3 = 100;
    self.vMin3 = 100;
    self.hMax3 = 70;
    self.sMax3 = 255;
    self.vMax3 = 255;

    return self;
}

- (void)showProcessedImage:(NSInteger)selection
{
    self.videoHandler.rawSelection = selection;
}


- (void)setupVideoCamera:(UIView *) parentView
{
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView: parentView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetLow;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 10;
    self.videoCamera.grayscaleMode = NO;
    self.videoHandler = [[VideoHandler alloc] init];
    self.videoCamera.delegate = self.videoHandler;
    
    [self.videoCamera start];
}

- (void)updateCoordinates:(NSInteger)x screenCoordinates:(NSInteger)y colorIndex:(NSInteger)index
{
    if (index == 0) {
        self.xCoordRED = x;
        self.yCoordRED = y;
        [delegate targetCoordinatesChangedRED:x screenCoordinates:y];
        
    } else if (index == 1) {
        self.xCoordBLUE = x;
        self.yCoordBLUE = y;
        [delegate targetCoordinatesChangedBLUE:x screenCoordinates:y];
        
    } else if (index == 2) {
        self.xCoordYELLOW = x;
        self.yCoordYELLOW = y;
        [delegate targetCoordinatesChangedYELLOW:x screenCoordinates:y];
    }
}


@end