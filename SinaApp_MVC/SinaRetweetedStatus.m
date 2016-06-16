//
//  SinaRetweetedStatus.m
//
//  Created by   on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SinaRetweetedStatus.h"
#import "SinaPicUrls.h"
#import "SinaUser.h"
#import "SinaVisible.h"


NSString *const kSinaRetweetedStatusAttitudesCount = @"attitudes_count";
NSString *const kSinaRetweetedStatusSource = @"source";
NSString *const kSinaRetweetedStatusTextLength = @"textLength";
NSString *const kSinaRetweetedStatusSourceType = @"source_type";
NSString *const kSinaRetweetedStatusIdstr = @"idstr";
NSString *const kSinaRetweetedStatusMid = @"mid";
NSString *const kSinaRetweetedStatusTruncated = @"truncated";
NSString *const kSinaRetweetedStatusHotWeiboTags = @"hot_weibo_tags";
NSString *const kSinaRetweetedStatusSourceAllowclick = @"source_allowclick";
NSString *const kSinaRetweetedStatusDarwinTags = @"darwin_tags";
NSString *const kSinaRetweetedStatusInReplyToScreenName = @"in_reply_to_screen_name";
NSString *const kSinaRetweetedStatusCommentsCount = @"comments_count";
NSString *const kSinaRetweetedStatusOriginalPic = @"original_pic";
NSString *const kSinaRetweetedStatusPicUrls = @"pic_urls";
NSString *const kSinaRetweetedStatusIsLongText = @"isLongText";
NSString *const kSinaRetweetedStatusRepostsCount = @"reposts_count";
NSString *const kSinaRetweetedStatusThumbnailPic = @"thumbnail_pic";
NSString *const kSinaRetweetedStatusFavorited = @"favorited";
NSString *const kSinaRetweetedStatusTextTagTips = @"text_tag_tips";
NSString *const kSinaRetweetedStatusBmiddlePic = @"bmiddle_pic";
NSString *const kSinaRetweetedStatusGeo = @"geo";
NSString *const kSinaRetweetedStatusId = @"id";
NSString *const kSinaRetweetedStatusUser = @"user";
NSString *const kSinaRetweetedStatusInReplyToUserId = @"in_reply_to_user_id";
NSString *const kSinaRetweetedStatusUserType = @"userType";
NSString *const kSinaRetweetedStatusBizIds = @"biz_ids";
NSString *const kSinaRetweetedStatusText = @"text";
NSString *const kSinaRetweetedStatusBizFeature = @"biz_feature";
NSString *const kSinaRetweetedStatusMlevel = @"mlevel";
NSString *const kSinaRetweetedStatusCreatedAt = @"created_at";
NSString *const kSinaRetweetedStatusVisible = @"visible";
NSString *const kSinaRetweetedStatusInReplyToStatusId = @"in_reply_to_status_id";


@interface SinaRetweetedStatus ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SinaRetweetedStatus

