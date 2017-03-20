//
//  ImageModel.m
//  PictureScrollDemo
//
//  Created by 吴展图 on 2017/3/20.
//  Copyright © 2017年 wuzhantu. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel
- (void)setImgSize:(NSString *)imgSize{
    _imgSize = imgSize;
    NSArray *imgSizeArr = [self.imgSize componentsSeparatedByString:@","];
    if (imgSizeArr.count > 1) {
        self.imgWidth = [imgSizeArr objectAtIndex:0];
        self.imgHeight = [imgSizeArr objectAtIndex:1];
    }
}
@end
