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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"english in the articlelist");
            [defaults setInteger:0 forKey:@"language"]; //0 english 1 martian

            break;
        case 1:
            NSLog(@"martin in the articlelist");
            [defaults setInteger:1 forKey:@"language"]; //0 english 1 martian

            break;
            
        default:
            break;
    }
    
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

   cell.titleLabel.text = article.title;
    
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
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
    }
}




@end