@synthesize attitudesCount = _attitudesCount;
@synthesize source = _source;
@synthesize textLength = _textLength;
@synthesize sourceType = _sourceType;
@synthesize idstr = _idstr;
@synthesize mid = _mid;
@synthesize truncated = _truncated;
@synthesize hotWeiboTags = _hotWeiboTags;
@synthesize sourceAllowclick = _sourceAllowclick;
@synthesize darwinTags = _darwinTags;
@synthesize inReplyToScreenName = _inReplyToScreenName;
@synthesize commentsCount = _commentsCount;
@synthesize originalPic = _originalPic;
@synthesize picUrls = _picUrls;
@synthesize isLongText = _isLongText;
@synthesize repostsCount = _repostsCount;
@synthesize thumbnailPic = _thumbnailPic;
@synthesize favorited = _favorited;
@synthesize textTagTips = _textTagTips;
@synthesize bmiddlePic = _bmiddlePic;
@synthesize geo = _geo;
@synthesize retweetedStatusIdentifier = _retweetedStatusIdentifier;
@synthesize user = _user;
@synthesize inReplyToUserId = _inReplyToUserId;
@synthesize userType = _userType;
@synthesize bizIds = _bizIds;
@synthesize text = _text;
@synthesize bizFeature = _bizFeature;
@synthesize mlevel = _mlevel;
@synthesize createdAt = _createdAt;
@synthesize visible = _visible;
@synthesize inReplyToStatusId = _inReplyToStatusId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    //当没有字典数据时,返回空
    if (!dict) {
        return nil;
    }
    
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.attitudesCount = [[self objectOrNilForKey:kSinaRetweetedStatusAttitudesCount fromDictionary:dict] doubleValue];
            self.source = [self objectOrNilForKey:kSinaRetweetedStatusSource fromDictionary:dict];
            self.textLength = [[self objectOrNilForKey:kSinaRetweetedStatusTextLength fromDictionary:dict] doubleValue];
            self.sourceType = [[self objectOrNilForKey:kSinaRetweetedStatusSourceType fromDictionary:dict] doubleValue];
            self.idstr = [self objectOrNilForKey:kSinaRetweetedStatusIdstr fromDictionary:dict];
            self.mid = [self objectOrNilForKey:kSinaRetweetedStatusMid fromDictionary:dict];
            self.truncated = [[self objectOrNilForKey:kSinaRetweetedStatusTruncated fromDictionary:dict] boolValue];
            self.hotWeiboTags = [self objectOrNilForKey:kSinaRetweetedStatusHotWeiboTags fromDictionary:dict];
            self.sourceAllowclick = [[self objectOrNilForKey:kSinaRetweetedStatusSourceAllowclick fromDictionary:dict] doubleValue];
            self.darwinTags = [self objectOrNilForKey:kSinaRetweetedStatusDarwinTags fromDictionary:dict];
            self.inReplyToScreenName = [self objectOrNilForKey:kSinaRetweetedStatusInReplyToScreenName fromDictionary:dict];
            self.commentsCount = [[self objectOrNilForKey:kSinaRetweetedStatusCommentsCount fromDictionary:dict] doubleValue];
            self.originalPic = [self objectOrNilForKey:kSinaRetweetedStatusOriginalPic fromDictionary:dict];
    NSObject *receivedSinaPicUrls = [dict objectForKey:kSinaRetweetedStatusPicUrls];
    NSMutableArray *parsedSinaPicUrls = [NSMutableArray array];
    if ([receivedSinaPicUrls isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSinaPicUrls) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSinaPicUrls addObject:[SinaPicUrls modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSinaPicUrls isKindOfClass:[NSDictionary class]]) {
       [parsedSinaPicUrls addObject:[SinaPicUrls modelObjectWithDictionary:(NSDictionary *)receivedSinaPicUrls]];
    }

    self.picUrls = [NSArray arrayWithArray:parsedSinaPicUrls];
            self.isLongText = [[self objectOrNilForKey:kSinaRetweetedStatusIsLongText fromDictionary:dict] boolValue];
            self.repostsCount = [[self objectOrNilForKey:kSinaRetweetedStatusRepostsCount fromDictionary:dict] doubleValue];
            self.thumbnailPic = [self objectOrNilForKey:kSinaRetweetedStatusThumbnailPic fromDictionary:dict];
            self.favorited = [[self objectOrNilForKey:kSinaRetweetedStatusFavorited fromDictionary:dict] boolValue];
            self.textTagTips = [self objectOrNilForKey:kSinaRetweetedStatusTextTagTips fromDictionary:dict];
            self.bmiddlePic = [self objectOrNilForKey:kSinaRetweetedStatusBmiddlePic fromDictionary:dict];
            self.geo = [self objectOrNilForKey:kSinaRetweetedStatusGeo fromDictionary:dict];
            self.retweetedStatusIdentifier = [[self objectOrNilForKey:kSinaRetweetedStatusId fromDictionary:dict] doubleValue];
            self.user = [SinaUser modelObjectWithDictionary:[dict objectForKey:kSinaRetweetedStatusUser]];
            self.inReplyToUserId = [self objectOrNilForKey:kSinaRetweetedStatusInReplyToUserId fromDictionary:dict];
            self.userType = [[self objectOrNilForKey:kSinaRetweetedStatusUserType fromDictionary:dict] doubleValue];
            self.bizIds = [self objectOrNilForKey:kSinaRetweetedStatusBizIds fromDictionary:dict];
            self.text = [self objectOrNilForKey:kSinaRetweetedStatusText fromDictionary:dict];
            self.bizFeature = [[self objectOrNilForKey:kSinaRetweetedStatusBizFeature fromDictionary:dict] doubleValue];
            self.mlevel = [[self objectOrNilForKey:kSinaRetweetedStatusMlevel fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kSinaRetweetedStatusCreatedAt fromDictionary:dict];
            self.visible = [SinaVisible modelObjectWithDictionary:[dict objectForKey:kSinaRetweetedStatusVisible]];
            self.inReplyToStatusId = [self objectOrNilForKey:kSinaRetweetedStatusInReplyToStatusId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.attitudesCount] forKey:kSinaRetweetedStatusAttitudesCount];
    [mutableDict setValue:self.source forKey:kSinaRetweetedStatusSource];
    [mutableDict setValue:[NSNumber numberWithDouble:self.textLength] forKey:kSinaRetweetedStatusTextLength];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sourceType] forKey:kSinaRetweetedStatusSourceType];
    [mutableDict setValue:self.idstr forKey:kSinaRetweetedStatusIdstr];
    [mutableDict setValue:self.mid forKey:kSinaRetweetedStatusMid];
    [mutableDict setValue:[NSNumber numberWithBool:self.truncated] forKey:kSinaRetweetedStatusTruncated];
    NSMutableArray *tempArrayForHotWeiboTags = [NSMutableArray array];
    for (NSObject *subArrayObject in self.hotWeiboTags) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForHotWeiboTags addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForHotWeiboTags addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForHotWeiboTags] forKey:kSinaRetweetedStatusHotWeiboTags];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sourceAllowclick] forKey:kSinaRetweetedStatusSourceAllowclick];
    NSMutableArray *tempArrayForDarwinTags = [NSMutableArray array];
    for (NSObject *subArrayObject in self.darwinTags) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForDarwinTags addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForDarwinTags addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDarwinTags] forKey:kSinaRetweetedStatusDarwinTags];
    [mutableDict setValue:self.inReplyToScreenName forKey:kSinaRetweetedStatusInReplyToScreenName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentsCount] forKey:kSinaRetweetedStatusCommentsCount];
    [mutableDict setValue:self.originalPic forKey:kSinaRetweetedStatusOriginalPic];
    NSMutableArray *tempArrayForPicUrls = [NSMutableArray array];
    for (NSObject *subArrayObject in self.picUrls) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPicUrls addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPicUrls addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPicUrls] forKey:kSinaRetweetedStatusPicUrls];
    [mutableDict setValue:[NSNumber numberWithBool:self.isLongText] forKey:kSinaRetweetedStatusIsLongText];
    [mutableDict setValue:[NSNumber numberWithDouble:self.repostsCount] forKey:kSinaRetweetedStatusRepostsCount];
    [mutableDict setValue:self.thumbnailPic forKey:kSinaRetweetedStatusThumbnailPic];
    [mutableDict setValue:[NSNumber numberWithBool:self.favorited] forKey:kSinaRetweetedStatusFavorited];
    NSMutableArray *tempArrayForTextTagTips = [NSMutableArray array];
    for (NSObject *subArrayObject in self.textTagTips) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTextTagTips addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTextTagTips addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTextTagTips] forKey:kSinaRetweetedStatusTextTagTips];
    [mutableDict setValue:self.bmiddlePic forKey:kSinaRetweetedStatusBmiddlePic];
    [mutableDict setValue:self.geo forKey:kSinaRetweetedStatusGeo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.retweetedStatusIdentifier] forKey:kSinaRetweetedStatusId];
    [mutableDict setValue:[self.user dictionaryRepresentation] forKey:kSinaRetweetedStatusUser];
    [mutableDict setValue:self.inReplyToUserId forKey:kSinaRetweetedStatusInReplyToUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userType] forKey:kSinaRetweetedStatusUserType];
    NSMutableArray *tempArrayForBizIds = [NSMutableArray array];
    for (NSObject *subArrayObject in self.bizIds) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBizIds addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBizIds addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBizIds] forKey:kSinaRetweetedStatusBizIds];
    [mutableDict setValue:self.text forKey:kSinaRetweetedStatusText];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bizFeature] forKey:kSinaRetweetedStatusBizFeature];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mlevel] forKey:kSinaRetweetedStatusMlevel];
    [mutableDict setValue:self.createdAt forKey:kSinaRetweetedStatusCreatedAt];
    [mutableDict setValue:[self.visible dictionaryRepresentation] forKey:kSinaRetweetedStatusVisible];
    [mutableDict setValue:self.inReplyToStatusId forKey:kSinaRetweetedStatusInReplyToStatusId];

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

    self.attitudesCount = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusAttitudesCount];
    self.source = [aDecoder decodeObjectForKey:kSinaRetweetedStatusSource];
    self.textLength = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusTextLength];
    self.sourceType = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusSourceType];
    self.idstr = [aDecoder decodeObjectForKey:kSinaRetweetedStatusIdstr];
    self.mid = [aDecoder decodeObjectForKey:kSinaRetweetedStatusMid];
    self.truncated = [aDecoder decodeBoolForKey:kSinaRetweetedStatusTruncated];
    self.hotWeiboTags = [aDecoder decodeObjectForKey:kSinaRetweetedStatusHotWeiboTags];
    self.sourceAllowclick = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusSourceAllowclick];
    self.darwinTags = [aDecoder decodeObjectForKey:kSinaRetweetedStatusDarwinTags];
    self.inReplyToScreenName = [aDecoder decodeObjectForKey:kSinaRetweetedStatusInReplyToScreenName];
    self.commentsCount = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusCommentsCount];
    self.originalPic = [aDecoder decodeObjectForKey:kSinaRetweetedStatusOriginalPic];
    self.picUrls = [aDecoder decodeObjectForKey:kSinaRetweetedStatusPicUrls];
    self.isLongText = [aDecoder decodeBoolForKey:kSinaRetweetedStatusIsLongText];
    self.repostsCount = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusRepostsCount];
    self.thumbnailPic = [aDecoder decodeObjectForKey:kSinaRetweetedStatusThumbnailPic];
    self.favorited = [aDecoder decodeBoolForKey:kSinaRetweetedStatusFavorited];
    self.textTagTips = [aDecoder decodeObjectForKey:kSinaRetweetedStatusTextTagTips];
    self.bmiddlePic = [aDecoder decodeObjectForKey:kSinaRetweetedStatusBmiddlePic];
    self.geo = [aDecoder decodeObjectForKey:kSinaRetweetedStatusGeo];
    self.retweetedStatusIdentifier = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusId];
    self.user = [aDecoder decodeObjectForKey:kSinaRetweetedStatusUser];
    self.inReplyToUserId = [aDecoder decodeObjectForKey:kSinaRetweetedStatusInReplyToUserId];
    self.userType = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusUserType];
    self.bizIds = [aDecoder decodeObjectForKey:kSinaRetweetedStatusBizIds];
    self.text = [aDecoder decodeObjectForKey:kSinaRetweetedStatusText];
    self.bizFeature = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusBizFeature];
    self.mlevel = [aDecoder decodeDoubleForKey:kSinaRetweetedStatusMlevel];
    self.createdAt = [aDecoder decodeObjectForKey:kSinaRetweetedStatusCreatedAt];
    self.visible = [aDecoder decodeObjectForKey:kSinaRetweetedStatusVisible];
    self.inReplyToStatusId = [aDecoder decodeObjectForKey:kSinaRetweetedStatusInReplyToStatusId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_attitudesCount forKey:kSinaRetweetedStatusAttitudesCount];
    [aCoder encodeObject:_source forKey:kSinaRetweetedStatusSource];
    [aCoder encodeDouble:_textLength forKey:kSinaRetweetedStatusTextLength];
    [aCoder encodeDouble:_sourceType forKey:kSinaRetweetedStatusSourceType];
    [aCoder encodeObject:_idstr forKey:kSinaRetweetedStatusIdstr];
    [aCoder encodeObject:_mid forKey:kSinaRetweetedStatusMid];
    [aCoder encodeBool:_truncated forKey:kSinaRetweetedStatusTruncated];
    [aCoder encodeObject:_hotWeiboTags forKey:kSinaRetweetedStatusHotWeiboTags];
    [aCoder encodeDouble:_sourceAllowclick forKey:kSinaRetweetedStatusSourceAllowclick];
    [aCoder encodeObject:_darwinTags forKey:kSinaRetweetedStatusDarwinTags];
    [aCoder encodeObject:_inReplyToScreenName forKey:kSinaRetweetedStatusInReplyToScreenName];
    [aCoder encodeDouble:_commentsCount forKey:kSinaRetweetedStatusCommentsCount];
    [aCoder encodeObject:_originalPic forKey:kSinaRetweetedStatusOriginalPic];
    [aCoder encodeObject:_picUrls forKey:kSinaRetweetedStatusPicUrls];
    [aCoder encodeBool:_isLongText forKey:kSinaRetweetedStatusIsLongText];
    [aCoder encodeDouble:_repostsCount forKey:kSinaRetweetedStatusRepostsCount];
    [aCoder encodeObject:_thumbnailPic forKey:kSinaRetweetedStatusThumbnailPic];
    [aCoder encodeBool:_favorited forKey:kSinaRetweetedStatusFavorited];
    [aCoder encodeObject:_textTagTips forKey:kSinaRetweetedStatusTextTagTips];
    [aCoder encodeObject:_bmiddlePic forKey:kSinaRetweetedStatusBmiddlePic];
    [aCoder encodeObject:_geo forKey:kSinaRetweetedStatusGeo];
    [aCoder encodeDouble:_retweetedStatusIdentifier forKey:kSinaRetweetedStatusId];
    [aCoder encodeObject:_user forKey:kSinaRetweetedStatusUser];
    [aCoder encodeObject:_inReplyToUserId forKey:kSinaRetweetedStatusInReplyToUserId];
    [aCoder encodeDouble:_userType forKey:kSinaRetweetedStatusUserType];
    [aCoder encodeObject:_bizIds forKey:kSinaRetweetedStatusBizIds];
    [aCoder encodeObject:_text forKey:kSinaRetweetedStatusText];
    [aCoder encodeDouble:_bizFeature forKey:kSinaRetweetedStatusBizFeature];
    [aCoder encodeDouble:_mlevel forKey:kSinaRetweetedStatusMlevel];
    [aCoder encodeObject:_createdAt forKey:kSinaRetweetedStatusCreatedAt];
    [aCoder encodeObject:_visible forKey:kSinaRetweetedStatusVisible];
    [aCoder encodeObject:_inReplyToStatusId forKey:kSinaRetweetedStatusInReplyToStatusId];
}

