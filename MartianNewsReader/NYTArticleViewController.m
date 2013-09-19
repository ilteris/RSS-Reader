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
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

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
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"English", @"Martian", nil];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl.frame = CGRectMake(70, 5, 180, 30);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    
    
    //[self.navigationController.navigationBar addSubview:self.segmentedControl];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    
    if(![defaults integerForKey:@"language"]) {
        [self convertToEnglish];
    } else {
        self.body.text =  [self convertToMartian:self.article.body];
        self.titleText.text = [self convertToMartian:self.article.title];
    }
}


-(void) segmentedControlIndexChanged {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"english");
            [defaults setInteger:0 forKey:@"language"]; //0 english 1 martian
            [self convertToEnglish];
            break;
        case 1:
            NSLog(@"martian");
            [defaults setInteger:1 forKey:@"language"]; //0 english 1 martian
            self.body.text =  [self convertToMartian:self.article.body];
            self.titleText.text = [self convertToMartian:self.article.title];
            
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


- (NSString *)convertToMartian:(NSString *)aString
{

    NSString *currentString = aString;
    
    // Regular expression to find all words greater than 3 characters
    NSRegularExpression *regex;
    regex = [NSRegularExpression regularExpressionWithPattern:@"([\\w[’']]{4,})"
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
        NSLog(@"%@", oldWord);
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
