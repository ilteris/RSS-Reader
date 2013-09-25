//
//  IKLazyTableViewCell.h
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  
//

#import <UIKit/UIKit.h>

@interface IKLazyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
