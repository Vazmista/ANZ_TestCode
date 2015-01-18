//
//  UITableViewCell+Convenience.m
//  ANZ_CodeTest
//
//  Created by Val on 10/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "UITableViewCell+Convenience.h"

@implementation UITableViewCell (Convenience)

+ (CGFloat)defaultHeightForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

+ (NSString *)defaultReuseIdentifier
{
    return NSStringFromClass(self);
}

@end
