//
//  SSChatMapCell.m
//  SSChatView
//
//  Created by soldoros on 2018/10/15.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatMapCell.h"

@implementation SSChatMapCell

-(void)initChatCellUI{
    
    [super initChatCellUI];
 
    _mTitleLab = [UILabel new];
    _mTitleLab.bounds = CGRectMake(0, 0, 120, 25);
    _mTitleLab.font = [UIFont systemFontOfSize:16];
    _mTitleLab.textColor = [UIColor blackColor];
    _mTitleLab.textAlignment = NSTextAlignmentLeft;
    [self.bubbleBackView addSubview:_mTitleLab];
    
    
    _mDetaiLLab = [UILabel new];
    _mDetaiLLab.bounds = CGRectMake(0, 0, 120, 25);
    _mDetaiLLab.font = [UIFont systemFontOfSize:12];
    _mDetaiLLab.textColor = [UIColor lightGrayColor];
    _mDetaiLLab.textAlignment = NSTextAlignmentLeft;
    [self.bubbleBackView addSubview:_mDetaiLLab];
    
    
    _mLine = [UIView new];
    _mLine.bounds = CGRectMake(0, 0, 200, 0.8);
    _mLine.backgroundColor = [UIColor colorWithRed:235 / 255.0f green: 235 / 255.0f blue:235 / 255.0f alpha:1];
     [self.bubbleBackView addSubview:_mLine];
    
    
    //初始化地图
    _mMapView = [MKMapView new];
    _mMapView.delegate = self;
    _mMapView.mapType = MKMapTypeStandard;
    _mMapView.showsUserLocation = YES;
    _mMapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.bubbleBackView addSubview:_mMapView];
    
    
    _mMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bubbleBackView addSubview:_mMapButton];
    [_mMapButton addTarget:self action:@selector(mapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setModel:(FYMessagelLayoutModel *)model{
    
    [super setModel:model];
    
    UIImage *image = [UIImage imageNamed:@"icon_qipao3"];
    image = [image resizableImageWithCapInsets:model.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = image;
//    [self.bubbleBackView setBackgroundImage:image forState:UIControlStateNormal];

    _mTitleLab.width = self.bubbleBackView.width - 30;
    _mDetaiLLab.width = self.bubbleBackView.width - 30;
    _mTitleLab.text = self.model.message.addressString;
    _mDetaiLLab.text = self.model.message.addressString;
    [_mTitleLab sizeToFit];
    [_mDetaiLLab sizeToFit];
    _mTitleLab.width = self.bubbleBackView.width - 30;
    _mDetaiLLab.width = self.bubbleBackView.width - 30;
    _mTitleLab.top = 7.5;
    _mTitleLab.left = 10;
    _mDetaiLLab.top = _mTitleLab.bottom + 5;
    _mDetaiLLab.left = _mTitleLab.left;
    
    
    _mMapView.frame = CGRectMake(1.2, 53, self.bubbleBackView.width-9.1, self.bubbleBackView.height-53.6);
    double lat = self.model.message.latitude;
    double lon = self.model.message.longitude;
    CLLocationCoordinate2D coord = (CLLocationCoordinate2D){lat, lon};
    [_mMapView setCenterCoordinate:coord animated:YES];
    
//    _mMapView.frame = self.bubbleBackView.bounds;
//    [_mMapView setVisibleMapRect:MKMapRectMake(0, 50, _mMapView.width, _mMapView.height-50) edgePadding:UIEdgeInsetsMake(50, 0, 0, 0) animated:YES];
//
//    UIImageView *btnImgView = [[UIImageView alloc]initWithImage:image];
//    btnImgView.frame = CGRectInset(_mMapView.frame, 0.0f, 0.0f);
//    _mMapView.layer.mask = btnImgView.layer;
    
    
    _mLine.width = _mMapView.width;
    _mLine.bottom = _mMapView.top;
    _mLine.left = _mMapView.left;
    
    
    _mMapButton.frame = self.bubbleBackView.bounds;
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ) {
        pinView = [[MKPinAnnotationView alloc]  initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    pinView.pinTintColor = [UIColor redColor];
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    [mapView.userLocation setTitle:@"欧陆经典"];
    [mapView.userLocation setSubtitle:@"vsp"];
    return pinView;
    
}


-(void)mapButtonPressed:(UIButton *)sendeer{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChatMapCellIndexPath:layout:)]){
        [self.delegate didChatMapCellIndexPath:self.indexPath layout:self.model];
    }
}






@end
