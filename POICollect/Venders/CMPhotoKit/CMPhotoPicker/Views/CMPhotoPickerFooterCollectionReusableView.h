//
//  CMPhotoPickerFooterCollectionReusableView.h
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString* const _footerIdentifier = @"FooterView";

@interface CMPhotoPickerFooterCollectionReusableView : UICollectionReusableView

/**
 *  图片的数量
 */
@property (nonatomic, assign) NSUInteger count;

@end
