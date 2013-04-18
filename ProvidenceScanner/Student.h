//
//  Student.h
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger studentId;
@property(nonatomic,assign)NSInteger idNum;
@property(nonatomic,assign)NSInteger weight;
@property(nonatomic,copy)NSString *imageURL;


@end
