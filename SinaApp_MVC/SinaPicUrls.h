//
//  SinaPicUrls.h
//
//  Created by   on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SinaPicUrls : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *thumbnailPic;
@property (nonatomic, strong) NSString *largePic;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
