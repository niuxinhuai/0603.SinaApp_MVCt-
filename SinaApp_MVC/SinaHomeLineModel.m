//
//  SinaHomeLineModel.m
//
//  Created by   on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SinaHomeLineModel.h"
#import "SinaStatuses.h"


NSString *const kSinaHomeLineModelAd = @"ad";
NSString *const kSinaHomeLineModelHasvisible = @"hasvisible";
NSString *const kSinaHomeLineModelHasUnread = @"has_unread";
NSString *const kSinaHomeLineModelAdvertises = @"advertises";
NSString *const kSinaHomeLineModelPreviousCursor = @"previous_cursor";
NSString *const kSinaHomeLineModelUveBlank = @"uve_blank";
NSString *const kSinaHomeLineModelTotalNumber = @"total_number";
NSString *const kSinaHomeLineModelInterval = @"interval";
NSString *const kSinaHomeLineModelMaxId = @"max_id";
NSString *const kSinaHomeLineModelStatuses = @"statuses";
NSString *const kSinaHomeLineModelNextCursor = @"next_cursor";
NSString *const kSinaHomeLineModelSinceId = @"since_id";


@interface SinaHomeLineModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SinaHomeLineModel

@synthesize ad = _ad;
@synthesize hasvisible = _hasvisible;
@synthesize hasUnread = _hasUnread;
@synthesize advertises = _advertises;
@synthesize previousCursor = _previousCursor;
@synthesize uveBlank = _uveBlank;
@synthesize totalNumber = _totalNumber;
@synthesize interval = _interval;
@synthesize maxId = _maxId;
@synthesize statuses = _statuses;
@synthesize nextCursor = _nextCursor;
@synthesize sinceId = _sinceId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.ad = [self objectOrNilForKey:kSinaHomeLineModelAd fromDictionary:dict];
            self.hasvisible = [[self objectOrNilForKey:kSinaHomeLineModelHasvisible fromDictionary:dict] boolValue];
            self.hasUnread = [[self objectOrNilForKey:kSinaHomeLineModelHasUnread fromDictionary:dict] doubleValue];
            self.advertises = [self objectOrNilForKey:kSinaHomeLineModelAdvertises fromDictionary:dict];
            self.previousCursor = [[self objectOrNilForKey:kSinaHomeLineModelPreviousCursor fromDictionary:dict] doubleValue];
            self.uveBlank = [[self objectOrNilForKey:kSinaHomeLineModelUveBlank fromDictionary:dict] doubleValue];
            self.totalNumber = [[self objectOrNilForKey:kSinaHomeLineModelTotalNumber fromDictionary:dict] doubleValue];
            self.interval = [[self objectOrNilForKey:kSinaHomeLineModelInterval fromDictionary:dict] doubleValue];
            self.maxId = [[self objectOrNilForKey:kSinaHomeLineModelMaxId fromDictionary:dict] doubleValue];
    NSObject *receivedSinaStatuses = [dict objectForKey:kSinaHomeLineModelStatuses];
    NSMutableArray *parsedSinaStatuses = [NSMutableArray array];
    if ([receivedSinaStatuses isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSinaStatuses) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSinaStatuses addObject:[SinaStatuses modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSinaStatuses isKindOfClass:[NSDictionary class]]) {
       [parsedSinaStatuses addObject:[SinaStatuses modelObjectWithDictionary:(NSDictionary *)receivedSinaStatuses]];
    }

    self.statuses = [NSArray arrayWithArray:parsedSinaStatuses];
            self.nextCursor = [[self objectOrNilForKey:kSinaHomeLineModelNextCursor fromDictionary:dict] doubleValue];
            self.sinceId = [[self objectOrNilForKey:kSinaHomeLineModelSinceId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForAd = [NSMutableArray array];
    for (NSObject *subArrayObject in self.ad) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAd addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAd addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAd] forKey:kSinaHomeLineModelAd];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasvisible] forKey:kSinaHomeLineModelHasvisible];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hasUnread] forKey:kSinaHomeLineModelHasUnread];
    NSMutableArray *tempArrayForAdvertises = [NSMutableArray array];
    for (NSObject *subArrayObject in self.advertises) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAdvertises addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAdvertises addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAdvertises] forKey:kSinaHomeLineModelAdvertises];
    [mutableDict setValue:[NSNumber numberWithDouble:self.previousCursor] forKey:kSinaHomeLineModelPreviousCursor];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uveBlank] forKey:kSinaHomeLineModelUveBlank];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalNumber] forKey:kSinaHomeLineModelTotalNumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.interval] forKey:kSinaHomeLineModelInterval];
    [mutableDict setValue:[NSNumber numberWithDouble:self.maxId] forKey:kSinaHomeLineModelMaxId];
    NSMutableArray *tempArrayForStatuses = [NSMutableArray array];
    for (NSObject *subArrayObject in self.statuses) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForStatuses addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForStatuses addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForStatuses] forKey:kSinaHomeLineModelStatuses];
    [mutableDict setValue:[NSNumber numberWithDouble:self.nextCursor] forKey:kSinaHomeLineModelNextCursor];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sinceId] forKey:kSinaHomeLineModelSinceId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.ad = [aDecoder decodeObjectForKey:kSinaHomeLineModelAd];
    self.hasvisible = [aDecoder decodeBoolForKey:kSinaHomeLineModelHasvisible];
    self.hasUnread = [aDecoder decodeDoubleForKey:kSinaHomeLineModelHasUnread];
    self.advertises = [aDecoder decodeObjectForKey:kSinaHomeLineModelAdvertises];
    self.previousCursor = [aDecoder decodeDoubleForKey:kSinaHomeLineModelPreviousCursor];
    self.uveBlank = [aDecoder decodeDoubleForKey:kSinaHomeLineModelUveBlank];
    self.totalNumber = [aDecoder decodeDoubleForKey:kSinaHomeLineModelTotalNumber];
    self.interval = [aDecoder decodeDoubleForKey:kSinaHomeLineModelInterval];
    self.maxId = [aDecoder decodeDoubleForKey:kSinaHomeLineModelMaxId];
    self.statuses = [aDecoder decodeObjectForKey:kSinaHomeLineModelStatuses];
    self.nextCursor = [aDecoder decodeDoubleForKey:kSinaHomeLineModelNextCursor];
    self.sinceId = [aDecoder decodeDoubleForKey:kSinaHomeLineModelSinceId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ad forKey:kSinaHomeLineModelAd];
    [aCoder encodeBool:_hasvisible forKey:kSinaHomeLineModelHasvisible];
    [aCoder encodeDouble:_hasUnread forKey:kSinaHomeLineModelHasUnread];
    [aCoder encodeObject:_advertises forKey:kSinaHomeLineModelAdvertises];
    [aCoder encodeDouble:_previousCursor forKey:kSinaHomeLineModelPreviousCursor];
    [aCoder encodeDouble:_uveBlank forKey:kSinaHomeLineModelUveBlank];
    [aCoder encodeDouble:_totalNumber forKey:kSinaHomeLineModelTotalNumber];
    [aCoder encodeDouble:_interval forKey:kSinaHomeLineModelInterval];
    [aCoder encodeDouble:_maxId forKey:kSinaHomeLineModelMaxId];
    [aCoder encodeObject:_statuses forKey:kSinaHomeLineModelStatuses];
    [aCoder encodeDouble:_nextCursor forKey:kSinaHomeLineModelNextCursor];
    [aCoder encodeDouble:_sinceId forKey:kSinaHomeLineModelSinceId];
}

- (id)copyWithZone:(NSZone *)zone
{
    SinaHomeLineModel *copy = [[SinaHomeLineModel alloc] init];
    
    if (copy) {

        copy.ad = [self.ad copyWithZone:zone];
        copy.hasvisible = self.hasvisible;
        copy.hasUnread = self.hasUnread;
        copy.advertises = [self.advertises copyWithZone:zone];
        copy.previousCursor = self.previousCursor;
        copy.uveBlank = self.uveBlank;
        copy.totalNumber = self.totalNumber;
        copy.interval = self.interval;
        copy.maxId = self.maxId;
        copy.statuses = [self.statuses copyWithZone:zone];
        copy.nextCursor = self.nextCursor;
        copy.sinceId = self.sinceId;
    }
    
    return copy;
}


@end
