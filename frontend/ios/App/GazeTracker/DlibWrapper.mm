#import "DlibWrapper.h"
#import <UIKit/UIKit.h>

#include <dlib/image_processing.h>
#include <dlib/image_io.h>

#include <dlib/opencv.h>
#include <cmath>
#include <opencv2/opencv.hpp>
#include "base64.hpp"

void rotate(cv::Mat& src, double angle, cv::Mat& dst){
    cv::Point2f ptCp(src.cols*0.5, src.rows*0.5);
    cv::Mat M = cv::getRotationMatrix2D(ptCp, angle, 1.0);
    cv::warpAffine(src, dst, M, src.size(), cv::INTER_CUBIC); //Nearest is too rough,
}

@implementation Ratios

- (instancetype) initWithLeftGaze:(double)leftGaze_ rightGaze:(double)rightGaze_ leftBlink:(double)leftBlink_ rightBlink:(double)rightBlink_ leftImg:(NSString*)leftImg_ rightImg:(NSString*)rightImg_ {

    self = [super init];

    if (self) {
        self.leftGaze = leftGaze_;
        self.rightGaze = rightGaze_;
        self.leftBlink = leftBlink_;
        self.rightBlink = leftBlink_;
        self.leftImg = leftImg_;
        self.rightImg = rightImg_;
    }
    return self;
}

@end


@interface DlibWrapper ()

@property (assign) BOOL prepared;

+ (std::vector<dlib::rectangle>)convertCGRectValueArray:(NSArray<NSValue *> *)rects;

@end
@implementation DlibWrapper {
    dlib::shape_predictor sp;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _prepared = NO;
    }
    return self;
}

- (void)prepare {
    NSString *modelFileName = [[NSBundle mainBundle] pathForResource:@"shape_predictor_68_face_landmarks" ofType:@"dat"];
    std::string modelFileNameCString = [modelFileName UTF8String];
    
    dlib::deserialize(modelFileNameCString) >> sp;
    
    // FIXME: test this stuff for memory leaks (cpp object destruction)
    self.prepared = YES;
}

- (Ratios*)doWorkOnSampleBuffer:(CMSampleBufferRef)sampleBuffer inRects:(NSArray<NSValue *> *)rects {
    
    if (!self.prepared) {
        [self prepare];
    }
    
    dlib::array2d<dlib::bgr_pixel> img;
    
    // MARK: magic
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);

    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    char *baseBuffer = (char *)CVPixelBufferGetBaseAddress(imageBuffer);
    
    // set_size expects rows, cols format
    img.set_size(height, width);
    
    // copy samplebuffer image data into dlib image format
    img.reset();
    long position = 0;
    double leftGaze = 0;
    double rightGaze = 0;
    double leftBlink = 0;
    double rightBlink = 0;
    std::string leftImg = "";
    std::string rightImg = "";
    while (img.move_next()) {
        dlib::bgr_pixel& pixel = img.element();

        // assuming bgra format here
        long bufferLocation = position * 4; //(row * width + column) * 4;
        char b = baseBuffer[bufferLocation];
        char g = baseBuffer[bufferLocation + 1];
        char r = baseBuffer[bufferLocation + 2];
        //        we do not need this
        //        char a = baseBuffer[bufferLocation + 3];
        
        dlib::bgr_pixel newpixel(b, g, r);
        pixel = newpixel;
        
        position++;
    }
    
    dlib::array2d<unsigned char> img_gray;
    dlib::assign_image(img_gray, img);
    
    cv::Mat gray = dlib::toMat(img_gray);
    
    // unlock buffer again until we need it again
    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    
    // convert the face bounds list to dlib format
    std::vector<dlib::rectangle> convertedRectangles = [DlibWrapper convertCGRectValueArray:rects];
    
    // for every detected face
    for (unsigned long j = 0; j < convertedRectangles.size(); ++j)
    {
        dlib::rectangle oneFaceRect = convertedRectangles[j];
        
        // detect all landmarks
        dlib::full_object_detection shape = sp(img, oneFaceRect);
        {
            std::vector<uchar> tmp;
            leftGaze = [(id) self gazeRatio:true:gray:shape:tmp];
            std::string tmp2(tmp.begin(), tmp.end());
            leftImg = macaron::Base64::Encode(tmp2);
        }
        {
            std::vector<uchar> tmp;
            rightGaze = [(id) self gazeRatio:false:gray:shape:tmp];
            std::string tmp2(tmp.begin(), tmp.end());
            rightImg = macaron::Base64::Encode(tmp2);
        }
        
        
        leftBlink = [(id) self blinkRatio:true:gray:shape];
//        rightBlink= [(id) self blinkRatio:false:gray:shape];
        // and draw them into the image (samplebuffer)
        for (unsigned long k = 0; k < shape.num_parts(); k++) {
            dlib::point p = shape.part(k);
            draw_solid_circle(img, p, 15, dlib::rgb_pixel(0, 255, 255));
        }
        
        
    }
    
    // lets put everything back where it belongs
    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    // copy dlib image data back into samplebuffer
    img.reset();
    position = 0;
    while (img.move_next()) {
        dlib::bgr_pixel& pixel = img.element();
        
        // assuming bgra format here
        long bufferLocation = position * 4; //(row * width + column) * 4;
        baseBuffer[bufferLocation] = pixel.blue;
        baseBuffer[bufferLocation + 1] = pixel.green;
        baseBuffer[bufferLocation + 2] = pixel.red;
        //        we do not need this
        //        char a = baseBuffer[bufferLocation + 3];
        
        position++;
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    auto oleftImg = [NSString stringWithUTF8String:leftImg.c_str()];
    auto orightImg = [NSString stringWithUTF8String:rightImg.c_str()];
    return [[Ratios alloc]initWithLeftGaze:leftGaze rightGaze:rightGaze leftBlink:leftBlink rightBlink:rightBlink leftImg:oleftImg rightImg:orightImg];
}

