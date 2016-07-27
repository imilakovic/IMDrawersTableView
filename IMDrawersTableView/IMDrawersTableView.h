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

/**
 Height of a cell header.
 Default value is 44.0 px.
 */
@property (assign, nonatomic) CGFloat cellHeaderHeight;

/**
 Top content inset. Can be used to, for example, leave some space for a title.
 Default value is 0.
 */
@property (assign, nonatomic) CGFloat contentInsetTop;

/**
 Closes all cells (if any is opened).
 */
- (void)closeIfNeeded;

/**
 Performs initial layout (with all cells closed).
 */
- (void)performLayout;

@end


@protocol IMDrawersTableViewDataSource <NSObject>

/**
 Set a single (main) header for the table view.
 */
- (UIView *)headerViewForTableView:(IMDrawersTableView *)tableView;

/**
 Set the number of cells in table view.
 */
- (NSInteger)numberOfCellsInTableView:(IMDrawersTableView *)tableView;

/**
 Used to set up a custom table view cell.
 */
- (IMDrawersTableViewCell *)tableView:(IMDrawersTableView *)tableView cellAtIndex:(NSInteger)index;

@end


@protocol IMDrawersTableViewDelegate <NSObject>

@optional

/**
 Notifies the delegate when table was scrolled to a certain offset.
 */
- (void)tableView:(IMDrawersTableView *)tableView didScrollToOffsetY:(CGFloat)offsetY;

@end
