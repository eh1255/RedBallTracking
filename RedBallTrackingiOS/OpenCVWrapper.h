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

- (void)setupVideoCamera:(UIView*) parentView;
- (void)showProcessedImage:(bool) show;

// Filtering properties
@property (atomic, assign) NSInteger hMin;
@property (atomic, assign) NSInteger hMax;
@property (atomic, assign) NSInteger sMin;
@property (atomic, assign) NSInteger sMax;
@property (atomic, assign) NSInteger vMin;
@property (atomic, assign) NSInteger vMax;


#ifdef __cplusplus
@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property (nonatomic, retain) VideoHandler* videoHandler;
#endif

@end