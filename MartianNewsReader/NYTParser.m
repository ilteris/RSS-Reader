//
//  NYTParser.m
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

#import "NYTParser.h"
#import "NYTArticle.h"
#import "NSString+Translation.h"

@interface NYTParser ()
// Redeclare articlesList so we can modify it.
@property (nonatomic, strong) NSArray *articlesList;
@property (nonatomic, strong) NSMutableArray *workingArray;

@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) NYTArticle *article;
@end



@implementation NYTParser


- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self != nil)
    {
        _dataToParse = data;
    }
    return self;
}


- (void)main
{
   
    NSError *error;
   
    NSPropertyListFormat plistFormat;
    NSArray *temp = [NSPropertyListSerialization propertyListWithData:_dataToParse options:NSPropertyListImmutable format:&plistFormat error:&error];
    
    self.workingArray = [NSMutableArray array];
    

    for (NSDictionary *articleDict in temp) {
        NYTArticle *article = [[NYTArticle alloc] init];
        article.title = [articleDict valueForKey:@"title"];
        article.body = [articleDict valueForKey:@"body"];
        article.images = [NSArray arrayWithArray:[articleDict valueForKey:@"images"]];
        article.imageURLString = [article.images[0] valueForKey:@"url"];
        [self.workingArray addObject:article];
    }
    
    if (![self isCancelled])
    {
        self.articlesList = [NSArray arrayWithArray:self.workingArray];
    }
    self.dataToParse = nil;
}



@end
