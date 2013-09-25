//
//  IKParser.h
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  
//

#import <Foundation/Foundation.h>

@interface IKParser : NSOperation

// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);

// NSArray containing IKArticle instances for each entry parsed
// from the input data.
@property (nonatomic, strong, readonly) NSArray *articlesList;

// The initializer for this NSOperation subclass.
- (id)initWithData:(NSData *)data;

@end
