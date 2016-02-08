//
// Created by Dmitry Korotchenkov on 06.09.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSString (DKAdditions)
- (NSUInteger)matchesSubstring:(NSString *)substring;

- (NSString *)stringByReplaceCharacterSet:(NSCharacterSet *)characterSet withString:(NSString *)string;
@end