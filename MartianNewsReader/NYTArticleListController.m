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


@interface NYTArticleListController ()


@end

@implementation NYTArticleListController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.articleListProvider = [[NYTArticleListProvider alloc] init];
    }
    return self;
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NYTArticle  *article = [self.articleListProvider articleAtIndex:[indexPath row]];

   
    
    cell.textLabel.text = [[self.articleListProvider articleAtIndex:[indexPath row]] valueForKey:@"title"];//article.title;
   // cell.detailTextLabel.text = appRecord.artist;
    
 //   [NSException raise:@"NYTNotYetImplementedException" format:@""];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NYTArticleViewController *articleViewController = [[NYTArticleViewController alloc] initWithArticle:
            [self.articleListProvider articleAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:articleViewController animated:YES];
}


@end
