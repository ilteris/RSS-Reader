//
//  NYTImageDownloader.h
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NYTArticle;

@interface NYTImageDownloader : NSObject
@property (nonatomic, strong) NYTArticle *article;
@property (nonatomic, copy) void (^completionHandler)(void);


- (void)startDownload;
- (void)cancelDownload;


@end
