//
//  CMPhoto.m
//  POICollect
//  图片的模型
//  Created by 常敏 on 15/6/30.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhoto.h"

@implementation CMPhoto

- (void)saveImage
{
    if (!_localImage) {
        //拍照的图片能保存
        if (_originalImage) {
            NSData* imageData = UIImagePNGRepresentation(_originalImage);
            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
            formater.dateFormat = @"yyyyMMddHHmmss";
            NSString* currentTimeStr = [[formater stringFromDate:[NSDate date]] stringByAppendingFormat:@"_%d", arc4random_uniform(10000)];
            NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:currentTimeStr];
            BOOL res = [imageData writeToFile:path atomically:YES];
            if (res) {
                _imageURLString = path;
            }
        }
    }
}

- (UIImage*)getImage
{
    if (!_originalImage) {
        if (self.imageURLString) {
            _originalImage = [UIImage imageWithContentsOfFile:self.imageURLString];
        }
    }
    return _originalImage;
}

- (void)deleteImage
{
}

@end
