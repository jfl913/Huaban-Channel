//
//  JFWebImageMacro.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/24.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#ifndef Huaban_Channel_JFWebImageMacro_h
#define Huaban_Channel_JFWebImageMacro_h

//防止死锁
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

#endif
