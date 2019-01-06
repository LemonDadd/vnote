
//
//  CustomView.m
//  zjproject
//
//  Created by rockontrol on 15/4/15.
//  Copyright (c) 2015年 rockontrol. All rights reserved.
//

#import "CustomView.h"
#import "MBProgressHUD.h"
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CustomView

static CustomView* object = nil;
+ (instancetype)getInstancetype
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        object = [[CustomView alloc] init];
    });
    return object;
}

- (void)windowAlertBy:(id)view
         isTouchClose:(BOOL)isTouchClose
                color:(UIColor *)color
             animated:(BOOL)animated
          addDelegate:(id<CustomViewDelegate>)delegate{
    _delegate = delegate;
    mainWindowView = view;
    mainWindow = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:mainWindow];
    [window addSubview:view];
    
    //颜色
    if (color == nil) {
        color = [UIColor colorWithWhite:0 alpha:0.5];
    }
    [mainWindow setBackgroundColor:color];
    
    //触摸
    if (isTouchClose) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindowAlertWithanimated:)];
        [mainWindow addGestureRecognizer:tapGesture];
    }
    if (animated) {
        [mainWindow setAlpha:0];
        [UIView animateWithDuration:0.2 animations:^{
            [mainWindow setAlpha:1];
        } completion:nil];
    }
}

- (void)windowAlertBy:(id)view
         isTouchClose:(BOOL)isTouchClose
                Touch:(TouchObject)Touch
                color:(UIColor *)color
             animated:(BOOL)animated
          addDelegate:(id<CustomViewDelegate>)delegate {
    _touch = Touch;
    _delegate = delegate;
    mainWindowView = view;
    mainWindow = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:mainWindow];
    [window addSubview:view];
    
    //颜色
    if (color == nil) {
        color = [UIColor colorWithWhite:0 alpha:0.5];
    }
    [mainWindow setBackgroundColor:color];
    
    //触摸
    if (isTouchClose) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchWindow)];
        [mainWindow addGestureRecognizer:tapGesture];
    }
    if (animated) {
        [mainWindow setAlpha:0];
        [UIView animateWithDuration:0.2 animations:^{
            [mainWindow setAlpha:1];
        } completion:nil];
    }
}

- (void)touchWindow {
    if (_touch == nil) {
        [self closeWindowAlertWithanimated:true];
    } else {
        _touch();
    }
}

- (void)closeWindowAlertWithanimated:(BOOL)animated{
    WEAK_SELF;
    dispatch_queue_t  queue =  dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if (animated) {
            [UIView animateWithDuration:0.2 animations:^{
                [((UIView*)mainWindowView) setAlpha:0];
                [mainWindow setAlpha:0];
            } completion:^(BOOL finished) {
                [mainWindowView removeFromSuperview];
                mainWindowView = nil;
                [mainWindow setHidden:true];
                [mainWindow removeFromSuperview];
                mainWindow = nil;
                
                if ([weakSelf.delegate respondsToSelector:@selector(closeWindowBy)]) {
                    [weakSelf.delegate closeWindowBy];
                }
            }];
        }else{
            if (![weakSelf.delegate respondsToSelector:@selector(closeWindowBy)]) {
                [mainWindowView removeFromSuperview];
                mainWindowView = nil;
                [mainWindow setHidden:true];
                [mainWindow removeFromSuperview];
                mainWindow = nil;
            } else {
                [weakSelf.delegate closeWindowBy];
            }
        }
    });
}

- (void)closeWindowAlertWithanimated:(BOOL)animated
                            complete:(void(^)(void))complete{
    dispatch_queue_t  queue =  dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if (animated) {
            complete();
            [UIView animateWithDuration:0.2 animations:^{
                [((UIView*)mainWindowView) setAlpha:0];
                [mainWindow setAlpha:0];
            } completion:^(BOOL finished) {
                [mainWindowView removeFromSuperview];
                mainWindowView = nil;
                [mainWindow setHidden:true];
                [mainWindow removeFromSuperview];
                mainWindow = nil;
            }];
        }else{
            complete();
            [mainWindowView removeFromSuperview];
            mainWindowView = nil;
            [mainWindow setHidden:true];
            [mainWindow removeFromSuperview];
            mainWindow = nil;
        }
    });
}

- (void)showWaitView:(NSString*)noticeMsg byView:(UIView*)view{
    if (view == nil) {
        return;
    }
    if (noticeMsg == nil || noticeMsg.length == 0) {
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:view];
    if ([noticeMsg length] == 0) {
        HUD.mode = MBProgressHUDModeCustomView;
    }else{
        //        HUD.labelText = noticeMsg;
        HUD.detailsLabelText = noticeMsg;
    }
    
    [view addSubview:HUD];
    [HUD show:YES];
}

- (void)closeHUD
{
    if (HUD != nil) {
        [HUD hide:YES];
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

- (void)showAlertView:(NSString*)noticeMsg
               byView:(UIView*)view
           completion:(void(^)(void))completion{
    if (view == nil) {
        return;
    }
    if (noticeMsg == nil || noticeMsg.length == 0) {
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    //    HUD.labelText = noticeMsg;
    HUD.detailsLabelText = noticeMsg;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
        
        completion();
    }];
}

- (void)showAlertView:(NSString*)noticeMsg
               byView:(UIView*)view
                delay:(int)delay
           completion:(void(^)(void))completion{
    if (view == nil) {
        return;
    }
    if (noticeMsg == nil || noticeMsg.length == 0) {
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    //    HUD.labelText = noticeMsg;
    HUD.detailsLabelText = noticeMsg;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(delay);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
        
        completion();
    }];
}

+ (void)alertMessage:(NSString*)title view:(UIView*)view{
    if (view == nil) {
        return;
    }
    if (title == nil || title.length == 0) {
        return;
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    //    hud.labelText = title;
    HUD.detailsLabelText = title;
    HUD.margin = 20.f;
    HUD.yOffset = 100.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:2];
}

- (void)dealloc{
    _delegate = nil;
}

@end










