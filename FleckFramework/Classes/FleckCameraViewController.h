//
//  FleckCameraViewController.h
//  FleckFramework
//
//  Created by Muhammad Tayyab on 23/06/2019.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>

@protocol FleckCallBack
+(void) sendData:(NSString *)biometricTemplate finger:(NSString *)index ;
@end
@interface FleckCameraViewController : UIViewController <UIAlertViewDelegate, CvVideoCameraDelegate>
    @property (weak, nonatomic) IBOutlet UIImageView *img;
    @property (nonatomic, retain) NSString *cnicData;
    @property (nonatomic, retain) NSString *finger;
    @property (atomic) int *qualityThreash;
    @property (nonatomic, weak) id<FleckCallBack> delegate_;
@end

