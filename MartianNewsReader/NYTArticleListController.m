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
    [self.tableView registerNib:[UINib nibWithNibName:@"LazyTableCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"LazyTableCell"];
    
    [self.navigationController.navigationBar.topItem setTitle:@"Martian Times"];
    
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
        [self startIconDownload:article forIndexPath:indexPath];

    }
    else
    {
       // cell.imageView.image = article.articleImage;
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

- (void)startIconDownload:(NYTArticle *)article forIndexPath:(NSIndexPath *)indexPath
{
    NYTImageDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[NYTImageDownloader alloc] init];
        iconDownloader.article = article;
        [iconDownloader setCompletionHandler:^{
            
            NYTLazyTableViewCell *cell = (NYTLazyTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.cellImageView.image = article.articleImage;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}




@end
