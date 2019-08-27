//
//  FYSystemBaseCell.m
//  Project
//
//  Created by Mike on 2019/4/15.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYSystemBaseCell.h"

@implementation FYSystemBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Remove touch delay for iOS 7
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = SSChatCellColor;
        self.contentView.backgroundColor = SSChatCellColor;
        [self initChatCellUI];
    }
    return self;
}


-(void)initChatCellUI {
    
}

-(void)setModel:(FYMessagelLayoutModel *)model{
    _model = model;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
