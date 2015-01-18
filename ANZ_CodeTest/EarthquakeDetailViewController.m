//
//  EarthquakeDetailViewController.m
//  ANZ_CodeTest
//
//  Created by Val on 14/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "EarthquakeDetailViewController.h"
#import "constants.h"
#import "Earthquake.h"
#import "Earthquake+MKAnnotation.h"
#import "DataManager.h"

static NSString *earthquakePinIdentifier = @"EarthquakePinIdentifier";

static const float kDetailsViewHeight = 120.0;
static const float kDetailsViewWidthIpad = 400.0;

@interface EarthquakeDetailViewController ()
{
    NSLayoutConstraint *detailBottomConstraint;
    
    BOOL detailViewShowing;
}
@end

@implementation EarthquakeDetailViewController

- (id)initWithEarthquake:(Earthquake *)earthquake
{
    if (self = [super init])
    {
        self.earthquake = [earthquake retain];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    detailViewShowing = NO;
    [self setupMap];
    [self setupDetailView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_earthquake release];
    _earthquake = nil;
    
    [_mapView release];
    _mapView = nil;
    
    [_detailView release];
    _detailView = nil;
    
    [super dealloc];
}

#pragma mark - Setup

- (void)setupMap
{
    if (!self.mapView)
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([self.earthquake.latitude doubleValue], [self.earthquake.longitude doubleValue]), 1000000, 1000000);
        
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;
        self.mapView.mapType = MKMapTypeStandard;
        
        [self.mapView setRegion:region];
        [self.mapView regionThatFits:region];
        
        [self.view addSubview:self.mapView];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        
        [self.mapView addAnnotation:self.earthquake];
        [self.mapView selectAnnotation:self.earthquake animated:YES];
    }
}

