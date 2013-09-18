//
//  NYTArticleListProviderTests.m
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NYTArticleListProvider.h"

@interface NYTArticleListProviderTests : SenTestCase

- (void)assertArticle:(id)article hasMartianTitleText:(NSString *)expectedText;
- (void)assertArticle:(id)article hasMartianBodyText:(NSString *)expectedText;

@end

@implementation NYTArticleListProviderTests


- (void)testArticleDataIsTranslated {
    NSArray *articles =
  @[
    @{
      @"title": @"Welcome to the Test!",
      @"body": @"Or if you'd rather, check out The New York Times online.",
      @"images":@[]
    }
  ];

    NYTArticleListProvider *articleListProvider = [[NYTArticleListProvider alloc] initWithArticles:articles];
    [self assertArticle:[articleListProvider articleAtIndex:0] hasMartianTitleText:@"Boinga to the Boinga!"];
    [self assertArticle:[articleListProvider articleAtIndex:0] hasMartianBodyText:@"Or if boinga boinga, boinga out The New Boinga Boinga boinga."];
}

- (void)assertArticle:(id)article hasMartianTitleText:(NSString *)expectedText {
    [NSException raise:@"NYTNotYetImplementedException" format:@""];
}

- (void)assertArticle:(id)article hasMartianBodyText:(NSString *)expectedText {
    [NSException raise:@"NYTNotYetImplementedException" format:@""];
}


@end
