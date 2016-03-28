//
//  Header.h
//  EyeWink
//
//  Created by dllo on 15/9/28.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#ifndef EyeWink_Header_h
#define EyeWink_Header_h


#if DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil

#endif

#define WIDTH  [[UIScreen mainScreen] bounds].size.width / 375
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height / 667
#define MINLENGHT self.view.frame.size.width / 375
#define MINCELLLENGHT self.frame.size.width / 375


#endif
