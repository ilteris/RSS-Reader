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
@property (nonatomic, strong) NSString *titleMartian;
/*I generally like to keep models clean and don't do things like
 title/titleMartian. (especially considering possible future situations: what
 if we want to implement 10 languages?).
 
 In anycase I did it here because otherwise I had to bring a temporary storage on
 the tableviewcontroller on top of NYTArticleListProvider which would be a lot dirty
 and confusing in my humble opinion.
 */
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *bodyMartian;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) UIImage *articleImage;

@end
