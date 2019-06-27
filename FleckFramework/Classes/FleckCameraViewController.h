//
//  FleckCameraViewController.h
//  FleckFramework
//
//  Created by AKSA SDS on 23/06/2019.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FleckCallBack
+(void) sendData:(NSString *)biometricTemplate finger:(NSString *)index ;
@end
@interface FleckCameraViewController : UIViewController
    @property (weak, nonatomic) IBOutlet UIImageView *img;
    @property (nonatomic, retain) NSString *cnicData;
    @property (nonatomic, retain) NSString *finger;
    @property (nonatomic, retain) NSString *contact;
    @property (atomic) int *qualityThreash;
    @property (nonatomic, weak) id<FleckCallBack> delegate_;
@end

NS_ASSUME_NONNULL_END
