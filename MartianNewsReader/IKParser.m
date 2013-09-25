//
//  IKParser.m
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  
//

#import "IKParser.h"
#import "IKArticle.h"
#import "NSString+Translation.h"

@interface IKParser ()
// Redeclare articlesList so we can modify it.
@property (nonatomic, strong) NSArray *articlesList;
@property (nonatomic, strong) NSMutableArray *workingArray;

@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) IKArticle *article;
@end



@implementation IKParser


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
   
    //Using NSPropertyListSerialization in order to parse the plist file.
    NSPropertyListFormat plistFormat;
    NSArray *temp = [NSPropertyListSerialization propertyListWithData:_dataToParse options:NSPropertyListImmutable format:&plistFormat error:&error];
    
    self.workingArray = [NSMutableArray array];
    

    for (NSDictionary *articleDict in temp) {
        IKArticle *article = [[IKArticle alloc] init];
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
