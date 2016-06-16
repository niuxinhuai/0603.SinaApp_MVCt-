//
//  SinaVisible.h
//
//  Created by   on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SinaVisible : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double type;
@property (nonatomic, assign) double listId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
