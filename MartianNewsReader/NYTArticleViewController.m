//
//  NYTArticleViewController.m
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import "NYTArticleViewController.h"
#import "NYTArticle.h"
#import <Foundation/NSRegularExpression.h>
#import "NSString+Translation.h"

@interface NYTArticleViewController ()

@property(nonatomic, strong) NYTArticle *article;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

@end

@implementation NYTArticleViewController

- (NYTArticleViewController *)initWithArticle:(NYTArticle *)anArticle {
    self = [super initWithNibName:@"NYTArticleViewController" bundle:nil];
    //change of code so I can use nib file
    if (self) {
        self.article = anArticle;

    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
   // self.title.text = self.article.title;
    self.body.text = self.article.body;
    self.titleText.text = self.article.title;
    self.imageView.image = self.article.articleImage;
    
    //initial load, get the value from the nsdefaults and apply the language
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    
    if(![defaults integerForKey:@"language"]) {
        [self convertToEnglish];
    } else {
        self.body.text =  [self.article.body convertToMartian:self.article.body];
        self.titleText.text = [self.article.body convertToMartian:self.article.title];
    }
    
    //register for notifications for the segmentedcontrol changes coming from parentviewcontroller
    NSString *notificationName = @"NYTSegmentedControlNotification";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(segmentedControlIndexChanged:)
     name:notificationName
     object:nil];
    
}


- (void)segmentedControlIndexChanged:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    NSInteger index = [[dictionary valueForKey:@"index"] intValue];
    //index is coming from segmentedcontrol
    switch (index) {
        case 0:
            NSLog(@"english");
            [self convertToEnglish];
            break;
        case 1:
            NSLog(@"martian");
            self.body.text =  [self.article.body convertToMartian:self.article.body];
            self.titleText.text = [self.article.body convertToMartian:self.article.title];
            
            break;
            
        default:
            break;
    }
    
    
}

- (void)convertToEnglish
{
    self.body.text = self.article.body;
    self.titleText.text = self.article.title;

}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
