//
//  IKArticleViewController.h
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKArticleListProvider.h"

@interface IKArticleViewController : UIViewController

- (IKArticleViewController *)initWithArticle:(IKArticle *)anArticle;

@end
