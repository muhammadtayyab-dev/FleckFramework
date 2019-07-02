//
//  FleckCameraViewController.m
//  FleckFramework
//
//  Created by AKSA SDS on 23/06/2019.
//

#import "FleckCameraViewController.h"
std::vector<std::vector<cv::Point>> templateContour;
std::vector<cv::Vec4i> hierarchy;
int templateMaxValue=0;
double matchedFinger=0;
double hsvColorDifference=0;
int SIDE = 512;
Boolean isNadaraCall=false;
Boolean isRight = false;
@interface FleckCameraViewController()
{
    CvVideoCamera *camera;
    cv::Mat mRgba;
    cv::Mat mGray;
    cv::Scalar mBlobColorRgba;
    cv::Scalar mBlobColorHsv;
    cv::Scalar mBlobColorHsv_;
    //ColorBlobDetector *_detector;
    cv::Mat templateImage;
    cv::Mat save_tip_roi;
    cv::Mat matRgb;
    double minimumValue,maximumValue;
   // CvVideoCamera* camera;
}
@end

@implementation FleckCameraViewController
@synthesize delegate_;
- (void)viewDidLoad {
    [super viewDidLoad];
    camera = [[CvVideoCamera alloc] initWithParentView: _img];
    //  [view     (backgroundImageView)]
    [self.view sendSubviewToBack:self.img];
    [self addBottomLayout];
    camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
    camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    camera.defaultFPS = 30;
    camera.grayscaleMode = NO;
    camera.delegate = self;
    isNadaraCall= true;
    mRgba = cv::Mat(camera.imageHeight,camera.imageWidth,CV_8UC4);
    mGray = cv::Mat(camera.imageHeight,camera.imageWidth,CV_8UC1);
  //  _detector = [[ColorBlobDetector alloc]init];
    mBlobColorRgba=cv::Scalar(255);
    mBlobColorHsv=cv::Scalar(255);
    mBlobColorHsv_=cv::Scalar(255);
   // [_detector setColorRadius:cv::Scalar(30,70,70,0)];
    UIImage *imageTemplate = [UIImage imageNamed:@"templete.jpg"];
  //  UIImageToMat(imageTemplate,templateImage);
    cv::Mat testImage=templateImage.clone();
    cv::cvtColor(testImage, testImage, cv::COLOR_RGB2HSV);
   // templateImage = [self featureMatching:templateImage];
    cv::Mat bw,bw1,bwfinal;
    cv::inRange(testImage, cv::Scalar(0 , 10 ,160), cv::Scalar(20,160,255), bw);
    cv::inRange(testImage, cv::Scalar(147 , 10 ,160), cv::Scalar(180,160,255), bw1);
    cv::add(bw, bw1, bwfinal);
    cv::findContours(bwfinal, templateContour, hierarchy, CV_RETR_TREE, cv::CHAIN_APPROX_SIMPLE,cv::Point(0,0));
    double maxVal=0;
    
    for(int i=0; i< templateContour.size(); i++){
        double contourArea=cv::contourArea(templateContour[i]);
        if(maxVal < contourArea){
            maxVal = contourArea;
            templateMaxValue = i;
        }
    }
}
-(void) setUpCamera{
    AVCaptureDevice *device =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if(device){
        [device lockForConfiguration:nil];
        if([self.finger  isEqual: @"6"] || [self.finger isEqual: @"1"]){
            if([device isExposurePointOfInterestSupported]){
                [device setExposurePointOfInterest:CGPointMake(0.25, 0.25)];
            }
        }
        
        device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
        [device setFocusModeLockedWithLensPosition:0.1 completionHandler:^(CMTime syncTime) {
            //      //do something
        }];
        [device setExposureMode:AVCaptureExposureModeCustom];
        float minISO =  [[device activeFormat] minISO];
        float maxISO =  [[device activeFormat] maxISO];
        float clampedISO = 0.05 * (maxISO - minISO) + minISO;
        [device setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:clampedISO completionHandler:^(CMTime syncTime) {
            //do something
        }];
        /* if(![device isExposureModeSupported:AVCaptureExposureModeCustom]){
         [device setExposureMode:AVCaptureExposureModeCustom];
         float lowOne =  [[device activeFormat] minISO];
         float high =  [[device activeFormat] maxISO];
         if(lowOne <= 80 && high>=80){
         [device setExposureModeCustomWithDuration:CMTimeMake(1, 1000) ISO: 80 completionHandler:nil];
         }else if(lowOne <= 120 && high>=120){
         [device setExposureModeCustomWithDuration:CMTimeMake(1, 1000) ISO: 120 completionHandler:nil];
         }else{
         [device setExposureModeCustomWithDuration:CMTimeMake(1, 1000) ISO: lowOne completionHandler:nil];
         }
         }else{
         // [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
         
         }*/
        //  [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        if([device hasTorch] && [device hasFlash]){
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setTorchModeOnWithLevel:1.0 error:nil];
            [device setFlashMode:AVCaptureFlashModeOn];
        }
        if([device isFocusPointOfInterestSupported]){
            [device setFocusPointOfInterest:CGPointMake(0.25, 0.25)];
            [device setFocusModeLockedWithLensPosition:0.4 completionHandler:nil];
        }
        if([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //  [device setExposureTargetBias:2.2 completionHandler:nil];
        if([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]){
            [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        
        [device unlockForConfiguration];
    }
    
}-(void) addBottomLayout{
    
    UIView *bottomView = [[UIView alloc]init];
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView setTranslatesAutoresizingMaskIntoConstraints:false];
    //  [topView setBackgroundColor:UIColor.grayColor];
    //[bottomView backgroundColor:UIColor.blackColor];
    //[self->loading sendSubviewToBack:topView];
   
    [bottomView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:bottomView];
    [bottomView setBackgroundColor:UIColor.whiteColor];
    
    
    
    //adding a progressview inside bottom view
   
    
    UIImageView *instruction =[[UIImageView alloc] init];
    instruction.image = [UIImage imageNamed:@"instruction"];
    [instruction.heightAnchor constraintEqualToConstant:150].active = true;
    [instruction.widthAnchor constraintEqualToConstant:180].active = true;
    
    UITextView *textView = [[UITextView alloc]init];
    textView.userInteractionEnabled = NO;
    textView.textColor = UIColor.blackColor;
    [textView setFont:    [UIFont boldSystemFontOfSize:8]];
    textView.text = @"1. Place your finger at a distance behind phone such that It appears in the boundary.\n2. Ensure that the background behind your finger is plane or light colored.\n3.Please use all 4 possible finger type options (left index, right index, left thumb, right thumb) for attempting biometric verification.\n4.Please rotate your device horizontally in case of providing thumb impression.";
    [textView.heightAnchor constraintEqualToConstant:100].active = true;
    [textView.widthAnchor constraintEqualToConstant:300].active = true;
    
    
    
    //Stack View
    UIStackView *stackView = [[UIStackView alloc] init];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 5;
    [stackView addArrangedSubview:textView];
    [stackView addArrangedSubview:instruction];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [bottomView addSubview:stackView];
    [stackView.centerXAnchor constraintEqualToAnchor:bottomView.centerXAnchor].active = true;
    [stackView.centerYAnchor constraintEqualToAnchor:bottomView.centerYAnchor].active = true;
    
    
    
    //bottom layout Set
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:bottomView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0f constant:0.f];
    
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:bottomView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0f constant:0.f];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:bottomView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:0.55 constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:bottomView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f constant:0.f];
    
    
    [self.view addConstraint:trailing];
    [self.view addConstraint:bottom];
    [self.view addConstraint:leading];
    [self.view addConstraint:height];
    //,,
    
    
    //top view
    
    //bottom layout Set
    
    trailing = [NSLayoutConstraint constraintWithItem:topView
                                            attribute:NSLayoutAttributeTrailing
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:self.view
                                            attribute:NSLayoutAttributeTrailing
                                           multiplier:1.0f constant:0.f];
    
    
    leading = [NSLayoutConstraint constraintWithItem:topView
                                           attribute:NSLayoutAttributeLeading
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.view
                                           attribute:NSLayoutAttributeLeading
                                          multiplier:1.0f constant:0.f];
    
    height = [NSLayoutConstraint constraintWithItem:topView
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1.0f constant:0];
    
    bottom = [NSLayoutConstraint constraintWithItem:topView
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:0.4 constant:0];
    
    
    [self.view addConstraint:trailing];
    [self.view addConstraint:bottom];
    [self.view addConstraint:leading];
    [self.view addConstraint:height];
}

-(void) viewDidAppear:(BOOL)animated{
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    [UINavigationController attemptRotationToDeviceOrientation];
    [camera start];
    [self setUpCamera];
    
}
@end
