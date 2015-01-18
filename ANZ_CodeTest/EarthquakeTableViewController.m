//
//  EarthquakeTableViewController.m
//  ANZ_CodeTest
//
//  Created by Val on 10/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "EarthquakeTableViewController.h"
#import "EarthquakeTableViewCell.h"
#import "DataManager.h"
#import "EarthquakeDetailViewController.h"

@interface EarthquakeTableViewController()
{
    UITableView *_tableView;
    UIRefreshControl *pullToRefresh;
    NSArray *_tableData;
}

@end

@implementation EarthquakeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self DataRefreshed];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![[DataManager defaultManager] refreshingData])
    {
        [self DataRefreshed];
    }
}

- (void)dealloc
{
    [_tableView release];
    _tableView = nil;
    [_tableData release];
    _tableData = nil;
    [pullToRefresh release];
    pullToRefresh = nil;
    
    [super dealloc];
}

#pragma mark - Setup

- (void)setupTableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        
        pullToRefresh = [[UIRefreshControl alloc] init];
        [pullToRefresh addTarget:[DataManager defaultManager] action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Refresh Earthquakes"];
        [pullToRefresh setAttributedTitle:attString];
        
        [attString release];
        attString = nil;
        
        UITableViewController *tableViewController = [[[UITableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        [self addChildViewController:tableViewController];
        tableViewController.refreshControl = pullToRefresh;
        tableViewController.tableView = _tableView;
        
        // register cells and header/footer views
        [_tableView registerClass:[EarthquakeTableViewCell class] forCellReuseIdentifier:[EarthquakeTableViewCell defaultReuseIdentifier]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tableView];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        
        if ([[DataManager defaultManager] refreshingData])
        {
            [pullToRefresh beginRefreshing];
        }
    }
}

#pragma mark - Data Refresh

- (void)DataRefreshed
{
    _tableData = [[DataManager defaultManager].earthquakes copy];
    [pullToRefresh endRefreshing];
    [_tableView reloadData];
}

- (void)DataRefreshFailed
{
    [pullToRefresh endRefreshing];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count? _tableData.count:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EarthquakeTableViewCell defaultHeightForTableView:tableView indexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (_tableData.count)
    {
        Earthquake *currentEarthquake = [_tableData objectAtIndex:indexPath.row];
        
        EarthquakeTableViewCell *earthquakeCell = [tableView dequeueReusableCellWithIdentifier:[EarthquakeTableViewCell defaultReuseIdentifier] forIndexPath:indexPath];
        [earthquakeCell parseEarthquake:currentEarthquake];
        cell = earthquakeCell;
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"NothingToShowCell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NothingToShowCell"] autorelease];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        cell.textLabel.numberOfLines = 2;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.textLabel.text = @"There are no available earthquakes available";
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Go to earthquake details screen
    if (_tableData.count)
    {
        Earthquake *currentEarthquake = [_tableData objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:[[[EarthquakeDetailViewController alloc] initWithEarthquake:currentEarthquake] autorelease] animated:YES];
    }
}


@end
