//
//  MappingProvider.m
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import "MappingProvider.h"
#import "Student.h"
@implementation MappingProvider
+(NSURL *) jsonURLFromString:(NSString *)url{
    NSURL *jsonURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/students.json", url]];
    return jsonURL;
}
+(NSURL *) imageURL:(NSString *)imageName FromString:(NSString *)url{
    NSURL *imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/assets/%@", url,imageName]];
    return imageURL;
}
+(RKMapping *)studentMapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Student class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"weight"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id": @"studentId",
     @"id_num": @"idNum",
     @"image_url": @"imageURL"
     }];
    return mapping;
}
@end
