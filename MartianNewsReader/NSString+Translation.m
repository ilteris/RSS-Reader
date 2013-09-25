//
//  NSString+Translation.m
//  MartianNewsReader
//
//  Created by ilteris on 9/19/13.
//  Category for converting String to Martian language.

#import "NSString+Translation.h"

@implementation NSString (Translation)
- (NSString *)convertToMartian:(NSString *)aString
{
    
    NSString *currentString = aString;
    
    // Regular expression to find all words greater than 3 characters
    NSRegularExpression *regex;
    regex = [NSRegularExpression regularExpressionWithPattern:@"([\\w[’']]{4,})"
                                                      options:0
                                                        error:NULL];
    
    NSMutableString *modifiedString = [currentString mutableCopy];
    __block int offset = 0;
    [regex enumerateMatchesInString:currentString options:0 range:NSMakeRange(0, [currentString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange range = [result rangeAtIndex:0];
        // NSLog(@"range is %@", NSStringFromRange(range));
        // Adjust location for modifiedString:
        range.location += offset;
        // Get old word:
        NSString *oldWord = [modifiedString substringWithRange:range];
        //check if word's first letter is capitalized
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[oldWord characterAtIndex:0]];
        NSString *newWord;
        //  should be translated to the word "boinga" or "Boinga"
        if (isUppercase == YES) {
            newWord = [NSString stringWithFormat:@"Boinga"];
        }
        else
        {
            newWord = [NSString stringWithFormat:@"boinga"];
        }
        // Replace new word in modifiedString:
        [modifiedString replaceCharactersInRange:range withString:newWord];
        // Update offset:
        offset += [newWord length] - [oldWord length];
    }
     ];
    
    return modifiedString;
}


@end
