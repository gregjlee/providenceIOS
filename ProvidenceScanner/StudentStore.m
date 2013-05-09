//
//  StudentStore.m
//  ProvidenceScanner
//
//  Created by Gregory Lee on 5/7/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//
#import <RestKit/RestKit.h>
#import <SVProgressHUD.h>
#import "MappingProvider.h"
#import "Student.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "StudentStore.h"
static StudentStore *store = nil;
@implementation StudentStore
+(StudentStore *)store{
    if (store) {
        return store;
    }
    else
        store=[[super allocWithZone:nil]init];
    return store;
}
+(id)allocWithZone:(NSZone *)zone{
    return [self store];
}
-(id)init{
    self = [super init];
    _selectedURL=localStudentURL;
    return self;
}
//-(NSArray *)students{
//    if (_students) {
//        return _students;
//    }
//    else{
//        [self loadStudents:^(NSArray *studentArray) {
//            //_students=studentArray;
//            //return studentArray;
//        }];
//        return nil;
//    }
//}
-(void)loadStudents:(StudentsCompletionBlock)completion{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [SVProgressHUD show];
    dispatch_async(queue, ^{
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
            [SVProgressHUD dismiss];
            completion(_students);
        }failure:^(RKObjectRequestOperation *operation, NSError *error){
            NSLog(@"ERROR: %@", error);
            NSLog(@"Response : %@", operation.HTTPRequestOperation.responseString);
            [SVProgressHUD showErrorWithStatus:@"Request failed"];
    }];
    [operation start];
    });
}
-(void)updateStudent:(Student *)student{
        [SVProgressHUD show];
        NSDictionary *renameDict=[student dictionaryValue];
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:renameDict options:kNilOptions error:&error];
        
        
        NSURL *jsonURL = [MappingProvider jsonURLFromString:self.selectedURL withID:student.studentId];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:jsonURL];
        [request setHTTPMethod:@"PUT"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        // print json:
        NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding]);
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [SVProgressHUD dismiss];
        }];
//                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            [connection start];

}

-(void)createStudent:(Student *)student{
    [SVProgressHUD show];
    NSDictionary *studentData=[student dictionaryValue];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:studentData options:kNilOptions error:&error];
    
    NSURL *jsonURL = [MappingProvider jsonURLFromString:self.selectedURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:jsonURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    // print json:
    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding]);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSLog(@"create success %@",response);
        }
        else{
            NSLog(@"create error %@",error);
        }
        [SVProgressHUD dismiss];
    }];
}


-(BOOL)isLocalURL{
    if ([_selectedURL isEqualToString:localStudentURL]) {
        return YES;
    }
    else
        return NO;
}

@end
