//
//  IKArticleListController.h
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//


#import <UIKit/UIKit.h>

@class IKArticleListProvider;

@interface IKArticleListController : UITableViewController
@property (nonatomic, strong) IKArticleListProvider *articleListProvider;


@end
