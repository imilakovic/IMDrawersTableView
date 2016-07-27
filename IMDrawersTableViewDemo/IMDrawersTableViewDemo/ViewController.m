//
//  ViewController.m
//  IMDrawersTableViewDemo
//
//  Created by Igor Milakovic on 27/07/16.
//  Copyright © 2016 Igor Milakovic. All rights reserved.
//

#import "ViewController.h"

#import "IMDrawersTableView.h"

#define RGB_COLOR(r,g,b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

@interface ViewController () <IMDrawersTableViewDataSource, IMDrawersTableViewDelegate>

@property (strong, nonatomic) IMDrawersTableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (assign, nonatomic) CGFloat titleLabelOriginY;

@end


@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"Custom main header";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = RGB_COLOR(250, 250, 250);
    
    _descriptionLabel = [UILabel new];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.text = @"Please feel free to explore:\n- tap the headers\n- scroll up or down";
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.textColor = RGB_COLOR(250, 250, 250);
    
    _tableView = [IMDrawersTableView new];
    _tableView.cellHeaderHeight = 60.0;
    _tableView.contentInsetTop = 70.0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _titleLabelOriginY = 80.0;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
    
    _titleLabel.frame = CGRectMake(0.0, _titleLabelOriginY, _tableView.headerView.bounds.size.width, 50.0);
    _descriptionLabel.frame = CGRectMake(20.0, _titleLabelOriginY + _titleLabel.frame.size.height, _tableView.headerView.bounds.size.width - 40.0, 80.0);
}


#pragma mark - IMDrawersTableViewDataSource

- (UIView *)headerViewForTableView:(IMDrawersTableView *)tableView {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = RGB_COLOR(75, 100, 125);
    
    [headerView addSubview:_titleLabel];
    [headerView addSubview:_descriptionLabel];
    
    return headerView;
}


- (NSInteger)numberOfCellsInTableView:(IMDrawersTableView *)tableView {
    return 3;
}


- (IMDrawersTableViewCell *)tableView:(IMDrawersTableView *)tableView cellAtIndex:(NSInteger)index {
    UILabel *headerLabel = [UILabel new];
    headerLabel.backgroundColor = RGB_COLOR(25, 50, 75);
    headerLabel.text = [NSString stringWithFormat:@"Custom header %li", (long)index + 1];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = RGB_COLOR(250, 250, 250);
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.backgroundColor = RGB_COLOR(50, 75, 100);
    contentLabel.text = [NSString stringWithFormat:@"Custom content %li", (long)index + 1];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = RGB_COLOR(250, 250, 250);
    
    IMDrawersTableViewCell *cell = [IMDrawersTableViewCell new];
    cell.headerView = headerLabel;
    cell.contentView = contentLabel;
    
    return cell;
}


#pragma mark - IMDrawersTableViewDelegate

- (void)tableView:(IMDrawersTableView *)tableView didScrollToOffsetY:(CGFloat)offsetY {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat maxOffsetY = tableView.headerView.bounds.size.height - tableView.contentInsetTop;
    
    // Title label origin y
    CGFloat originY = offsetY <= maxOffsetY ? NewValueUsingRangeConversion(offsetY, 0.0, maxOffsetY, statusBarHeight, _titleLabelOriginY) : _titleLabelOriginY;
    CGRect frame = _titleLabel.frame;
    frame.origin.y = statusBarHeight + _titleLabelOriginY - originY;
    _titleLabel.frame = frame;
    
    // Description label alpha
    CGFloat alpha = MAX(0.0, (maxOffsetY - offsetY) / maxOffsetY);
    _descriptionLabel.alpha = alpha;
}


#pragma mark - Helpers

Float32 NewValueUsingRangeConversion(Float32 oldValue, Float32 oldMin, Float32 oldMax, Float32 newMin, Float32 newMax) {
    Float32 oldRange = (oldMax - oldMin);
    Float32 newRange = (newMax - newMin);
    return (((oldValue - oldMin) * newRange) / oldRange) + newMin;
};


@end
