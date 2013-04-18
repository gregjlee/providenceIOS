//
//  ViewController.h
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface ProfileViewController : UIViewController
@property(strong,nonatomic) Student *student;
- (IBAction)findStudent:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *idTextField;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *studentIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end
