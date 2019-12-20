#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@interface Ratios : NSObject

@property (assign) double leftGaze;
@property (assign) double rightGaze;
@property (assign) double leftBlink;
@property (assign) double rightBlink;
@property (strong, nonatomic) NSString* leftImg;
@property (strong, nonatomic) NSString* rightImg;

- (instancetype) initWithLeftGaze:(double)leftGaze_ rightGaze:(double)rightGaze_ leftBlink:(double)leftBlink_ rightBlink:(double)rightBlink_ leftImg:(NSString*)leftImg_ rightImg:(NSString*)rightImg_;

@end

@interface DlibWrapper : NSObject

- (instancetype)init;
- (Ratios*)doWorkOnSampleBuffer:(CMSampleBufferRef)sampleBuffer inRects:(NSArray<NSValue *> *)rects;
- (void)prepare;

@end
