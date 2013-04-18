//
//  StudentsViewController.m
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import "StudentsViewController.h"
#import "StudentsCell.h"
#import "Student.h"
#import <RestKit/RestKit.h>
#import <SVProgressHUD.h>
#import "MappingProvider.h"
#import "ProfileViewController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 
#define localStudentsURL [NSURL URLWithString:@"http://localhost:3000/students.json"]
@interface StudentsViewController ()
@property(nonatomic,strong)NSArray *students;
@property(nonatomic,strong)Student *selectedStudent;
@end

@implementation StudentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tableView setRowHeight:85];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [SVProgressHUD show];
    
    dispatch_async(queue, ^{
        [self loadStudents];
    });
    
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma load students
-(void)loadStudents{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider studentMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                        pathPattern:@"/students.json"
                            keyPath:@"students"
                        statusCodes:statusCodeSet];
    NSURLRequest *request = [NSURLRequest requestWithURL:localStudentsURL];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc]initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        assert([NSThread isMainThread]);
        _students = mappingResult.array;
        [_tableView reloadData];
        [SVProgressHUD dismiss];
    }failure:^(RKObjectRequestOperation *operation, NSError *error){
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response : %@", operation.HTTPRequestOperation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Request failed"];
    }];
    [operation start];
}
-(NSURL *)imageFullURLFromURL:(NSString *)url{
    NSString *fullURL=[NSString stringWithFormat:@"http://localhost:3000/assets/%@",url];
    return [NSURL URLWithString:fullURL];
}


#pragma mark table data source

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"studentcell";
    StudentsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_students) {
        Student *student=[_students objectAtIndex:indexPath.row];
        NSLog(@"table cell image %@", student.imageURL);
        [self configureStudentCell:cell forStudent:student];
    }
    
    return cell;
}

-(void)configureStudentCell:(StudentsCell *)cell forStudent:(Student *)student{
    cell.nameLabel.text=student.name;
    cell.student_numLabel.text=[NSString stringWithFormat:@"id# %d", student.idNum];
    UIImage *defaultImage = [UIImage imageNamed:@"ironman3.jpeg"];
    [cell.imageView setImageWithURL:[self imageFullURLFromURL:student.imageURL]
                        placeholderImage:defaultImage];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_students) {
        return _students.count;
    }
    else
    return 0;
}

#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *profileViewController = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.selectedStudent = [self.students objectAtIndex:indexPath.row];
    profileViewController.student = self.selectedStudent;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reloadTable:(id)sender {
    [_tableView reloadData];
}
@end
