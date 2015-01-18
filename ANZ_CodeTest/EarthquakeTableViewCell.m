//
//  EarthquakeTableViewCell.m
//  ANZ_CodeTest
//
//  Created by Val on 10/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "EarthquakeTableViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Earthquake.h"
#import "LocationManager.h"

@interface EarthquakeTableViewCell()
{
    UILabel *_regionLabel;
    UILabel *_distanceLabel;
}

@end

@implementation EarthquakeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        _regionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _regionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _regionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _regionLabel.backgroundColor = [UIColor clearColor];
        _regionLabel.textColor = [UIColor darkTextColor];
//        _regionLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_regionLabel];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _distanceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_distanceLabel];
        
        CGFloat horizontalBuffer = 15.0;
        
        // title
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_regionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:_regionLabel.font.lineHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_regionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:horizontalBuffer]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_regionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_distanceLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-horizontalBuffer]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_regionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        // location
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_distanceLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:_distanceLabel.font.lineHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_distanceLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_regionLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:horizontalBuffer]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_distanceLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-horizontalBuffer]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_distanceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_distanceLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:110.0]];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_regionLabel release];
    _regionLabel = nil;
    
    [_distanceLabel release];
    _distanceLabel = nil;
    
    [super dealloc];
}

#pragma mark - Convenience

- (void)parseEarthquake:(Earthquake *)earthquake
{
    _regionLabel.text = earthquake.region;
    
    _distanceLabel.text = [earthquake getDistanceString];
    
}

+ (CGFloat)defaultHeightForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

@end
