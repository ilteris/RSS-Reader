//
//  IKImageDownloader.h
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  
//

#import <Foundation/Foundation.h>


@class IKArticle;

@interface IKImageDownloader : NSObject
@property (nonatomic, strong) IKArticle *article;
@property (nonatomic, copy) void (^completionHandler)(void);


- (void)startDownload;
- (void)cancelDownload;


@end
