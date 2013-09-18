//
//  NYTArticleListProvider.h
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NYTArticle;

@interface NYTArticleListProvider : NSObject
@property (nonatomic, copy) NSArray *articles;

// For testing
- (id)initWithArticles:(NSArray *)someArticles;

- (NSInteger)articleCount;
- (NYTArticle *) articleAtIndex:(NSInteger)index;

@end
