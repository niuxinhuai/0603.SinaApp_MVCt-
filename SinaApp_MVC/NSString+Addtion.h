//
//  NSString+Addtion.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/19.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Addtion)
-(NSString*)sinaSourceString;
-(NSString*)timeString;
-(NSArray<NSTextCheckingResult *>*)matchStringWithPattern:(NSString*)pattern;
-(NSAttributedString*)sinaString;
@end
