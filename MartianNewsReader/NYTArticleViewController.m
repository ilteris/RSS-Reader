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


#define HEIGHT_IPHONE_5 568
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5 )

@implementation NYTArticleViewController
- (NYTArticleViewController *)initWithArticle:(NYTArticle *)anArticle {
    if(IS_IPHONE_5)
    {
        NSLog(@"iphone5");
        self=[super initWithNibName:@"NYTArticleViewController_ip5" bundle:nil];
    }
    else
    {
    NSLog(@"iphone4");
        self=[super initWithNibName:@"NYTArticleViewController_ip4" bundle:nil];
    }
    //I changed the constructor to initWithNibName. My reasoning: I wanted to keep the
    //layout code outside of my classes. I prefer IB to programmatically creating layouts
    // since I find it faster.
    
    //I prefer to use separate nibs for separate iphones here since I don't trust
   // autolayout in IB just yet and it's also cleaner to separate views in my humble opinion.
    // I am completely flexible to do everything programmatically if required.
    
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
    self.body.text = self.article.body;
    self.titleText.text = self.article.title;
    self.imageView.image = self.article.articleImage;
    
    //initial load, get the value from the persisted nsdefaults and apply the translation.
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
            [self convertToEnglish];
            break;
        case 1:
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