- (id)copyWithZone:(NSZone *)zone
{
    SinaRetweetedStatus *copy = [[SinaRetweetedStatus alloc] init];
    
    if (copy) {

        copy.attitudesCount = self.attitudesCount;
        copy.source = [self.source copyWithZone:zone];
        copy.textLength = self.textLength;
        copy.sourceType = self.sourceType;
        copy.idstr = [self.idstr copyWithZone:zone];
        copy.mid = [self.mid copyWithZone:zone];
        copy.truncated = self.truncated;
        copy.hotWeiboTags = [self.hotWeiboTags copyWithZone:zone];
        copy.sourceAllowclick = self.sourceAllowclick;
        copy.darwinTags = [self.darwinTags copyWithZone:zone];
        copy.inReplyToScreenName = [self.inReplyToScreenName copyWithZone:zone];
        copy.commentsCount = self.commentsCount;
        copy.originalPic = [self.originalPic copyWithZone:zone];
        copy.picUrls = [self.picUrls copyWithZone:zone];
        copy.isLongText = self.isLongText;
        copy.repostsCount = self.repostsCount;
        copy.thumbnailPic = [self.thumbnailPic copyWithZone:zone];
        copy.favorited = self.favorited;
        copy.textTagTips = [self.textTagTips copyWithZone:zone];
        copy.bmiddlePic = [self.bmiddlePic copyWithZone:zone];
        copy.geo = [self.geo copyWithZone:zone];
        copy.retweetedStatusIdentifier = self.retweetedStatusIdentifier;
        copy.user = [self.user copyWithZone:zone];
        copy.inReplyToUserId = [self.inReplyToUserId copyWithZone:zone];
        copy.userType = self.userType;
        copy.bizIds = [self.bizIds copyWithZone:zone];
        copy.text = [self.text copyWithZone:zone];
        copy.bizFeature = self.bizFeature;
        copy.mlevel = self.mlevel;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.visible = [self.visible copyWithZone:zone];
        copy.inReplyToStatusId = [self.inReplyToStatusId copyWithZone:zone];
    }
    
    return copy;
}


@end
