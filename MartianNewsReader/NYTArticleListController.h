//
//  NYTArticleListController.h
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//


#import <UIKit/UIKit.h>

@class NYTArticleListProvider;

@interface NYTArticleListController : UITableViewController
@property (nonatomic, strong) NYTArticleListProvider *articleListProvider;


@end
