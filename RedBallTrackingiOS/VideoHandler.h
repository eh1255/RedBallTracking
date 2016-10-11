//
//  VideoHandler.h
//  RedBallTrackingiOS
//
//  Created by Erik Hornberger on 2016/06/18.
//  Copyright © 2016年 EExT. All rights reserved.
//

#include <opencv2/opencv.hpp>
#include <opencv2/videoio/cap_ios.h>
#include <opencv2/imgproc.hpp>

@class OpenCVWrapper;

@interface VideoHandler:NSObject<CvVideoCameraDelegate> {
    OpenCVWrapper *ovc;  // Reference to sharedInstance for getting filtering parameters
    std::vector<cv::Point2f> pastResults; // Used for averaging results over time
}

// The other functions can be combined inside of process Image
- (void)processImage:(cv::Mat &)image;

// These are all functions that can be combined to process video or images
- (void)fft:(cv::Mat &)image;
- (void)invertColors:(cv::Mat &)image;
- (void)medianBlur:(cv::Mat &)imag;
- (void)detectColor:(cv::Mat &)image
         colorIndex:(NSInteger)index;
- (void)erodeThenDilate:(cv::Mat &)image;
- (void)contourAndDrawObjects:(cv::Mat &)image
                     drawOnto:(cv::Mat &)canvas
                   colorIndex:(NSInteger)index;

// Determines if the raw output is showing or if makers are draw over original
// Properties accessed from outside the class have to be setup this way
@property (nonatomic, assign) NSInteger rawSelection;

@end