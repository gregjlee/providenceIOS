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
#import "StudentStore.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 

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
    _isChanged=NO;
    [_tableView setRowHeight:85];
    self.navigationItem.title=([[StudentStore store] isLocalURL])?@"Local":@"Public";

    
    
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_students) {
        [self loadStudents];
    }
    else{
        if (_isChanged) {
            _isChanged=NO;
            [self loadStudents];
        }
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}
#pragma load students
-(void)loadStudents{
    [[StudentStore store]loadStudents:^(NSArray *students) {
        _students=students;
        [_tableView reloadData];
    }];
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
    NSLog(@"configCell url %@",student.imageURL);
    UIImage *defaultImage = [UIImage imageNamed:@"ironman3.jpeg"];
    [cell.imageView setImageWithURL:[MappingProvider imageURL:student.imageURL FromString:[[StudentStore store]selectedURL]]
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
    ProfileViewController *profileViewController= [[UIStoryboard storyboardWithName:@"ProfileStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"profileviewcontroller"];
    self.selectedStudent = [self.students objectAtIndex:indexPath.row];
    [self prepProfile:profileViewController];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:profileViewController animated:YES];
}



-(void)prepProfile:(ProfileViewController *)profileController{
    profileController.student = self.selectedStudent;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reloadTableTapped:(id)sender {
    [self loadStudents];
}

- (IBAction)scanTapped:(id)sender {
    ZBarReaderViewController *reader=[ZBarReaderViewController new];
    reader.readerDelegate=self;
    reader.supportedOrientationsMask=ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology:symbolType config:ZBAR_CFG_ENABLE to:ZBAR_QRCODE];
    
    [self presentViewController:reader animated:YES completion:nil];
}

- (IBAction)switchURLTapped:(id)sender {
    BOOL isLocalURL=[[StudentStore store]isLocalURL];
    
    [StudentStore store].selectedURL=(isLocalURL)?publicStudentsURL:localStudentURL;
    [self loadStudents];
    self.navigationItem.title=(isLocalURL)?@"Local":@"Public";
}

- (IBAction)addStudent:(id)sender {
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
                ProfileViewController *profileViewController= [[UIStoryboard storyboardWithName:@"ProfileStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"profileviewcontroller"];
                [self prepProfile:profileViewController];
                [self.navigationController pushViewController:profileViewController animated:YES];
            }
        }
    }];
}
@end
