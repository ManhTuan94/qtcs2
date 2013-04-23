//
//  ViewController.h
//  JQKA
//
//  Created by Tuan EM on 4/23/13.
//  Copyright (c) 2013 Tuan EM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController<UIScrollViewDelegate>
@property(strong,nonatomic) UIScrollView* scrollView;
@property(strong,nonatomic) AVAudioPlayer* player;
@end
