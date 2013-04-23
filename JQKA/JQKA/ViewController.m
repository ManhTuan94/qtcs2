//
//  ViewController.m
//  JQKA
//
//  Created by Tuan EM on 4/23/13.
//  Copyright (c) 2013 Tuan EM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray* _photoArray;
    NSMutableArray* _timeArray;
    UISlider* slider;
    int currentPage;
}
@end

@implementation ViewController
@synthesize scrollView,player;

- (void)viewDidLoad
{
    [super viewDidLoad];
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10,self.view.frame.size.width-20, self.view.frame.size.height-40)];
    [self.view addSubview:scrollView];
    _photoArray = [[NSMutableArray alloc] init];
    [self getData];
    currentPage = 0;
    
   
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake((self.view.frame.size.width-20)*_photoArray.count, self.view.frame.size.height-40);
    for (int i=0; i<_photoArray.count; i++) {
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width*i,0, scrollView.frame.size.width, scrollView.frame.size.height)];
        image.image = _photoArray[i];
        image.contentMode = UIViewContentModeScaleToFill;
        [scrollView addSubview:image];
    }
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"qtcs" ofType:@"mp3"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    player = [[AVAudioPlayer alloc] initWithData:data error:nil];
   [player play];
   
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-30, self.view.frame.size.width - 40, 20)];
    slider.maximumValue = player.duration;
    [self.view addSubview:slider];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    [slider addTarget:self action:@selector(updatePlayer) forControlEvents:UIControlEventValueChanged];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollViews{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollViews.frame.size.width;
    float fractionalPage = scrollViews.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        slider.value = ([_timeArray[page] integerValue]);
        player.currentTime =slider.value;
        previousPage = page;
    }
}


-(void) updatePlayer {
    player.currentTime = slider.value;
    if (slider.value >[_timeArray[_timeArray.count-1] integerValue]) {
        [self scrollTo:_timeArray.count-1];
    }
    for (int i = 0; i < _timeArray.count-1; i++) {
        if ([_timeArray[i+1] integerValue] > slider.value && [_timeArray[i] integerValue] < slider.value) {
            [self scrollTo:i];
            return;
        }
    }
}


- (void)scrollTo:(NSInteger)newPage
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*newPage, 0) animated:YES];
    currentPage = newPage;
}


-(void) updateSlider{
    slider.value = player.currentTime;
}


-(void) autoScroll {
    if (slider.value >[_timeArray[_timeArray.count-1] integerValue]) {
        [self scrollTo:_timeArray.count-1];
    }
    for (int i = 0; i < _timeArray.count-1; i++) {
        if ([_timeArray[i+1] integerValue] > slider.value && [_timeArray[i] integerValue] < slider.value) {
            [self scrollTo:i];
            return;
        }
    }

}
-(void) getData {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"time" ofType:@"plist"];
    _timeArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (int i=0; i<21; i++) {
        [_photoArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
