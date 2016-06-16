//
//  SinaRetweetedStatus.h
//
//  Created by   on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SinaUser, SinaVisible;

@interface SinaRetweetedStatus : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double attitudesCount;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) double textLength;
@property (nonatomic, assign) double sourceType;
@property (nonatomic, strong) NSString *idstr;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, assign) BOOL truncated;
@property (nonatomic, strong) NSArray *hotWeiboTags;
@property (nonatomic, assign) double sourceAllowclick;
@property (nonatomic, strong) NSArray *darwinTags;
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, assign) double commentsCount;
@property (nonatomic, strong) NSString *originalPic;
@property (nonatomic, strong) NSArray *picUrls;
@property (nonatomic, assign) BOOL isLongText;
@property (nonatomic, assign) double repostsCount;
@property (nonatomic, strong) NSString *thumbnailPic;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, strong) NSArray *textTagTips;
@property (nonatomic, strong) NSString *bmiddlePic;
@property (nonatomic, assign) id geo;
@property (nonatomic, assign) double retweetedStatusIdentifier;
@property (nonatomic, strong) SinaUser *user;
@property (nonatomic, strong) NSString *inReplyToUserId;
@property (nonatomic, assign) double userType;
@property (nonatomic, strong) NSArray *bizIds;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) double bizFeature;
@property (nonatomic, assign) double mlevel;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) SinaVisible *visible;
@property (nonatomic, strong) NSString *inReplyToStatusId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
