//
//  NYTAppDelegate.m
//  MartianNewsReader
//

//  Copyright (c) 2012 The New York Times Company. All rights reserved.
//

#import "NYTAppDelegate.h"

#import "NYTArticleListController.h"

// This framework was imported so we could use the kCFURLErrorNotConnectedToInternet error code.
#import <CFNetwork/CFNetwork.h>
#import "NYTParser.h"
#import "NYTArticleListProvider.h"

static NSString *const NYTArticlesFeed =
@"http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.plist";

@interface NYTAppDelegate ()
// the queue to run our "ParseOperation"
@property (nonatomic, strong) NSOperationQueue *queue;

//network connection to the AWS
@property (nonatomic, strong) NSURLConnection *articlesListFeedConnection;
@property (nonatomic, strong) NSMutableData *articlesListData;
@end


@implementation NYTAppDelegate

#pragma mark -


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[UINavigationController alloc] initWithRootViewController:[[NYTArticleListController alloc] initWithStyle:UITableViewStylePlain]];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:NYTArticlesFeed]];
    self.articlesListFeedConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // Test the validity of the connection object.
    NSAssert(self.articlesListFeedConnection != nil, @"Failure to create URL connection.");
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    return YES;
}


// -------------------------------------------------------------------------------
//	handleError:error
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show NYT Articles"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
}

// The following are delegate methods for NSURLConnection. Similar to callback functions, this is how
// the connection object,  which is working in the background, can asynchronously communicate back to
// its delegate on the thread from which it was started - in this case, the main thread.
//
#pragma mark - NSURLConnectionDelegate methods

// -------------------------------------------------------------------------------
//	connection:didReceiveResponse:response
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.articlesListData = [NSMutableData data];    // start off with new data
}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.articlesListData appendData:data];  // append incoming data
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleError:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    self.articlesListFeedConnection = nil;   // release our connection
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.articlesListFeedConnection = nil;   // release our connection
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    // create the queue to run our ParseOperation
    self.queue = [[NSOperationQueue alloc] init];
    
    // create an ParseOperation (NSOperation subclass) to parse the RSS feed data
    // so that the UI is not blocked
    NYTParser *parser = [[NYTParser alloc] initWithData:self.articlesListData];
    
    parser.errorHandler = ^(NSError *parseError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleError:parseError];
        });
    };
    
    // Referencing parser from within its completionBlock would create a retain
    // cycle.
    __weak NYTParser *weakParser = parser;
    
    parser.completionBlock = ^(void) {
        if (weakParser.articlesList) {
            
            NYTArticleListController *nytArticleListController = (NYTArticleListController*)[(UINavigationController*)self.window.rootViewController topViewController];
            NYTArticleListProvider *tempProvide = [[NYTArticleListProvider alloc] initWithArticles:weakParser.articlesList];
            
            nytArticleListController.articleListProvider = tempProvide;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // The completion block may execute on any thread.  Because operations
                // involving the UI are about to be performed, make sure they execute
                // on the main thread.
                
                // tell our table view to reload its data, now that parsing has completed
                [nytArticleListController.tableView reloadData];
                
            });
        }
        
        // we are finished with the queue and our ParseOperation
        self.queue = nil;
    };
    
    [self.queue addOperation:parser]; // this will start the "ParseOperation"
    
    // ownership of appListData has been transferred to the parse operation
    // and should no longer be referenced in this thread
    self.articlesListData = nil;
    
}




@end
