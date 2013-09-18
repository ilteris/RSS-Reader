//
//  NYTArticleViewController.m
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import "NYTArticleViewController.h"

@interface NYTArticleViewController ()

@property(nonatomic, strong) id article;

@end

@implementation NYTArticleViewController

- (NYTArticleViewController *)initWithArticle:(id)anArticle {
    self = [super init];
    if (self) {
        self.article = anArticle;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
