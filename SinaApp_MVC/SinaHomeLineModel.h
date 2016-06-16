//
//  SinaHomeLineModel.h
//
//  Created by   on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SinaHomeLineModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *ad;
@property (nonatomic, assign) BOOL hasvisible;
@property (nonatomic, assign) double hasUnread;
@property (nonatomic, strong) NSArray *advertises;
@property (nonatomic, assign) double previousCursor;
@property (nonatomic, assign) double uveBlank;
@property (nonatomic, assign) double totalNumber;
@property (nonatomic, assign) double interval;
@property (nonatomic, assign) double maxId;
@property (nonatomic, strong) NSArray *statuses;
@property (nonatomic, assign) double nextCursor;
@property (nonatomic, assign) double sinceId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
