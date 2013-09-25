//
//  IKArticleListProvider.m
//  MartianNewsReader
//

//

#import "IKArticleListProvider.h"
#import "IKArticle.h"

@implementation IKArticleListProvider

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

- (IKArticle *) articleAtIndex:(NSInteger)index {
    return self.articles[index];
}
@end
