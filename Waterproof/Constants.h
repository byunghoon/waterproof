//
//  Constants.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-25.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#ifndef Waterproof_Constants_h
#define Waterproof_Constants_h

// Commonly used UI sizes
#define STATUS_BAR_HEIGHT   20
#define WP_MARGIN_L         12
#define WP_MARGIN_M         6
#define WP_MARGIN_S         3

// Colours
#define WP_YELLOW           [UIColor colorWithRed:254.0/255.0 green:203.0/255.0 blue:0.0/255.0 alpha:1.0]

// Other
#define IS_FOUR_INCH        [[UIScreen mainScreen] applicationFrame].size.height>500?YES:NO

// Text Alignment
#ifdef __IPHONE_6_0 // iOS6 and later
#   define kLabelAlignmentCenter    NSTextAlignmentCenter
#   define kLabelAlignmentLeft      NSTextAlignmentLeft
#   define kLabelAlignmentRight     NSTextAlignmentRight
#   define kLabelTruncationTail     NSLineBreakByTruncatingTail
#   define kLabelTruncationMiddle   NSLineBreakByTruncatingMiddle
#else // older versions
#   define kLabelAlignmentCenter    UITextAlignmentCenter
#   define kLabelAlignmentLeft      UITextAlignmentLeft
#   define kLabelAlignmentRight     UITextAlignmentRight
#   define kLabelTruncationTail     UILineBreakModeTailTruncation
#   define kLabelTruncationMiddle   UILineBreakModeMiddleTruncation
#endif

#endif
