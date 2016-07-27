//
//  IMDrawersTableView.h
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMDrawersTableViewCell.h"

@protocol IMDrawersTableViewDataSource;
@protocol IMDrawersTableViewDelegate;

@interface IMDrawersTableView : UIView <UIScrollViewDelegate>

@property (weak, nonatomic) id<IMDrawersTableViewDataSource> dataSource;
@property (weak, nonatomic) id<IMDrawersTableViewDelegate> delegate;

@property (strong, nonatomic, readonly) NSArray *cells;
@property (strong, nonatomic, readonly) UIView *headerView;

@property (assign, nonatomic) CGFloat cellHeaderHeight;
@property (assign, nonatomic) CGFloat contentInsetTop;

- (void)closeIfNeeded;
- (void)performLayout;

@end


@protocol IMDrawersTableViewDataSource <NSObject>

- (UIView *)headerViewForTableView:(IMDrawersTableView *)tableView;
- (NSInteger)numberOfCellsInTableView:(IMDrawersTableView *)tableView;
- (IMDrawersTableViewCell *)tableView:(IMDrawersTableView *)tableView cellAtIndex:(NSInteger)index;

@end


@protocol IMDrawersTableViewDelegate <NSObject>

@optional
- (void)tableView:(IMDrawersTableView *)tableView didScrollToOffsetY:(CGFloat)offsetY;

@end
