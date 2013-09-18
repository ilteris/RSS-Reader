//
//  NYTArticleViewController.h
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYTArticleListProvider.h"

@interface NYTArticleViewController : UIViewController

- (NYTArticleViewController *)initWithArticle:(NYTArticle *)anArticle;

@end
