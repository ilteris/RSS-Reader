//
//  NYTArticle.h
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYTArticle : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, strong) NSString *imageURLString;
@end
