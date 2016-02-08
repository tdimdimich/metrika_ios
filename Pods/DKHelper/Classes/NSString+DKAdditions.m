//
// Created by Dmitry Korotchenkov on 06.09.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSString+DKAdditions.h"


@implementation NSString (DKAdditions)

- (NSUInteger)matchesSubstring:(NSString *)substring {
    NSRange searchRange = NSMakeRange(0, self.length);
    NSRange foundRange;
    NSUInteger matches = 0;
    while (searchRange.location < self.length) {
        searchRange.length = self.length - searchRange.location;
        foundRange = [self rangeOfString:substring options:nil range:searchRange];
        if (foundRange.location != NSNotFound) {
            matches++;
            searchRange.location = foundRange.location + foundRange.length;
        } else {
            break;
        }
    }
    return matches;
}

- (NSString *)stringByReplaceCharacterSet:(NSCharacterSet *)characterSet withString:(NSString *)string {
    NSString *result = self;
    NSRange range = [result rangeOfCharacterFromSet:characterSet];

    while (range.location != NSNotFound) {
        result = [result stringByReplacingCharactersInRange:range withString:string];
        range = [result rangeOfCharacterFromSet:characterSet];
    }
    return result;
}

@end