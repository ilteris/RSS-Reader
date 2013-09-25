//
//  IKArticle.h
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  
//

#import <Foundation/Foundation.h>

@interface IKArticle : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) UIImage *articleImage;

@end
