//
//  SinaStatuses.h
//
//  Created by   on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class SinaRetweetedStatus, SinaUser, SinaVisible;

@interface SinaStatuses : NSObject <NSCoding, NSCopying>

//给model 添加了两个属性
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat showImageHeight;

//转发视图的文字高度和图片高度
@property (nonatomic, assign) CGFloat retTextHeight;
@property (nonatomic, assign) CGFloat retShowImageHeight;

@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL truncated;
@property (nonatomic, assign) double statusesIdentifier;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, assign) BOOL isLongText;
@property (nonatomic, strong) NSArray *picUrls;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *idstr;
@property (nonatomic, assign) double textLength;
@property (nonatomic, assign) double sourceType;
@property (nonatomic, strong) NSArray *hotWeiboTags;
@property (nonatomic, strong) SinaRetweetedStatus *retweetedStatus;
@property (nonatomic, assign) id geo;
@property (nonatomic, assign) double pageType;
@property (nonatomic, strong) SinaUser *user;
@property (nonatomic, strong) NSArray *textTagTips;
@property (nonatomic, assign) double commentsCount;
@property (nonatomic, strong) NSString *thumbnailPic;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) double sourceAllowclick;
@property (nonatomic, assign) double bizFeature;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) NSString *bmiddlePic;
@property (nonatomic, strong) SinaVisible *visible;
@property (nonatomic, strong) NSArray *bizIds;
@property (nonatomic, strong) NSString *inReplyToStatusId;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *cardid;
@property (nonatomic, assign) double repostsCount;
@property (nonatomic, assign) double userType;
@property (nonatomic, assign) double attitudesCount;
@property (nonatomic, strong) NSArray *darwinTags;
@property (nonatomic, assign) double mlevel;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *inReplyToUserId;
@property (nonatomic, strong) NSString *originalPic;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
