//
//  AddViewController.h
//  ProvidenceScanner
//
//  Created by Gregory Lee on 5/7/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"
@interface AddViewController : UITableViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,CameraViewControllerDelegate>
- (IBAction)saveButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *studentIDField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePictureTapped:(id)sender;

@end
