//
//  NYTArticleListProvider.m
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import "NYTArticleListProvider.h"
#import "NYTArticle.h"

@implementation NYTArticleListProvider

- (id)initWithArticles:(NSArray *)someArticles {
    if (self = [super init])
    {
      self.articles = someArticles;
    }
    return self;
}

- (NSInteger)articleCount {
    return [self.articles count];
}

- (NYTArticle *) articleAtIndex:(NSInteger)index {
    return self.articles[index];
}
@end
