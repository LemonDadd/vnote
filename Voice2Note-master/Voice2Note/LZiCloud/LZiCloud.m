//
//  LZiCloud.m
//  LZiCloudDemo
//
//  Created by Artron_LQQ on 2016/12/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZiCloud.h"


@implementation LZiCloud

+ (BOOL)iCloudEnable {
    
    // 获得文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 判断iCloud是否可用
    // 参数传nil表示使用默认容器
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    // 如果URL不为nil, 则表示可用
    if (url != nil) {
        
        return YES;
    }
    
    NSLog(@"iCloud 不可用");
    return NO;
}

+ (NSURL *)iCloudFilePathByName:(NSString *)name {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 判断iCloud是否可用
    // 参数传nil表示使用默认容器
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    
    if (url == nil) {
        
        return nil;
    }
    
    url = [url URLByAppendingPathComponent:@"Documents"];
    NSURL *iCloudPath = [NSURL URLWithString:name relativeToURL:url];
    
    return iCloudPath;
}

+ (NSString *)localFilePath:(NSString *)name {
    
    // 得到本程序沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    
    return filePath;
}

+ (void)uploadToiCloud:(id)file resultBlock:(uploadBlock)block {
    
    [self uploadToiCloud:@"saveOniCloudData" file:file resultBlock:block];
}

+ (void)uploadToiCloud:(NSString *)name file:(id)file resultBlock:(uploadBlock)block {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        if ([file isKindOfClass:[NSString class]]) {
            
            [self uploadToiCloud:name localFile:file resultBlock:block];
        } else {
            
            NSString *path = [self localFilePath:@"temp.data"];
            
            NSError *error = nil;
            if ([NSKeyedArchiver archiveRootObject:file toFile:path]) {
                
                [self uploadToiCloud:name localFile:path resultBlock:block];
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    block(error);
                });
            }
        }
    });
}
// private method
+ (void)uploadToiCloud:(NSString *)name localFile:(NSString *)file resultBlock:(uploadBlock)block {
    
    NSURL *iCloudUrl = [self iCloudFilePathByName:name];
    NSString *localFilePath = file;
    if ([file componentsSeparatedByString:@"/"].count < 2) {
        
        localFilePath = [self localFilePath:file];
    }
    
    NSFileManager *manager  = [NSFileManager defaultManager];
    
    // 判断本地文件是否存在
    if ([manager fileExistsAtPath:localFilePath]) {
        
        // 判断iCloud里该文件是否存在
        if ([manager isUbiquitousItemAtURL:iCloudUrl]) {
            
            NSData *data = [NSData dataWithContentsOfFile:localFilePath];
            NSError *error = nil;
            [data writeToURL:iCloudUrl options:NSDataWritingAtomic error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(error);
            });
            
        } else {
            
            NSURL *fileUrl = [NSURL fileURLWithPath:localFilePath];
            
            NSError *error = nil;
            [manager setUbiquitous:YES itemAtURL:fileUrl destinationURL:iCloudUrl error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(error);
            });
        }
    }
}

+ (void)downloadFromiCloudWithBlock:(downloadBlock)block {
    
    
    [self downloadFromiCloud:@"saveOniCloudData" responsBlock:block];
}

+ (void)downloadFromiCloud:(NSString *)name responsBlock:(downloadBlock)block {
    
    NSURL *iCloudUrl = [self iCloudFilePathByName:name];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        if ([self downloadFileIfNotAvailable:iCloudUrl]) {
            
            // 先尝试转为数组
            NSArray *array = [[NSArray alloc]initWithContentsOfURL:iCloudUrl];
            
            if (array != nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    block(array);
                });
                
            } else {
                
                // 如果数组为nil, 再尝试转为字典
                NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfURL:iCloudUrl];
                if (dic != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        block(dic);
                    });
                } else {
                    // 如果字典为nil, 最后尝试转为NSData
                    NSData *data = [[NSData alloc]initWithContentsOfURL:iCloudUrl];
                    if (data != nil) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            block(data);
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            block(nil);
                        });
                    }
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(nil);
            });
        }
    });
}

// // 此方法是官方文档提供,用来检查文件状态并下载
+ (BOOL)downloadFileIfNotAvailable:(NSURL*)file {
    NSNumber*  isIniCloud = nil;
    
    if ([file getResourceValue:&isIniCloud forKey:NSURLIsUbiquitousItemKey error:nil]) {
        // If the item is in iCloud, see if it is downloaded.
        if ([isIniCloud boolValue]) {
            NSNumber*  isDownloaded = nil;
            if ([file getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemDownloadingStatusKey error:nil]) {
                if ([isDownloaded boolValue])
                    return YES;
                
                // Download the file.
                NSFileManager*  fm = [NSFileManager defaultManager];
                if (![fm startDownloadingUbiquitousItemAtURL:file error:nil]) {
                    return NO;
                }
                return YES;
            }
        }
    }
    
    // Return YES as long as an explicit download was not started.
    return YES;
}

- (BOOL)downLoadData:(NSURL *)fileURL{
    
    NSNumber *isInCloud = nil;
    if ([fileURL getResourceValue:&isInCloud forKey:NSURLIsUbiquitousItemKey error:nil]){
        if ([isInCloud boolValue]) {
            NSNumber *isDownloaded = nil;
            if ([fileURL getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemDownloadingStatusKey error:nil]){
                if ([isDownloaded boolValue]){
                    return YES;
                }
                NSError *error = nil;
                if([[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:fileURL error:&error]){
                    isDownloaded = nil;
                    [fileURL getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemDownloadingStatusKey error:nil];
                    if([isDownloaded isEqual:NSURLUbiquitousItemDownloadingStatusNotDownloaded]){
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

@end
