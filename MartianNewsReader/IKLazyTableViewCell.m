//
//  IKLazyTableViewCell.m
//  MartianNewsReader
//
//  Created by ilteris on 9/18/13.
//  
//

#import "IKLazyTableViewCell.h"

@implementation IKLazyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
