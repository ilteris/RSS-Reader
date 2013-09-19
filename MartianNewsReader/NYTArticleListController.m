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
        self.articleListProvider = [[NYTArticleListProvider alloc] init];
    }
    return self;
}


- (void) viewDidLoad
{
    //add segmented control programmatically
    NSArray *itemArray = [NSArray arrayWithObjects: @"English", @"Martian", nil];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl.frame = CGRectMake(70, 10, 180, 25);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    //set nsdefaults for persistance
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(!defaults) {
       // self.segmentedControl.selectedSegmentIndex = 0;
       // [defaults setInteger:0 forKey:@"language"]; //0 english 1 martian
    } else {
        NSLog(@"here is self.segmentedControl.selectedSegmentIndex %i", self.segmentedControl.selectedSegmentIndex);
        self.segmentedControl.selectedSegmentIndex = [defaults integerForKey:@"language"];
        NSLog(@"here is self.segmentedControl.selectedSegmentIndex %i", self.segmentedControl.selectedSegmentIndex);

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
    
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"english self.segmentedControl.selectedSegmentIndex is %i", self.segmentedControl.selectedSegmentIndex);
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"language"]; //0 english 1 martian
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 1:
            NSLog(@"martin self.segmentedControl.selectedSegmentIndex is %i", self.segmentedControl.selectedSegmentIndex);
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"language"]; //0 english 1 martian
            [[NSUserDefaults standardUserDefaults] synchronize];

            break;
            
        default:
            break;
    }
    
    //post notification we choose notifications because we don't care who the receiver is. we broadcast and don't worry about the rest.
    
    NSString *notificationName = @"NYTSegmentedControlNotification";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.segmentedControl.selectedSegmentIndex] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
  
    
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
    
    if (!cell) {
        cell = [[NYTLazyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NYTArticle  *article = [self.articleListProvider articleAtIndex:[indexPath row]];
    
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
