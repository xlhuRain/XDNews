//
//  Define.h
//  XDmagazine
//
//  Created by tagux-mac-04 on 13-5-13.
//  Copyright (c) 2013年 tagux-mac-04. All rights reserved.
//



#ifndef XDmagazine_Define_h
#define XDmagazine_Define_h

//extern NSMutableDictionary * const magStatus;

#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )  ) < DBL_EPSILON )
#define iOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 
#define WINDOW [[UIApplication sharedApplication].delegate window]
#define APPDElEGATE [[UIApplication sharedApplication] delegate]


#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#endif
