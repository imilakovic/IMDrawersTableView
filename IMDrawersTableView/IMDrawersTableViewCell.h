//
//  IMDrawersTableViewCell.h
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMDrawersTableViewCellDelegate;

@interface IMDrawersTableViewCell : UIView

@property (weak, nonatomic) id<IMDrawersTableViewCellDelegate> delegate;
@property (assign, nonatomic) CGFloat headerHeight;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *headerView;

@end


@protocol IMDrawersTableViewCellDelegate <NSObject>

- (void)cellHeaderTapped:(IMDrawersTableViewCell *)cell;

@end
