//
//  StudentStore.h
//  ProvidenceScanner
//
//  Created by Gregory Lee on 5/7/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StudentsCompletionBlock)(NSArray *);
@class Student;
@interface StudentStore : NSObject<NSURLConnectionDelegate>
+(StudentStore *)store;
@property(nonatomic,strong)NSArray *students;
@property(nonatomic,strong)NSString *selectedURL;
-(BOOL)isLocalURL;
-(void)loadStudents:(StudentsCompletionBlock)completion;
-(void)updateStudent:(Student *)student;
-(void)createStudent:(Student *)student;

@end
