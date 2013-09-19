//
//  NYTArticleViewController.m
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import "NYTArticleViewController.h"
#import "NYTArticle.h"
#import <Foundation/NSRegularExpression.h>

@interface NYTArticleViewController ()

@property(nonatomic, strong) NYTArticle *article;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

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
    self.imageView.image = self.article.articleImage;
    
    if(!self.article.language) {
        [self convertToEnglish];
    } else {
        self.body.text =  [self convertToMartian:self.article.body];
        self.titleText.text = [self convertToMartian:self.article.title];
    }
    self.segmentedControl.selectedSegmentIndex = self.article.language;
    
}


-(IBAction) segmentedControlIndexChanged{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"english");
            [self convertToEnglish];
            break;
        case 1:
            NSLog(@"martian");
            self.body.text =  [self convertToMartian:self.article.body];
            self.titleText.text = [self convertToMartian:self.article.title];

            break;
            
        default:
            break;
    }
    
}

- (void) convertToEnglish
{
    self.body.text = self.article.body;
    self.titleText.text = self.article.title;
    self.article.language = 0;

}
- (NSString *) convertToMartian:(NSString *)aString
{
    self.article.language = 1;

    
    NSString *currentString = aString;
    
    // Regular expression to find all words greater than 3 characters
    NSRegularExpression *regex;
    regex = [NSRegularExpression regularExpressionWithPattern:@"([\\w']{4,})"
                                                      options:0
                                                        error:NULL];
    
    NSMutableString *modifiedString = [currentString mutableCopy];
    __block int offset = 0;
    [regex enumerateMatchesInString:currentString options:0 range:NSMakeRange(0, [currentString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange range = [result rangeAtIndex:0];
       // NSLog(@"range is %@", NSStringFromRange(range));
        // Adjust location for modifiedString:
        range.location += offset;
        // Get old word:
        NSString *oldWord = [modifiedString substringWithRange:range];
       // NSLog(@"%@", oldWord);
        //check if word's first letter is capitalized
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[oldWord characterAtIndex:0]];
        NSString *newWord;
       //  should be translated to the word "boinga" or "Boinga"
        if (isUppercase == YES) {
            newWord = [NSString stringWithFormat:@"Boinga"];
        }
        else
        {
            newWord = [NSString stringWithFormat:@"boinga"];
        }
        // Replace new word in modifiedString:
        [modifiedString replaceCharactersInRange:range withString:newWord];
        // Update offset:
        offset += [newWord length] - [oldWord length];
    }
     ];
    
    return modifiedString;
}
@end
