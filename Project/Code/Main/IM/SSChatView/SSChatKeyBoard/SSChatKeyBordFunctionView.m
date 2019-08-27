//
//  SSChatKeyBordFunctionView.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatKeyBordFunctionView.h"


@interface SSChatKeyBordFunctionView()
@property(nonatomic,strong)UIPageControl *pageControll;
@property (nonatomic, assign) NSInteger numberPage;
@end


@implementation SSChatKeyBordFunctionView{
    NSArray *titles,*images,*viewTag;
    NSInteger count;
    NSInteger number;
}



-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = SSChatCellColor;
        count = 8;
        
        //添加功能只需要在标题和图片数组里面直接添加就行
//        titles = @[@"照片",@"视频",@"位置"];
//        images = @[@"zhaopian",@"shipin",@"weizhi"];
        
        if ([AppModel shareInstance].chatType == 1) {//群聊
           if ([AppModel shareInstance].officeFlag){
               titles = @[@"福利",@"加盟",@"红包",@"充值",@"玩法",@"群规",@"帮助",@"客服",@"照片",@"拍照",@"赚钱",@"",@"",@"",@""];
               images = @[@"csb_welfare",@"csb_join",@"csb_tuo_redpocket",@"csb_refill",@"csb_wanfa",@"csb_rule",@"csb_help",@"csb_tuo_customer_service",@"csb_photo_album",@"csb_camera",@"csb_make_money",@"",@"",@"",@""];
               viewTag = @[@(2000),@(2001),@(2002),@(2003),@(2004),@(2005),@(2006),@(2007),@(2008),@(2009),@(2010),@(0),@(0),@(0),@(0)];
           }else{
                titles = @[@"照片",@"拍照",@"加盟",@"充值",@"帮助",@"客服",@"赚钱",@"玩法"];
                 images = @[@"csb_photo_album",@"csb_camera",@"csb_join",@"csb_refill",@"csb_help",@"csb_tuo_customer_service",@"csb_make_money",@"csb_wanfa"];
                 viewTag = @[@(2008),@(2009),@(2001),@(2003),@(2006),@(2007),@(2010),@(2004)];
           }
        } else {
//            titles = @[@"加盟",@"充值",@"玩法",@"帮助",@"客服",@"照片",@"拍照",@"赚钱"];
//            images = @[@"csb_join",@"csb_refill",@"csb_wanfa",@"csb_help",@"csb_tuo_customer_service",@"csb_photo_album",@"csb_camera",@"csb_make_money"];
//            viewTag = @[@(2001),@(2003),@(2004),@(2006),@(2007),@(2008),@(2009),@(2010)];
            
            
            titles = @[@"玩法",@"帮助",@"加盟",@"客服",@"充值",@"赚钱",@"照片",@"拍照"];
            images = @[@"csb_wanfa",@"csb_help",@"csb_join",@"csb_tuo_customer_service",@"csb_refill",@"csb_make_money",@"csb_photo_album",@"csb_camera"];
            viewTag = @[@(2020),@(2006),@(2001),@(2007),@(2003),@(2010),@(2008),@(2009)];
        }
        
        
        
        NSInteger number = titles.count%count == 0 ? titles.count/count :titles.count/count +1;
        
        
        _mScrollView = [UIScrollView new];
        _mScrollView.frame = self.bounds;
        _mScrollView.centerY = self.height * 0.5;
        _mScrollView.backgroundColor = SSChatCellColor;
        _mScrollView.pagingEnabled = YES;
        _mScrollView.delegate = self;
        [self addSubview:_mScrollView];
        _mScrollView.maximumZoomScale = 2.0;
        _mScrollView.minimumZoomScale = 0.5;
        _mScrollView.canCancelContentTouches = NO;
        _mScrollView.delaysContentTouches = YES;
        _mScrollView.showsVerticalScrollIndicator = FALSE;
        _mScrollView.showsHorizontalScrollIndicator = FALSE;
        _mScrollView.backgroundColor = [UIColor clearColor];
        _mScrollView.contentSize = CGSizeMake(FYSCREEN_Width *number, self.height);
        
//        _pageControll = [[UIPageControl alloc] init];
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
//        _pageControll.bounds = CGRectMake(0, 0, 160, 10);
        _pageControll.centerX  = FYSCREEN_Width*0.5;
        _pageControll.top = self.height - kiPhoneX_Bottom_Height;
        _pageControll.numberOfPages = number;
        _pageControll.currentPage = 0;

        [_pageControll setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControll setPageIndicatorTintColor:makeColorRgb(200, 200, 200)];
        
        [self addSubview:_pageControll];
        
//        _pageControll.backgroundColor = [UIColor redColor];
        
        
        for(NSInteger i=0;i<number;++i){
            
            UIView *backView = [UIView new];
            backView.bounds = CGRectMake(0, 0, self.width-40, self.height-55);
            backView.centerX = self.width*0.5 + i*self.width;
            backView.top = 20;
            [_mScrollView addSubview:backView];
            
            for(NSInteger j= (i * count);j<(i+1)*count && j<titles.count;++j){
                
                UIView *btnView = [UIView new];
                btnView.bounds = CGRectMake(0, 0, backView.width/4, backView.height*0.5);
                btnView.tag = [viewTag[j] integerValue];
                btnView.left = j%4 * btnView.width;
                btnView.top = (j/4)%2*btnView.height;
                [backView addSubview:btnView];
                btnView.backgroundColor = SSChatCellColor;
//                if(btnView.top>btnView.height) {
//                    btnView.top = 0;
//                }
                
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.bounds = CGRectMake(0, 0, 50, 50);
                btn.top = 15;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.centerX = btnView.width*0.5;
                [btnView addSubview:btn];
                NSString *icoName = images[j];
                if (icoName.length > 0) {
                    [btn setImage:[UIImage imageNamed:icoName] forState:UIControlStateNormal];
                }
                btn.userInteractionEnabled = YES;
                
                
                UILabel *lab = [UILabel new];
                lab.bounds = CGRectMake(0, 0, 80, 20);
                lab.text = titles[j];
                lab.font = [UIFont systemFontOfSize:12];
                lab.textColor = [UIColor grayColor];
                lab.textAlignment = NSTextAlignmentCenter;
                [lab sizeToFit];
                lab.centerX = btnView.width*0.5;
                lab.top = btn.bottom + 15;
                [btnView addSubview:lab];
                lab.userInteractionEnabled = YES;
                
                
                UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerGestureClick:)];
                [btnView addGestureRecognizer:gesture];
                
            }
        }
        
    }
    return self;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.mScrollView) {
        if (scrollView.contentOffset.x >= FYSCREEN_Width * self.numberPage){
            self.numberPage = 1;
        } else {
            self.numberPage = 0;
        }
        self.pageControll.currentPage = (self.mScrollView.contentOffset.x / FYSCREEN_Width);
    }
}

//多功能点击10+
-(void)footerGestureClick:(UITapGestureRecognizer *)sender{
    
    if(_delegate && [_delegate respondsToSelector:@selector(SSChatKeyBordFunctionViewBtnClick:)]){
        [_delegate SSChatKeyBordFunctionViewBtnClick:sender.view.tag];
    }
}


@end
