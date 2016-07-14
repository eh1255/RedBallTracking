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

@protocol TargetUpdateDelegate
@required
-(void) targetCoordinatesChangedRED:(NSInteger)xCoord screenCoordinates:(NSInteger)yCoord;
-(void) targetCoordinatesChangedBLUE:(NSInteger)xCoord screenCoordinates:(NSInteger)yCoord;
-(void) targetCoordinatesChangedYELLOW:(NSInteger)xCoord screenCoordinates:(NSInteger)yCoord;
@end


@interface OpenCVWrapper : NSObject

// This is a singleton for providing global access to the OpenCV Wrapper
+ (OpenCVWrapper *)sharedInstance;

- (void)setupVideoCamera:(UIView*) parentView;
- (void)showProcessedImage:(bool) show;
- (void)updateCoordinates:(NSInteger)x screenCoordinates:(NSInteger)y colorIndex:(NSInteger)index;

// Filtering properties for red
@property (atomic, assign) NSInteger hMin1;
@property (atomic, assign) NSInteger hMax1;
@property (atomic, assign) NSInteger sMin1;
@property (atomic, assign) NSInteger sMax1;
@property (atomic, assign) NSInteger vMin1;
@property (atomic, assign) NSInteger vMax1;

// Filtering properties for blue
@property (atomic, assign) NSInteger hMin2;
@property (atomic, assign) NSInteger hMax2;
@property (atomic, assign) NSInteger sMin2;
@property (atomic, assign) NSInteger sMax2;
@property (atomic, assign) NSInteger vMin2;
@property (atomic, assign) NSInteger vMax2;

// Filtering properties for yellow
@property (atomic, assign) NSInteger hMin3;
@property (atomic, assign) NSInteger hMax3;
@property (atomic, assign) NSInteger sMin3;
@property (atomic, assign) NSInteger sMax3;
@property (atomic, assign) NSInteger vMin3;
@property (atomic, assign) NSInteger vMax3;

// Last know coordinates
@property (atomic, assign) NSInteger xCoordRED;
@property (atomic, assign) NSInteger yCoordRED;

@property (atomic, assign) NSInteger xCoordBLUE;
@property (atomic, assign) NSInteger yCoordBLUE;

@property (atomic, assign) NSInteger xCoordYELLOW;
@property (atomic, assign) NSInteger yCoordYELLOW;

@property (nonatomic, weak) id<TargetUpdateDelegate> delegate;

#ifdef __cplusplus
@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property (nonatomic, retain) VideoHandler* videoHandler;
#endif

@end