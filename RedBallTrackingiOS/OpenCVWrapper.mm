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
#include <opencv2/highgui/cap_ios.h>

using namespace cv;
using namespace std;

@implementation OpenCVWrapper : NSObject

+ (UIImage *)processImageWithOpenCV:(UIImage*)inputImage
{
    Mat mat = [inputImage CVMat];
    
    // do your processing here
    return [UIImage imageWithCVMat:mat];
}


+ (void)setupVideoCamera:(UIView *) parentView
{
    CvVideoCamera* videoCamera;
}

@end