+ (std::vector<dlib::rectangle>)convertCGRectValueArray:(NSArray<NSValue *> *)rects {
    std::vector<dlib::rectangle> myConvertedRects;
    for (NSValue *rectValue in rects) {
        CGRect rect = [rectValue CGRectValue];
        long left = rect.origin.x;
        long top = rect.origin.y;
        long right = left + rect.size.width;
        long bottom = top + rect.size.height;
        dlib::rectangle dlibRect(left, top, right, bottom);

        myConvertedRects.push_back(dlibRect);
    }
    return myConvertedRects;
}

- (float)gazeRatio:(bool)left:(cv::Mat&)gray:(dlib::full_object_detection&)landmarks:(std::vector<uchar>&)buff {
    auto mask = cv::Mat(gray.rows, gray.cols, CV_8UC1);
    std::vector<cv::Point> contour;
    auto addpoint = ([&](int i) {
        contour.push_back(cv::Point(landmarks.part(i).x(), landmarks.part(i).y()));
    });
    
    if (left) {
        auto pts = std::vector<int>({36,37,38,39,40,41});
        std::for_each(pts.begin(), pts.end(), [&](int i){addpoint(i);});
    } else {
        auto pts = std::vector<int>({42, 43, 44, 45, 46, 47});
        std::for_each(pts.begin(), pts.end(), [&](int i){addpoint(i);});
    }
    
    const cv::Point *pts = (const cv::Point*) cv::Mat(contour).data;
    int npts = cv::Mat(contour).rows;
    double dx = contour[3].x - contour[0].x;
    double dy = contour[3].y - contour[0].y;
    if (dx == 0) dx = 0.0000000001;
    double m = dy / dx;
    auto pi = acos(-1);
    double t = atan(m);
    if (dx < 0) t = pi - t;
    double angle = (t * 180 / pi);
    cv::polylines(mask, &pts, &npts, 1, true, 255, 2);
    cv::fillPoly(mask, &pts, &npts, 1, 255);
    auto eye = cv::Mat(gray.rows, gray.cols, CV_8UC1);
    cv::bitwise_and(gray, gray, eye, mask);
    auto min_x = std::max_element(contour.begin(), contour.end(), [](cv::Point p, cv::Point p2){return p.x > p2.x;})->x;
    auto max_x = std::max_element(contour.begin(), contour.end(), [](cv::Point p, cv::Point p2){return p.x < p2.x;})->x;
    auto min_y = std::max_element(contour.begin(), contour.end(), [](cv::Point p, cv::Point p2){return p.y > p2.y;})->y;
    auto max_y = std::max_element(contour.begin(), contour.end(), [](cv::Point p, cv::Point p2){return p.y < p2.y;})->y;
    auto gray_eye = eye(cv::Rect(cv::Point(min_x, min_y), cv::Point(max_x, max_y)));
    auto threshold_eye = cv::Mat(gray_eye.rows, gray_eye.cols, CV_8UC1);
    cv::threshold(gray_eye, threshold_eye, 50, 255, cv::THRESH_BINARY);
    cv::Mat final_eye;
    rotate(threshold_eye, angle, final_eye);
    auto width = final_eye.cols;
    auto height = final_eye.rows;
    auto left_side_threshold = final_eye(cv::Rect(cv::Point(0, 0), cv::Point(int(width / 2), height)));
    auto left_side_white = cv::countNonZero(left_side_threshold);
    
    auto right_side_threshold = final_eye(cv::Rect(cv::Point(int(width / 2),0), cv::Point(width, height)));
    auto right_side_white = cv::countNonZero(right_side_threshold);
    cv::Mat out_eye;
    cv::resize(final_eye, out_eye, cv::Size(), 5, 5);
    std::vector<int> param(2);
    param[0] = cv::IMWRITE_JPEG_QUALITY;
    param[1] = 80;//default(95) 0-100
    
    cv::imencode(".png", out_eye, buff, param);
    return left_side_white / float(left_side_white + right_side_white + 1);
}

- (double)blinkRatio:(bool)left:(cv::Mat&)gray:(dlib::full_object_detection&)landmarks {
    
    cv::Point left_point;
    cv::Point right_point;
    cv::Point center_top;
    cv::Point center_bottom;
    
    auto midpoint = [](dlib::point p1, dlib::point p2) {
        return cv::Point(int((p1.x() + p2.x())/2), int((p1.y() + p2.y())/2));
    };
    
    if (left) {
        left_point = cv::Point(landmarks.part(36).x(), landmarks.part(36).y());
        right_point = cv::Point(landmarks.part(39).x(), landmarks.part(39).y());
        center_top = midpoint(landmarks.part(37), landmarks.part(37));
        center_bottom = midpoint(landmarks.part(41), landmarks.part(41));
    } else {
        left_point = cv::Point(landmarks.part(42).x(), landmarks.part(42).y());
        right_point = cv::Point(landmarks.part(45).x(), landmarks.part(45).y());
        center_top = midpoint(landmarks.part(43), landmarks.part(43));
        center_bottom = midpoint(landmarks.part(47), landmarks.part(47));
    }
    
    
    auto hor_line_lenght = std::hypot((left_point.x - right_point.x), (left_point.y - right_point.y));
    auto ver_line_lenght = std::hypot((center_top.x - center_bottom.x), (center_top.y - center_bottom.y));
    
    return hor_line_lenght / (ver_line_lenght+1);
}

@end
