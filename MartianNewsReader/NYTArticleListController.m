//
//  NYTArticleListController.m
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import "NYTArticleListController.h"
#import "NYTArticleListProvider.h"
#import "NYTArticleViewController.h"
#import "NYTArticle.h"
#import "NYTImageDownloader.h"
#import "NYTLazyTableViewCell.h"
#import "NSString+Translation.h"

@interface NYTArticleListController ()

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation NYTArticleListController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        //self.articleListProvider = [[NYTArticleListProvider alloc] init];
        //considering we don't wait for articles to be downloaded in order to create the tableview(asynchronous),
        //allocating a nil articleListProvider here is redundant. Still seeing it implemented initially
        //makes me feel little anxious and also makes me believe I am overseeing something important here.
        //Happy to discuss more.
    }
    return self;
}


- (void) viewDidLoad
{
    //add segmented control programmatically and attach it to navbar.
    NSArray *itemArray = [NSArray arrayWithObjects: @"English", @"Martian", nil];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl.frame = CGRectMake(70, 10, 180, 25);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    //set nsdefaults for persistance
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(!defaults) { //first time, set it to english
        self.segmentedControl.selectedSegmentIndex = 0;
        [defaults setInteger:0 forKey:@"language"]; //0 english 1 martian
    } else {
        self.segmentedControl.selectedSegmentIndex = [defaults integerForKey:@"language"];
    }
    self.navigationController.toolbarHidden = NO;
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.toolbar addSubview:self.segmentedControl];
    
    [self.navigationController.navigationBar.topItem setTitle:@"Martian Times"];
    
    //register our custom tableview cell
    [self.tableView registerNib:[UINib nibWithNibName:@"LazyTableCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"LazyTableCell"];
}

-(void) segmentedControlIndexChanged {
        //this selector is called whenever we choose any segment control, even when we are inside articleViewController.
        //so I post a notification below for articleViewController to pick up the change when it's in the stack.
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"language"]; //0 english 1 martian
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"language"]; //0 english 1 martian
            [[NSUserDefaults standardUserDefaults] synchronize];

            break;
            
        default:
            break;
    }
    
    //post a notification ->
    //I could have created a protocol and conform articleViewController to this protocol as well, but I wanted to use a
    //NSNotification here because we don't care who the receiver is. we broadcast and don't worry about the rest.
    
    
    NSString *notificationName = @"NYTSegmentedControlNotification";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.segmentedControl.selectedSegmentIndex] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
  
    //reload the tableview each time user changes the segmentedcontrol.
    [self.tableView reloadData];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articleListProvider articleCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LazyTableCell";
    NYTLazyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // I prefer to have full control over cells to customize them in IB, thus custom view cell class. 
    if (!cell) {
        cell = [[NYTLazyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NYTArticle  *article = [self.articleListProvider articleAtIndex:[indexPath row]];
    
    //since it's not a requirement to persist text, I prefer it to apply translation category to change the text on the fly and not save it anywhere.
    (!self.segmentedControl.selectedSegmentIndex) ? [cell.titleLabel setText:article.title] : [cell.titleLabel setText:[article.title convertToMartian:article.title]];
    
    if(!article.articleImage)
    {
        [self startImageDownload:article forIndexPath:indexPath];
    }
    else
    {
        cell.cellImageView.image = article.articleImage;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NYTArticleViewController *articleViewController = [[NYTArticleViewController alloc] initWithArticle:
                                                       [self.articleListProvider articleAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:articleViewController animated:YES];
}



#pragma mark - Table cell image support

- (void)startImageDownload:(NYTArticle *)article forIndexPath:(NSIndexPath *)indexPath
{
    NYTImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[NYTImageDownloader alloc] init];
        imageDownloader.article = article;
        [imageDownloader setCompletionHandler:^{
            
            NYTLazyTableViewCell *cell = (NYTLazyTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.cellImageView.image = article.articleImage;
            
            // Remove the imageDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
    }
}




@end
