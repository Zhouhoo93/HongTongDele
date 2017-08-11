//
//  LiuqsEmotionButton.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/12.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "LiuqsButton.h"

@implementation LiuqsButton

- (void)setEmotionName:(NSString *)emotionName {

    _emotionName = emotionName;
//    UIImage *image = [UIImage imageNamed:emotionName];
//    if (image) {[self setImage:image forState:UIControlStateNormal];}
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    NSArray *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",rootDict[0]);
    int index = [emotionName intValue]-101;
    if (![emotionName isEqualToString:@"back_arrow"]) {
//        self.titleLabel.text = rootDict[index];
        [self setTitle:rootDict[index] forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;

    }
}


@end
