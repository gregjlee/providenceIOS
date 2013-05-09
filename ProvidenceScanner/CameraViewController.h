//
//  CameraViewController.h
//  CropImageSample
//
//  Created by Kishikawa Katsumi on 11/11/14.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CaptureManager.h"
@protocol CameraViewControllerDelegate<NSObject>
-(void)cameraControllerFinishedWithImage:(UIImage *)image;
@end
@interface CameraViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, CaptureManagerDelegate> {
    UIView *previewView;
    AVCaptureVideoPreviewLayer *previewLayer;
    CALayer *focusBox;
    CALayer *exposeBox;
    
    CaptureManager *captureManager;
    BOOL processingTakePhoto;
    id <CameraViewControllerDelegate> cameraDelegate;
}

@property (nonatomic, strong) CaptureManager *captureManager;
@property (nonatomic,assign)id<CameraViewControllerDelegate> cameraDelegate;
- (IBAction)shutterButtonPushed:(id)sender;
- (IBAction)photoAlbumButtonPushed:(id)sender;
- (void)drawFocusBoxAtPointOfInterest:(CGPoint)point;
- (void)drawExposeBoxAtPointOfInterest:(CGPoint)point;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *buttonContainerView;

@end
