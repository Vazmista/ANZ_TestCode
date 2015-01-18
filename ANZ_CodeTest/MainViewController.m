//
//  MainViewController.m
//  ANZ_CodeTest
//
//  Created by Val on 10/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "MainViewController.h"
#import "EarthquakeMapViewController.h"
#import "EarthquakeTableViewController.h"

@interface MainViewController()
{
    UISegmentedControl *segmentedController;
    
    EarthquakeMapViewController *mapViewController;
    EarthquakeTableViewController *tableViewController;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DataRefreshed) name:NOTIFICATION_DataRefreshed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DataRefreshFailed) name:NOTIFICATION_DataRefreshFailed object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DataRefreshed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DataRefreshFailed object:nil];
}

- (void)dealloc
{
    [segmentedController release];
    segmentedController = nil;
    
    [mapViewController release];
    mapViewController = nil;
    [tableViewController release];
    tableViewController = nil;
    
    [super dealloc];
}

#pragma mark - Setup

- (void)setupView
{
    [self applySegmentedController];
}

#pragma mark - Segmented Methods

- (void)applySegmentedController
{
    if (!segmentedController)
    {
        segmentedController = [[UISegmentedControl alloc] initWithItems:@[@"List", @"Map"]];
        [segmentedController addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [segmentedController setTintColor:[UIColor whiteColor]];
        [segmentedController setFrame:CGRectMake(0, 0, 160, 24)];
        [segmentedController setSelectedSegmentIndex:0];
        
        self.navigationItem.titleView = [[[UIView alloc] initWithFrame:segmentedController.frame] autorelease];
        [self.navigationItem.titleView addSubview:segmentedController];
        
        [self segmentedControlValueChanged:segmentedController];
    }
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segControl
{
    if (mapViewController)
    {
        [mapViewController willMoveToParentViewController:nil];
        [mapViewController.view removeFromSuperview];
        [mapViewController removeFromParentViewController];
    }
    
    if (tableViewController)
    {
        [tableViewController willMoveToParentViewController:nil];
        [tableViewController.view removeFromSuperview];
        [tableViewController removeFromParentViewController];
    }
    
    switch (segControl.selectedSegmentIndex)
    {
        case 0:
        {
            if (!tableViewController)
            {
                tableViewController = [[EarthquakeTableViewController alloc] init];
                
            }
            
            tableViewController.view.frame = self.view.bounds;
            tableViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            [self addChildViewController:tableViewController];
            [self.view addSubview:tableViewController.view];
            [tableViewController didMoveToParentViewController:self];
        }
            break;
        case 1:
        {
            if (!mapViewController)
            {
                mapViewController = [[EarthquakeMapViewController alloc] init];
            }
            
            mapViewController.view.frame = self.view.bounds;
            mapViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            [self addChildViewController:mapViewController];
            [self.view addSubview:mapViewController.view];
            [mapViewController didMoveToParentViewController:self];
        }
            break;
        default:
            break;
    }
    
    [self.view setNeedsDisplay];
}

#pragma mark - Data Refresh

- (void)DataRefreshFailed
{
    
}

- (void)DataRefreshed
{
    switch (segmentedController.selectedSegmentIndex)
    {
        case 0:
            if (tableViewController)
            {
                [tableViewController DataRefreshed];
            }
            break;
        case 1:
            if (mapViewController)
            {
                [mapViewController DataRefreshed];
            }
            break;
            
        default:
            break;
    }
}

@end
