//
//  Header.h
//  RedBallTrackingiOS
//
//  Created by Erik Hornberger on 2016/06/18.
//  Copyright © 2016年 EExT. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/videoio/cap_ios.h>
#import "VideoHandler.h"
#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface OpenCVWrapper : NSObject

// This is a singleton for providing global access to the OpenCV Wrapper
+ (OpenCVWrapper *)sharedInstance;

- (UIImage *)processImageWithOpenCV:(UIImage*)inputImage;
- (void)setupVideoCamera:(UIView*) parentView;

// Filtering properties
@property (nonatomic, assign) NSInteger hMin;
@property (nonatomic, assign) NSInteger hMax;
@property (nonatomic, assign) NSInteger sMin;
@property (nonatomic, assign) NSInteger sMax;
@property (nonatomic, assign) NSInteger vMin;
@property (nonatomic, assign) NSInteger vMax;


#ifdef __cplusplus
@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property (nonatomic, retain) VideoHandler* videoHandler;
#endif

@end