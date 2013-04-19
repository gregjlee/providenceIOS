//
//  ViewController.m
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define qrSiteURL @"http://qrfree.kaywa.com/?l=1&s=8&d="
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[self configureDoneButton]];
    [self loadStudent];
	// Do any additional setup after loading the view, typically from a nib.
}

-(UIBarButtonItem *)configureDoneButton{
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing:)];
    return doneButton;
}
-(void)loadStudent{
    _nameTextField.text=_student.name;
    _idNumField.text=[NSString stringWithFormat:@"%d", _student.idNum];
    _weightField.text=[NSString stringWithFormat:@"%d", _student.weight];
    [_imageView setImageWithURL:[MappingProvider imageURL:_student.imageURL FromString:_url] placeholderImage:[UIImage imageNamed:@"ironman3.jpeg"]];
    NSURL *qrURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d",qrSiteURL,_student.idNum]];
    [_qrImageView setImageWithURL:qrURL placeholderImage:[UIImage imageNamed:@"trollFace.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneEditing:(id)sender{
    
    NSDictionary *renameDict=@{@"name": _nameTextField.text, @"id_num": _idNumField.text, @"weight": _weightField.text};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:renameDict options:kNilOptions error:&error];
    
    
    NSURL *jsonURL = [MappingProvider jsonURLFromString:_url withID:_student.studentId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:jsonURL];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    // print json:
    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding]);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)findStudent:(id)sender {
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [MappingProvider jsonURLFromString:_url]];
        if (data) {
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        }
        else
            NSLog(@"data not valid");
    });
}

- (void)fetchedData:(NSData *)responseData {
//    //parse out the json data
//    NSError* error;
//    NSDictionary* json = [NSJSONSerialization
//                          JSONObjectWithData:responseData //1
//                          
//                          options:kNilOptions
//                          error:&error];
//    
//    NSArray* students = [json objectForKey:@"students"]; //2
//    NSInteger index=[_idTextField.text integerValue];
//    NSLog(@"students: %@", students); //3
//    for (NSDictionary *student in students) {
//        NSNumber *indexNum=[student objectForKey:@"id"];
//        if ([indexNum integerValue]==index) {
//            NSString *name = [student objectForKey:@"name"];
//            NSNumber *id_num = [student objectForKey:@"id_num"];
//            NSNumber *weight = [student objectForKey:@"weight"];
//            NSString *imageURL = [student objectForKey:@"image_url"];
//            
//            
//        }
//    }
}

-(NSURL *)imageFullURLFromURL:(NSString *)url{
    NSString *fullURL=[NSString stringWithFormat:@"http://localhost:3000/assets/%@",url];
    return [NSURL URLWithString:fullURL];
    
}


@end
