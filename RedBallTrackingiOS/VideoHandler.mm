//
//  VideoHandler.m
//  RedBallTrackingiOS
//
//  Created by Erik Hornberger on 2016/06/18.
//  Copyright © 2016年 EExT. All rights reserved.
//


# import "VideoHandler.h"
# import "OpenCVWrapper.h"

using namespace cv;

@implementation VideoHandler : NSObject

@synthesize showRaw; // This automatically creates getter and setter functions

// This happens as soon as the video handler is created, before anything else
-(id) init
{
    self = [super init];
    self->ovc = OpenCVWrapper.sharedInstance;
    self->pastResults.resize(30);
    self.showRaw = true;
    return self;
}


 - (void)processImage:(Mat &)image
{
    // This function has no return. We have to work on image where it sits in memory
    // To do that, we create a copy of it, modify the copy, and the overwrite image at the
    // same address in memory when we're done
    Mat workingCopy;
    image.copyTo(workingCopy);

    [self medianBlur:workingCopy];
    [self detectColor:workingCopy];
    [self erodeThenDilate:workingCopy];
    if (!showRaw) {
        workingCopy.copyTo(image);
    } else {
        [self contourAndDrawObjects:workingCopy drawOnto:image];
    }
}


# pragma mark - Filtering Functions



- (void)invertColors:(Mat &) image
{
    // Get a copy of the image and convert to BGR colorscale
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    // invert image and switch back to BGRA colorscale for display purposes
    bitwise_not(image_copy, image_copy);
    cvtColor(image_copy, image, CV_BGR2BGRA);
}






// Useful for removing noise
- (void)medianBlur:(Mat &) image
{
    medianBlur(image, image, 3);
}





// Extracts objects of a color specified by the current settings in OpenCVWrapper.sharedInstace
- (void)detectColor:(Mat &) image
{
    // Convert to HSV scale so that we can easily use hue to filter colors
    // Using hue, colors can be accurately filtered with just one parameter
    cvtColor(image, image, CV_BGR2HSV);
    
    // Now filter the hue saturation and value according to the current settings
    inRange(image, Scalar(ovc.hMin, ovc.sMin, ovc.vMin), Scalar(ovc.hMax, ovc.sMax, ovc.vMax),image);
    
}





// Used for removing tiny specs or holes
- (void)erodeThenDilate:(Mat &) image
{
    // Create a 3x3 blob to use as a kernel for eroding and an 8x8 for dilating
    Mat erodeElement  = getStructuringElement(MORPH_RECT, cv::Size(3,3));
    Mat dilateElement = getStructuringElement(MORPH_RECT, cv::Size(3,3));
    
    // Erode twice. This shrinks all outlines by about 6 pixels, erasing any small dicontinuous artifacts
    erode(image, image, erodeElement);
    erode(image, image, erodeElement);
    
    // Dilate twice. This has the opposite effect, filling in any holes within contours that we made worse by eroding
    dilate(image, image, dilateElement);
    dilate(image, image, dilateElement);
}







// Extract contours from thresholded image and draw circle on largest body
- (void)contourAndDrawObjects:(Mat &) image
                     drawOnto:(Mat &) canvas
{
    // Initailize two vectors to hold the output of findContours
    std::vector< std::vector<cv::Point> > contours;
    std::vector< Vec4i > hierarchy;
    std::vector<cv::Vec3f> circles;
    
    //find contours of filtered image using openCV findContours function
    findContours(image,contours,hierarchy,CV_RETR_CCOMP,CV_CHAIN_APPROX_SIMPLE );
    
    // Another possibility is to use a Hough Transform to pick out circular objects
    // https://solarianprogrammer.com/2015/05/08/detect-red-circles-image-using-opencv/
    
    //use moments method to find our filtered object
    double referenceArea = 0;
    bool   objectFound   = false;
    int    x = 0;
    int    y = 0;
    
    // If something is detected, calculate the area of each contour
    if (hierarchy.size() > 0) {
        for (int index = 0; index >= 0; index = hierarchy[index][0]) {
            
            Moments moment = moments(contours[index]);
            double  area   = moment.m00;
            
            // If the area is less than 20x20, then we'll going to count it as noise
            // We only want the one image contour with the biggest area, so save and compare with a refrence area
            if (area > referenceArea && area > 400) {
                x = moment.m10/area;
                y = moment.m01/area;
                objectFound   = true;
                referenceArea = area;
            }
        }
    }
    
    // If an object was detected, update the coordinates
    [ovc updateCoordinates:x screenCoordinates:y];
    
    
    // Update the running average
    // http://stackoverflow.com/questions/11567307/calculate-mean-for-vector-of-points
    for (int index = 30; index >= 1; index--) {
        pastResults[index] = pastResults[index-1];
    }
    pastResults[0] = cv::Point(x,y);
    
    cv::Mat meanPoint;
    cv::reduce(pastResults, meanPoint, 0, CV_REDUCE_AVG);
    cv::Point2f mean(meanPoint.at<float>(0), meanPoint.at<float>(1));
    
    // If an object was found, identify it by drawing a circle over it and adding text labels
    if (objectFound) {
        
        // Drawing a circle
        int radius = sqrt(referenceArea/(2*3.1415));
        circle(canvas, mean, radius, Scalar(255,255,255),10);
        
        // Drawing text
        std::string text   = "X:";
        text += std::to_string(x);
        text += " Y:";
        text += std::to_string(y);
        int fontFace  = FONT_HERSHEY_SIMPLEX;
        int fontScale = 2;
        int thickness = 3;
        cv::Point location(x - radius ,y - radius);
        cv::putText(canvas, text, location, fontFace, fontScale, Scalar(255, 255, 2525), thickness);
    }
    
    // Overwrite the data we've been processing on with the canvas so that it appears on screen
    canvas.copyTo(image);
}



#pragma mark - FIXME

// Fourier Transform
- (void)fft:(Mat &) image
{
    
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
}

@end