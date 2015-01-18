//
//  UITableViewCell+Convenience.h
//  ANZ_CodeTest
//
//  Created by Val on 10/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Convenience)
+ (CGFloat)defaultHeightForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (NSString *)defaultReuseIdentifier;
@end
