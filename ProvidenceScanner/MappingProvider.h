//
//  MappingProvider.h
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
@interface MappingProvider : NSObject
+(NSURL *) jsonURLFromString:(NSString *)url;
+(NSURL *) imageURL:(NSString *)imageName FromString:(NSString *)url;
+(RKMapping *)studentMapping;
@end
