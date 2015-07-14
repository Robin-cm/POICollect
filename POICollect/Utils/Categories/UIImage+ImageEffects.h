//
//  UIImage+ImageEffects.h
//  POICollect
//
//  Created by 常敏 on 15/7/13.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface UIImage (ImageEffects)

- (UIImage*)applySubtleEffect;

- (UIImage*)applyLightEffect;

- (UIImage*)applyExtraLightEffect;

- (UIImage*)applyDarkEffect;

- (UIImage*)applyTintEffectWithColor:(UIColor*)tintColor;

- (UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

@end
