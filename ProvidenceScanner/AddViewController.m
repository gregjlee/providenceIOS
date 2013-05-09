//
//  AddViewController.m
//  ProvidenceScanner
//
//  Created by Gregory Lee on 5/7/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import "AddViewController.h"
#import "Student.h"
#import "StudentStore.h"
#import "StudentsViewController.h"
@interface AddViewController ()
- (IBAction)cancelButtonTapped:(id)sender;

@end

@implementation AddViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)saveButtonTapped:(id)sender {
    Student *student=[[Student alloc]init];
    student.name=_nameField.text;
    student.idNum=[_studentIDField.text integerValue];
    student.weight=[_weightField.text integerValue];
    [[StudentStore store]createStudent:student];
    StudentsViewController *svc=[self.navigationController viewControllers][0];
    svc.isChanged=YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)takePictureTapped:(id)sender {
    CameraViewController *cameraViewController=[[CameraViewController alloc]init];
    cameraViewController.cameraDelegate=self;
    [self presentViewController:cameraViewController animated:YES completion:nil];

}

-(void)cameraControllerFinishedWithImage:(UIImage *)image{
    NSLog(@"add camera delegate finsihed");
    _imageView.image=image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
