//
//  IKArticleListProvider.h
//  MartianNewsReader
//

//

#import <Foundation/Foundation.h>

@class IKArticle;

@interface IKArticleListProvider : NSObject
@property (nonatomic, copy) NSArray *articles;

// For testing
- (id)initWithArticles:(NSArray *)someArticles;
- (NSInteger)articleCount;
- (IKArticle *) articleAtIndex:(NSInteger)index;

@end
