//
//  NYTArticleListProvider.h
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYTArticleListProvider : NSObject

// For testing
- (id)initWithArticles:(NSArray *)someArticles;

- (NSInteger)articleCount;
- (id)articleAtIndex:(NSInteger)index;

@end
