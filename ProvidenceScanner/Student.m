//
//  Student.m
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import "Student.h"

@implementation Student
-(id)init{
    self=[super init];
    self.name=@"nameless";
    self.idNum=0000;
    self.weight=9999;
    return self;
}
-(NSDictionary *)dictionaryValue{
    
    NSDictionary *renameDict=@{@"name": self.name, @"id_num": [self stringIDnum],@"weight": [self stringWeight]};
    return renameDict;
}

-(NSString *)stringIDnum{
    return [NSString stringWithFormat:@"%d",self.idNum];
}
-(NSString *)stringWeight{
    return [NSString stringWithFormat:@"%d",self.weight];
}

@end
