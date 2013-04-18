//
//  ViewController.m
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking.h>
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define localStudentsURL [NSURL URLWithString:@"http://localhost:3000/students.json"]
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadStudent];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)loadStudent{
    _nameLabel.text=[NSString stringWithFormat:@"Name: %@",_student.name];
    _studentIDLabel.text=[NSString stringWithFormat:@"studentID: %d", _student.idNum];
    _weightLabel.text=[NSString stringWithFormat:@"weight: %d", _student.weight];
    [_imageView setImageWithURL:[self imageFullURLFromURL:_student.imageURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findStudent:(id)sender {
    [_idTextField resignFirstResponder];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        localStudentsURL];
        if (data) {
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        }
        else
            NSLog(@"data not valid");
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* students = [json objectForKey:@"students"]; //2
    NSInteger index=[_idTextField.text integerValue];
    NSLog(@"students: %@", students); //3
    for (NSDictionary *student in students) {
        NSNumber *indexNum=[student objectForKey:@"id"];
        if ([indexNum integerValue]==index) {
            NSString *name = [student objectForKey:@"name"];
            NSNumber *id_num = [student objectForKey:@"id_num"];
            NSNumber *weight = [student objectForKey:@"weight"];
            NSString *imageURL = [student objectForKey:@"image_url"];
            
            
        }
    }
}

-(NSURL *)imageFullURLFromURL:(NSString *)url{
    NSString *fullURL=[NSString stringWithFormat:@"http://localhost:3000/assets/%@",url];
    return [NSURL URLWithString:fullURL];
    
}


@end