- (void)setupDetailView
{
    if (isIpad)
    {
        if (!self.detailView)
        {
            self.detailView = [[UIView alloc] initWithFrame:CGRectZero];
            self.detailView.backgroundColor = [UIColor blackColor];
            self.detailView.layer.cornerRadius = 5.0;
            self.detailView.alpha = 0.7;
            self.detailView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.view insertSubview:self.detailView aboveSubview:self.mapView];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kDetailsViewWidthIpad]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kDetailsViewHeight]];
            
            //Details
            
            UILabel *regionTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            regionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            regionTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            regionTitleLabel.textColor = [UIColor whiteColor];
            regionTitleLabel.text = @"Region:";
            [self.detailView addSubview:regionTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:regionTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:65]];
            
            UILabel *regionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            regionLabel.translatesAutoresizingMaskIntoConstraints = NO;
            regionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            regionLabel.textColor = [UIColor lightGrayColor];
            regionLabel.text = self.earthquake.region;
            regionLabel.adjustsFontSizeToFitWidth = YES;
            [self.detailView addSubview:regionLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:regionTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:regionTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:regionTitleLabel.font.lineHeight]];
            
            UILabel *depthTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            depthTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            depthTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            depthTitleLabel.textColor = [UIColor whiteColor];
            depthTitleLabel.text = @"Depth:";
            [self.detailView addSubview:depthTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:40]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:depthTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:55]];
            
            UILabel *depthLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            depthLabel.translatesAutoresizingMaskIntoConstraints = NO;
            depthLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            depthLabel.textColor = [UIColor lightGrayColor];
            depthLabel.text = [self.earthquake.depth stringValue];
            depthLabel.adjustsFontSizeToFitWidth = YES;
            [self.detailView addSubview:depthLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:depthTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:depthTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:0.5 constant:-10]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:depthTitleLabel.font.lineHeight]];
            
            UILabel *magnatudeTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            magnatudeTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            magnatudeTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            magnatudeTitleLabel.textColor = [UIColor whiteColor];
            magnatudeTitleLabel.text = @"Magnitude:";
            [self.detailView addSubview:magnatudeTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnatudeTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:0.5 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnatudeTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:40]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnatudeTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:magnatudeTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnatudeTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:90]];
            
            UILabel *magnitudeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            magnitudeLabel.translatesAutoresizingMaskIntoConstraints = NO;
            magnitudeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            magnitudeLabel.textColor = [UIColor lightGrayColor];
            magnitudeLabel.text = [self.earthquake.magnitude stringValue];
            magnitudeLabel.adjustsFontSizeToFitWidth = YES;
            [self.detailView addSubview:magnitudeLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:magnatudeTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:magnatudeTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:magnatudeTitleLabel.font.lineHeight]];
            
            UILabel *dateTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            dateTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            dateTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            dateTitleLabel.textColor = [UIColor whiteColor];
            dateTitleLabel.text = @"Date:";
            [self.detailView addSubview:dateTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:70]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dateTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
            
            UILabel *dateLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
            dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            dateLabel.textColor = [UIColor lightGrayColor];
            dateLabel.text = [TimeDateFormatterForWebservice() stringFromDate:self.earthquake.timedate];
            dateLabel.adjustsFontSizeToFitWidth = YES;
            [self.detailView addSubview:dateLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:dateTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dateTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:0.5 constant:-10]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dateTitleLabel.font.lineHeight]];
            
            UILabel *sourceTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            sourceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            sourceTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            sourceTitleLabel.textColor = [UIColor whiteColor];
            sourceTitleLabel.text = @"Source:";
            [self.detailView addSubview:sourceTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:0.5 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:70]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sourceTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:65]];
            
            UILabel *sourceLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            sourceLabel.translatesAutoresizingMaskIntoConstraints = NO;
            sourceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            sourceLabel.textColor = [UIColor lightGrayColor];
            sourceLabel.text = self.earthquake.source;
            sourceLabel.adjustsFontSizeToFitWidth = YES;
            [self.detailView addSubview:sourceLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sourceTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sourceTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sourceTitleLabel.font.lineHeight]];
        }
    }
    else
    {
        if (!self.detailView)
        {
            self.detailView = [[UIView alloc] initWithFrame:CGRectZero];
            self.detailView.backgroundColor = [UIColor clearColor];
            self.detailView.layer.cornerRadius = 5.0;
            self.detailView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.view insertSubview:self.detailView aboveSubview:self.mapView];
            
            detailBottomConstraint = [NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0];
            
            [self.view addConstraint:detailBottomConstraint];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kDetailsViewHeight]];
            
            // Background
            UIView *backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            backgroundView.backgroundColor = [UIColor blackColor];
            backgroundView.alpha = 0.6;
            backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.detailView addSubview:backgroundView];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0]];
            
            // Tab
            UIView *tabView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            tabView.backgroundColor = [UIColor blackColor];
            tabView.alpha = 0.6;
            tabView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.detailView addSubview:tabView];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0]];
            
            UIView *lineIndicator = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            lineIndicator.backgroundColor = [UIColor whiteColor];
            lineIndicator.translatesAutoresizingMaskIntoConstraints = NO;
            lineIndicator.layer.cornerRadius = 2.0;
            
            [tabView addSubview:lineIndicator];
            [tabView addConstraint:[NSLayoutConstraint constraintWithItem:lineIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tabView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            [tabView addConstraint:[NSLayoutConstraint constraintWithItem:lineIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tabView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
            [tabView addConstraint:[NSLayoutConstraint constraintWithItem:lineIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
            [tabView addConstraint:[NSLayoutConstraint constraintWithItem:lineIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:4.0]];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapped:)];
            tapRecognizer.numberOfTapsRequired = 1;
            tapRecognizer.numberOfTouchesRequired = 1;
            [tabView addGestureRecognizer:tapRecognizer];
            
            [tapRecognizer release];
            
            UISwipeGestureRecognizer *upSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
            upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
            upSwipeRecognizer.numberOfTouchesRequired = 1;
            [tabView addGestureRecognizer:upSwipeRecognizer];
            
            [upSwipeRecognizer release];
            
            UISwipeGestureRecognizer *downSwipRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
            downSwipRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
            downSwipRecognizer.numberOfTouchesRequired = 1;
            [tabView addGestureRecognizer:downSwipRecognizer];
            
            [downSwipRecognizer release];
            
            // Details
            
            UILabel *regionTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            regionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            regionTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            regionTitleLabel.textColor = [UIColor whiteColor];
            regionTitleLabel.text = @"Region:";
            [self.detailView addSubview:regionTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:regionTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:55]];
            
            UILabel *regionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            regionLabel.translatesAutoresizingMaskIntoConstraints = NO;
            regionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            regionLabel.textColor = [UIColor lightGrayColor];
            regionLabel.adjustsFontSizeToFitWidth = YES;
            regionLabel.text = self.earthquake.region;
            [self.detailView addSubview:regionLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:regionTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:regionTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:regionLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:regionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
            
            UILabel *dateTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            dateTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            dateTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            dateTitleLabel.textColor = [UIColor whiteColor];
            dateTitleLabel.text = @"Date:";
            [self.detailView addSubview:dateTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dateTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
            
            UILabel *dateLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
            dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            dateLabel.textColor = [UIColor lightGrayColor];
            dateLabel.adjustsFontSizeToFitWidth = YES;
            dateLabel.text = [TimeDateFormatterForWebservice() stringFromDate:self.earthquake.timedate];
            [self.detailView addSubview:dateLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:dateTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dateTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dateLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:0.5 constant:-5]];
            
            UILabel *sourceTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            sourceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            sourceTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            sourceTitleLabel.textColor = [UIColor whiteColor];
            sourceTitleLabel.text = @"Source:";
            [self.detailView addSubview:sourceTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:0.5 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:50]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sourceTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:55]];
            
            UILabel *sourceLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            sourceLabel.translatesAutoresizingMaskIntoConstraints = NO;
            sourceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            sourceLabel.textColor = [UIColor lightGrayColor];
            sourceLabel.adjustsFontSizeToFitWidth = YES;
            sourceLabel.text = self.earthquake.source;
            [self.detailView addSubview:sourceLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sourceTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sourceTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sourceLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:sourceLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
            
            UILabel *depthTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            depthTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            depthTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            depthTitleLabel.textColor = [UIColor whiteColor];
            depthTitleLabel.text = @"Depth:";
            [self.detailView addSubview:depthTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:75]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:depthTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];

            
            UILabel *depthLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            depthLabel.translatesAutoresizingMaskIntoConstraints = NO;
            depthLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            depthLabel.textColor = [UIColor lightGrayColor];
            depthLabel.adjustsFontSizeToFitWidth = YES;
            depthLabel.text = [self.earthquake.depth stringValue];
            [self.detailView addSubview:depthLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:depthTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:depthTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dateLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:depthLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:0.5 constant:-10]];
            
            UILabel *magnitudeTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            magnitudeTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            magnitudeTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            magnitudeTitleLabel.textColor = [UIColor whiteColor];
            magnitudeTitleLabel.text = @"Magnitude:";
            [self.detailView addSubview:magnitudeTitleLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:0.5 constant:5]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:depthTitleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:magnitudeTitleLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80]];
            
            UILabel *magnitudeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            magnitudeLabel.translatesAutoresizingMaskIntoConstraints = NO;
            magnitudeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            magnitudeLabel.textColor = [UIColor lightGrayColor];
            magnitudeLabel.adjustsFontSizeToFitWidth = YES;
            magnitudeLabel.text = [self.earthquake.magnitude stringValue];
            [self.detailView addSubview:magnitudeLabel];
            
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:magnitudeTitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:magnitudeTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:magnitudeLabel.font.lineHeight]];
            [self.detailView addConstraint:[NSLayoutConstraint constraintWithItem:magnitudeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.detailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
        }
    }
}

