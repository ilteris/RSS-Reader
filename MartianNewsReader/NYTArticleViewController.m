//
//  NYTArticleViewController.m
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import "NYTArticleViewController.h"
#import "NYTArticle.h"


@interface NYTArticleViewController ()

@property(nonatomic, strong) NYTArticle *article;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

@end

@implementation NYTArticleViewController

- (NYTArticleViewController *)initWithArticle:(NYTArticle *)anArticle {
    self = [super initWithNibName:@"NYTArticleViewController" bundle:nil];
    if (self) {
        self.article = anArticle;

    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewDidLoad
{
   // self.title.text = self.article.title;
    self.body.text = self.article.body;
    self.titleText.text = self.article.title;
}
@end
