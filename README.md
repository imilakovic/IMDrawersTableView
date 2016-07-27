# IMDrawersTableView

<img src="http://res.cloudinary.com/foosh/image/upload/v1469624316/drawers_table_view_vw1nsa.gif"/>

<b>IMDrawersTableView</b> is a simple iOS table view with drawers instead of standard cells.

## Requirements

- Requires iOS 7 or later
- Requires Automatic Reference Counting (ARC)

## Demo Project

Please feel free to try the IMDrawersTableViewDemo project in Xcode. It demonstrates the setup and behaviour of the table view and also provides a couple of UX ideas for implementation.

## Installation

Simply drag & drop the IMDrawersTableView folder to your project.

## Usage

IMDrawersTableView has a very similar usage to UITableView. Please see the following steps:

####1. Import the header file

```objective-c
#import "IMDrawersTableVew.h"
```

####2. Initialize the table view and set dataSource and delegate properties

```objective-c
_tableView = [IMDrawersTableView new];
_tableView.dataSource = self;
_tableView.delegate = self;
[self.view addSubview:_tableView];
```

####3. Set the frame for table view

```objective-c
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
}
```

####4. Implement required data source methods

```objective-c
- (UIView *)headerViewForTableView:(IMDrawersTableView *)tableView {
    return [YourCustomTableHeaderView new];
}

- (NSInteger)numberOfCellsInTableView:(IMDrawersTableView *)tableView {
    return 3;
}

- (IMDrawersTableViewCell *)tableView:(IMDrawersTableView *)tableView cellAtIndex:(NSInteger)index {
    IMDrawersTableViewCell *cell = [IMDrawersTableViewCell new];
    cell.headerView = [YourCustomCellHeaderView new];
    cell.contentView = [YourCustomCellContentView new];
    
    return cell;
}
```

## License

IMDrawersTableView is available under the MIT license. See the LICENSE file for more info.
