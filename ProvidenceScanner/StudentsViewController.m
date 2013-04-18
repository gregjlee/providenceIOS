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

@interface StudentsViewController ()
@property(nonatomic,strong)NSArray *students;
@property(nonatomic,strong)Student *selectedStudent;
@property(nonatomic,strong)NSString *selectedURL;
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
    isLocalURL=YES;
    _selectedURL=localStudentURL;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[MappingProvider jsonURLFromString:_selectedURL]];
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
        [self configureStudentCell:cell forStudent:student];
    }
    
    return cell;
}

-(void)configureStudentCell:(StudentsCell *)cell forStudent:(Student *)student{
    cell.nameLabel.text=student.name;
    cell.student_numLabel.text=[NSString stringWithFormat:@"id# %d", student.idNum];
    UIImage *defaultImage = [UIImage imageNamed:@"ironman3.jpeg"];
    [cell.imageView setImageWithURL:[MappingProvider imageURL:student.imageURL FromString:_selectedURL]
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
    
    if ([segue.identifier isEqualToString:@"profileviewcontroller"]) {
        ProfileViewController *profileViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedStudent = [self.students objectAtIndex:indexPath.row];
        [self prepProfile:profileViewController];
    }
    
}

-(void)prepProfile:(ProfileViewController *)profileController{
    profileController.student = self.selectedStudent;
    profileController.url=_selectedURL;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reloadTable:(id)sender {
    _selectedURL=(localStudentURL)?publicStudentsURL:localStudentURL;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [SVProgressHUD show];
    
    dispatch_async(queue, ^{
        [self loadStudents];
    });
}

- (IBAction)scanTapped:(id)sender {
    ZBarReaderViewController *reader=[ZBarReaderViewController new];
    reader.readerDelegate=self;
    reader.supportedOrientationsMask=ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology:symbolType config:ZBAR_CFG_ENABLE to:ZBAR_QRCODE];
    
    [self presentViewController:reader animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in results) {
        break;
    }
    
    NSLog(@"idfound : %d",[symbol.data integerValue]);
    
    
    [picker dismissViewControllerAnimated:YES completion:^(void){
        if (_students) {
            _selectedStudent=nil;
            for (Student *student in _students) {
                if (student.idNum==[symbol.data integerValue]) {
                    _selectedStudent=student;
                    break;
                }
            }
            if (_selectedStudent) {
                ProfileViewController *profileController=[self.storyboard instantiateViewControllerWithIdentifier:@"profileviewcontroller"];
                [self prepProfile:profileController];
                [self.navigationController pushViewController:profileController animated:YES];
            }
        }
    }];
}
@end
