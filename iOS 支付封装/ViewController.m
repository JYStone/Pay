//
//  ViewController.m
//  iOS 支付封装
//
//  Created by 金靖媛 on 2017/8/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "ViewController.h"
#import "JYPayManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)aliPayBtnClick:(id)sender {
    NSString *order = @"app_id=2015052600090779&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22seller_id%22%3A%22%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.02%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22314VYGIAGG7ZOYY%22%7D&charset=utf-8&method=alipay.trade.app.pay&sign_type=RSA&timestamp=2016-08-15%2012%3A12%3A15&version=1.0&sign=MsbylYkCzlfYLy9PeRwUUIg9nZPeN9SfXPNavUCroGKR5Kqvx0nEnd3eRmKxJuthNUx4ERCXe552EV9PfwexqW%2B1wbKOdYtDIb4%2B7PL3Pc94RZL0zKaWcaY3tSL89%2FuAVUsQuFqEJdhIukuKygrXucvejOUgTCfoUdwTi7z%2BZzQ%3D";
    [[JYPayManager sharePayManager] aliPayOrder:order scheme:@"com.iOSPay.jy" responseBlock:^(NSInteger responseCode, NSString *responseMsg) {
        NSLog(@"----%zd------%@-----",(long)responseCode,responseMsg);
    }];
}
- (IBAction)weChartBtnClick:(id)sender {
    //向服务端发起请求获取参数信息等
    [[JYPayManager sharePayManager] WXPayWithAppId:@"wxb4ba3c02aa476ea1" partnerId:@"10000100" prepayId:@"1101000000140415649af9fc314aa427" package:@"Sign=WXPay" nonceStr:@"a462b76e7436e98e0ed6e13c64b4fd1c" timeStamp:@"1397527777" sign:@"582282D72DD2B03AD892830965F428CB16E7A256" responseBlock:^(NSInteger responseCode, NSString *responseMsg) {
        NSLog(@"----%zd------%@-----",(long)responseCode,responseMsg);
    }];
}
- (IBAction)unionBtnClick:(id)sender {
    //向服务端发起请求获取SerialNo
    [[JYPayManager sharePayManager] UPPayWithSerialNo:@"123467562583256" fromScheme:@"com.iOSPay.jy" viewController:self responseBlock:^(NSInteger responseCode, NSString *responseMsg) {
        NSLog(@"----%zd------%@-----",(long)responseCode,responseMsg);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
