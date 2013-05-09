//
//  ViewController.h
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface ProfileViewController : UITableViewController
@property(strong,nonatomic) Student *student;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) IBOutlet UIImageView *qrImageView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *idNumField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end
