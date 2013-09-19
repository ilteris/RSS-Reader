//
//  NYTImageDownloader.m
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

#import "NYTImageDownloader.h"
#import "NYTArticle.h"

#define kAppIconSize 48

@interface NYTImageDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@end



@implementation NYTImageDownloader
#pragma mark

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.article.imageURLString]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set  and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
	{
        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.article.articleImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.article.articleImage = image;
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}




@end
