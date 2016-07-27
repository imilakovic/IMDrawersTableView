//
//  IMDrawersTableViewCell.m
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import "IMDrawersTableViewCell.h"

@implementation IMDrawersTableViewCell

#pragma mark - Init

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}


#pragma mark - Public

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    _contentView = nil;
    _contentView = contentView;
    
    [self addSubview:_contentView];
}


- (void)setHeaderView:(UIView *)headerView {
    [_headerView removeFromSuperview];
    _headerView = nil;
    _headerView = headerView;
    
    [self addSubview:_headerView];
    
    _headerView.userInteractionEnabled = YES;
    [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
}


#pragma mark - Layout

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGSize size = self.bounds.size;
    
    _headerView.frame = CGRectMake(0.0, 0.0, size.width, _headerHeight);
    _contentView.frame = CGRectMake(0.0, _headerHeight, size.width, size.height - _headerHeight);
}


#pragma mark - Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(cellHeaderTapped:)]) {
        [_delegate cellHeaderTapped:self];
    }
}


@end
