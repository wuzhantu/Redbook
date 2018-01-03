//
//  ViewController.m
//  PictureScrollDemo
//
//  Created by 吴展图 on 2017/3/20.
//  Copyright © 2017年 wuzhantu. All rights reserved.
//

#import "ViewController.h"
#import "ImageModel.h"
#import "UIView+KGViewExtend.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface ViewController (){
    CGFloat _lastPosition;
    int _currentPage;
}

@property(nonatomic,strong)NSArray *imageNameArr;
@property(nonatomic,strong)NSArray *imageSizeArr;
@property(nonatomic,strong)NSMutableArray *imageModelArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initDatas];
    [self initViews];
}

- (void)initDatas{
    self.imageNameArr = @[@"picture1.png",@"picture2.jpg",@"picture3.jpeg"];
    self.imageSizeArr = @[@"686,681",@"800,329",@"1242,6759"];
    
    self.imageModelArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.imageNameArr.count; i++) {
        ImageModel *model = [[ImageModel alloc] init];
        model.imgName = self.imageNameArr[i];
        model.imgSize = self.imageSizeArr[i];
        [self.imageModelArr addObject:model];
    }
}

- (void)initViews{
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.bounces = NO;
    
    CGFloat firstHeight = 0.0f;
    for (NSInteger i = 0; i < self.imageModelArr.count;i++) {
        ImageModel *model = [self.imageModelArr objectAtIndex:i];
    
        CGFloat width = SCREEN_WIDTH;
        CGFloat scale = [model.imgWidth floatValue] / width;
        CGFloat height = 0.0f;
        if (!([model.imgWidth integerValue] == 0)) {
            height =  [model.imgHeight floatValue] / scale;
        }else{
            height = width;
        }
        
        if (i == 0) {
            firstHeight = height;
        }
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, width/height*firstHeight, firstHeight)];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.backgroundColor = [UIColor lightGrayColor];
        imgView.tag = 100+i;
        imgView.image = [UIImage imageNamed:model.imgName];
        [self.imageScrollView addSubview:imgView];
        
        firstHeight = height;
    }
    
    UIImageView *imgView = (UIImageView *)[self.imageScrollView viewWithTag:100];
    self.imageScrollView.contentSize = CGSizeMake(self.imageModelArr.count*SCREEN_WIDTH, imgView.height);
    self.imageScrollViewHeight.constant = imgView.height;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat currentPostion = offsetX;
    
    int page = offsetX / SCREEN_WIDTH;
    
    BOOL isleft;
    if (currentPostion > _lastPosition) {
        isleft = YES;
        if (page > 0 && offsetX - page*SCREEN_WIDTH < 0.01) {
            page = page-1;
        }
    }
    else
    {
        isleft = NO;
    }
    
    if (page < 0 || page >= self.imageNameArr.count - 1) {
        return;
    }
    
    UIImageView *firstImgView = (UIImageView *)[self.imageScrollView viewWithTag:100+page];
    UIImageView *secondImgView = (UIImageView *)[self.imageScrollView viewWithTag:100+page+1];
    ImageModel *firstModel = [self.imageModelArr objectAtIndex:page];
    ImageModel *secondModel = [self.imageModelArr objectAtIndex:page+1];
    CGFloat firstImgHeight = [self heightformodel:firstModel];
    CGFloat secondImgHeight = [self heightformodel:secondModel];
    
    CGFloat distanceY = isleft ? secondImgHeight-firstImgView.height : firstImgHeight-firstImgView.height;
    CGFloat leftDistanceX = (page+1)*SCREEN_WIDTH-_lastPosition;
    CGFloat rightDistanceX = SCREEN_WIDTH-leftDistanceX;
    CGFloat distanceX = isleft ? leftDistanceX : rightDistanceX;
    
    CGFloat movingDistance = 0.0;
    if (distanceX != 0 && fabs(_lastPosition-currentPostion) > 0) {
        movingDistance = distanceY/distanceX*(fabs(_lastPosition-currentPostion));
    }
    
    CGFloat firstScale = [firstModel.imgWidth floatValue] / [firstModel.imgHeight floatValue];
    CGFloat secondScale = [secondModel.imgWidth floatValue] / [secondModel.imgHeight floatValue];
    
    firstImgView.frame = CGRectMake((firstImgView.frame.origin.x-movingDistance*firstScale), 0, (firstImgView.height+movingDistance)*firstScale, firstImgView.height+movingDistance);
    secondImgView.frame = CGRectMake(SCREEN_WIDTH*(page+1), 0, firstImgView.height*secondScale, firstImgView.height);
    self.imageScrollView.contentSize = CGSizeMake(self.imageScrollView.contentSize.width, firstImgView.height);
    self.imageScrollViewHeight.constant = firstImgView.height;
    
    int newpage = offsetX / SCREEN_WIDTH;
    if (offsetX - newpage*SCREEN_WIDTH < 0.01) {
        _currentPage = newpage+1;
    }
    
    _lastPosition = currentPostion;
}

- (CGFloat)heightformodel:(ImageModel *)model{
    CGFloat width = SCREEN_WIDTH;
    CGFloat scale = [model.imgWidth floatValue] / width;
    CGFloat height =  [model.imgHeight floatValue] / scale;
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