#pragma mark - Gesture recognisors

- (void)swipeUp:(UISwipeGestureRecognizer *)swipeGesture
{
    if (!detailViewShowing)
    {
        [UIView animateWithDuration:0.2 animations:^(void){
            
            CGRect frame = self.detailView.frame;
            
            [self.detailView setFrame:CGRectMake(frame.origin.x, frame.origin.y-(frame.size.height-30), frame.size.width, frame.size.height)];
        }completion:^(BOOL finished){
            if (finished)
            {
                detailViewShowing = YES;
                [self.view removeConstraint:detailBottomConstraint];
                
                detailBottomConstraint = [NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0];
                
                [self.view addConstraint:detailBottomConstraint];
            }
        }];
    }
}

- (void)swipeDown:(UISwipeGestureRecognizer *)swipeGesture
{
    if (detailViewShowing)
    {
        [UIView animateWithDuration:0.2 animations:^(void){
            
            CGRect frame = self.detailView.frame;
            
            [self.detailView setFrame:CGRectMake(frame.origin.x, frame.origin.y+(frame.size.height-30), frame.size.width, frame.size.height)];
        }completion:^(BOOL finished){
            if (finished)
            {
                detailViewShowing = NO;
                [self.view removeConstraint:detailBottomConstraint];
                
                detailBottomConstraint = [NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0];
                
                [self.view addConstraint:detailBottomConstraint];
            }
        }];
    }
}

- (void)detailTapped:(UITapGestureRecognizer *)tapGesture
{
    if (detailViewShowing)
    {
        [UIView animateWithDuration:0.2 animations:^(void){
            
            CGRect frame = self.detailView.frame;
            
            [self.detailView setFrame:CGRectMake(frame.origin.x, frame.origin.y+(frame.size.height-30), frame.size.width, frame.size.height)];
        }completion:^(BOOL finished){
            if (finished)
            {
                detailViewShowing = NO;
                [self.view removeConstraint:detailBottomConstraint];
                
                detailBottomConstraint = [NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0];
                
                [self.view addConstraint:detailBottomConstraint];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^(void){
            
            CGRect frame = self.detailView.frame;

            [self.detailView setFrame:CGRectMake(frame.origin.x, frame.origin.y-(frame.size.height-30), frame.size.width, frame.size.height)];
        }completion:^(BOOL finished){
            if (finished)
            {
                detailViewShowing = YES;
                [self.view removeConstraint:detailBottomConstraint];
                
                detailBottomConstraint = [NSLayoutConstraint constraintWithItem:self.detailView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0];
                
                [self.view addConstraint:detailBottomConstraint];
            }
        }];
    }
}

#pragma mark - Map delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:earthquakePinIdentifier];
    if (!pinView)
    {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:earthquakePinIdentifier] autorelease];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = NO;
        pinView.canShowCallout = YES;
    }
    else
    {
        [pinView setAnnotation:annotation];
    }
    
    return pinView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
