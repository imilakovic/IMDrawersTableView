//
//  IMDrawersTableView.m
//
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import "IMDrawersTableView.h"

@interface IMDrawersTableView () <IMDrawersTableViewCellDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) NSInteger openedIndex;

@end


@implementation IMDrawersTableView

#pragma mark - Init

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _openedIndex = -1;
        
        _scrollView = [UIScrollView new];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        [self performLayout];
    }
    return self;
}


#pragma mark - Public

- (void)closeIfNeeded {
    if (_openedIndex > -1) {
        [self setCellOpened:NO atIndex:0];
        _openedIndex = -1;
    }
}


- (void)setCellHeaderHeight:(CGFloat)cellHeaderHeight {
    _cellHeaderHeight = cellHeaderHeight;
    [self performLayout];
}


- (void)setContentInsetTop:(CGFloat)contentInsetTop {
    _contentInsetTop = contentInsetTop;
    [self performLayout];
}


- (void)setDataSource:(id<IMDrawersTableViewDataSource>)dataSource {
    _dataSource = nil;
    _dataSource = dataSource;
    [self reloadUI];
}


#pragma mark - User Interface

- (void)cleanUI {
    [_headerView removeFromSuperview];
    _headerView = nil;
    
    for (IMDrawersTableViewCell *cell in _cells) {
        [cell removeFromSuperview];
    }
    
    _cells = nil;
}


- (void)reloadUI {
    [self cleanUI];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    _headerView = [_dataSource headerViewForTableView:self];
    _headerView.userInteractionEnabled = YES;
    [_headerView addGestureRecognizer:tapGestureRecognizer];
    [_scrollView addSubview:_headerView];
    
    NSMutableArray *cells = [NSMutableArray new];
    for (NSInteger i = 0; i < [_dataSource numberOfCellsInTableView:self]; i++) {
        IMDrawersTableViewCell *cell = [_dataSource tableView:self cellAtIndex:i];
        cell.delegate = self;
        cell.headerHeight = _cellHeaderHeight;
        [_scrollView addSubview:cell];
        [cells addObject:cell];
    }
    
    _cells = [[NSArray alloc] initWithArray:cells];
}


- (void)setCellOpened:(BOOL)opened atIndex:(NSInteger)index {
    if (opened) {
        [_scrollView setContentOffset:CGPointMake(0.0, [self openedOffsetYAtIndex:index]) animated:YES];
        _openedIndex = index;
    } else {
        [_scrollView setContentOffset:CGPointMake(0.0, [self closedOffsetYAtIndex:index]) animated:YES];
        _openedIndex--;
    }
}


- (void)updateScrollViewWithVelocityY:(NSNumber *)velocityY {
    NSInteger index = [self indexOfCellForContentOffsetY:_scrollView.contentOffset.y];
    [self setCellOpened:velocityY.floatValue < 0.0 atIndex:index];
}


#pragma mark - Layout

- (CGFloat)closedOffsetYAtIndex:(NSInteger)index {
    return _cellHeight * index - _cellHeaderHeight * index;
}


- (CGFloat)openedOffsetYAtIndex:(NSInteger)index {
    return _headerView.frame.size.height + _cellHeight * index - _contentInsetTop - _cellHeaderHeight * index;
}


- (void)performLayout {
    if (!_dataSource) {
        return;
    }
    
    _scrollView.frame = self.bounds;
    
    CGSize size = _scrollView.bounds.size;
    
    CGFloat headerViewHeight = size.height - _cells.count * _cellHeaderHeight;
    _cellHeight = size.height - (_cells.count - 1) * _cellHeaderHeight - _contentInsetTop;
    
    _headerView.frame = CGRectMake(0.0, 0.0, size.width, headerViewHeight);
    
    __block CGFloat totalHeight = _headerView.frame.size.height;
    __block CGFloat y = _headerView.frame.size.height;
    
    [_cells enumerateObjectsUsingBlock:^(IMDrawersTableViewCell *cell, NSUInteger idx, BOOL *stop) {
        cell.frame = CGRectMake(0.0, y, size.width, _cellHeight);
        
        y += _cellHeaderHeight;
        totalHeight += cell.frame.size.height;
    }];
    
    _scrollView.contentSize = CGSizeMake(size.width, totalHeight);
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self performLayout];
}


#pragma mark - Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    [self closeIfNeeded];
}


#pragma mark - Private

- (NSInteger)indexOfCellForContentOffsetY:(CGFloat)offsetY {
    for (NSInteger i = 0; i < _cells.count; i++) {
        CGFloat closed = [self closedOffsetYAtIndex:i];
        CGFloat opened = [self openedOffsetYAtIndex:i];
        if (offsetY >= closed && offsetY <= opened) {
            return i;
        }
    }
    return -1;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat velocityY = [scrollView.panGestureRecognizer velocityInView:self].y;
    [self performSelector:@selector(updateScrollViewWithVelocityY:) withObject:@(velocityY) afterDelay:0.0];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // Header
    CGRect headerFrame = _headerView.frame;
    headerFrame.origin.y = offsetY;
    _headerView.frame = headerFrame;
    
    // Cells
    __block CGRect cellFrame = CGRectZero;
    
    [_cells enumerateObjectsUsingBlock:^(IMDrawersTableViewCell *cell, NSUInteger idx, BOOL *stop) {
        cellFrame = cell.frame;
        
        CGFloat openedOffsetY = [self openedOffsetYAtIndex:idx];
        CGFloat closedOffsetY = [self closedOffsetYAtIndex:idx];
        
        if (offsetY <= closedOffsetY) {
            // View waiting
            cellFrame.origin.y = _headerView.frame.size.height + _cellHeaderHeight * idx + offsetY;
        } else if (offsetY > closedOffsetY && offsetY < openedOffsetY) {
            // View traveling
            cellFrame.origin.y = _headerView.frame.size.height + _cellHeight * idx;
        } else if (offsetY >= openedOffsetY) {
            // View stopped
            cellFrame.origin.y = _contentInsetTop + _cellHeaderHeight * idx + offsetY;
        }
        
        cell.frame = cellFrame;
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didScrollToOffsetY:)]) {
        [_delegate tableView:self didScrollToOffsetY:offsetY];
    }
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // Disable default scroll view deceleration
    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
}


#pragma mark - IMDrawersTableViewCellDelegate

- (void)cellHeaderTapped:(IMDrawersTableViewCell *)cell {
    NSInteger index = [_cells indexOfObject:cell];
    [self setCellOpened:_openedIndex != index atIndex:index];
}


@end
