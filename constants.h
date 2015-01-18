//
//  constants.h
//  ANZ_CodeTest
//
//  Created by Val on 9/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#ifndef ANZ_CodeTest_constants_h
#define ANZ_CodeTest_constants_h

@protocol DataRefreshed <NSObject>

- (void)DataRefreshed;

@optional
- (void)DataRefreshFailed;

@end

#define NOTIFICATION_DataRefreshed @"NOTIFICATION_DataRefreshed"
#define NOTIFICATION_DataRefreshFailed @"NOTIFICATION_DataRefreshFailed"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"\n%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define isIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#endif
