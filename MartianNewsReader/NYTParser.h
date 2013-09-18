//
//  NYTParser.h
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYTParser : NSOperation

// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);

// NSArray containing NYTArticle instances for each entry parsed
// from the input data.
@property (nonatomic, strong, readonly) NSArray *articlesList;

// The initializer for this NSOperation subclass.
- (id)initWithData:(NSData *)data;

@end
