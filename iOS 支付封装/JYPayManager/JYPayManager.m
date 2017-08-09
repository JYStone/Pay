//
//  JYPayManager.m
//  iOS 支付封装
//
//  Created by 金靖媛 on 2017/8/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "JYPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "UPPaymentControl.h"
@interface JYPayManager()<WXApiDelegate>
/*
 支付宝支付结果回调
 */
@property (nonatomic, strong)JYPayResponseBlock alipayResponseBlock;
/*
 微信支付结果回调
 */
@property (nonatomic, strong)JYPayResponseBlock WXPayResponseBlock;
/*
 银联支付结果回调
 */
@property (nonatomic, strong)JYPayResponseBlock UPPayResponseBlock;
@end

@implementation JYPayManager
+ (instancetype)sharePayManager
{
    static JYPayManager *payManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payManager = [[JYPayManager alloc] init];
    });
    return payManager;
}

+ (BOOL)handleOpenAppUrl:(NSURL *)url {
    
    if([url.scheme hasPrefix:@"wx"])//微信
    {
        return [[JYPayManager sharePayManager] WXPayHandleOpenURL:url];
    }
    else if([url.host isEqualToString:@"uppayresult"])//银联
    {
        return [[JYPayManager sharePayManager] UPPayHandleOpenURL:url];
    }
    else if([url.host isEqualToString:@"safepay"])//支付宝
    {
        return [[JYPayManager sharePayManager] alipayHandleOpenURL:url];
    }
    
    return YES;
}


#pragma mark -------
#pragma mark -------  支付宝支付

- (BOOL)alipayHandleOpenURL:(NSURL *)url {
    
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        JYPayManager *manager = [JYPayManager sharePayManager];
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(manager.alipayResponseBlock)
            {
                manager.alipayResponseBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(manager.alipayResponseBlock)
            {
                manager.alipayResponseBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(manager.alipayResponseBlock)
            {
                manager.alipayResponseBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(manager.alipayResponseBlock)
            {
                manager.alipayResponseBlock(-99, @"未知错误");
            }
        }
        
    }];
    
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
    
    
    return YES;
}

- (void)aliPayOrder:(NSString *)order
             scheme:(NSString *)scheme
      responseBlock:(JYPayResponseBlock)block {
    
    self.alipayResponseBlock = block;
    
    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        NSNumber *code = resultDic[@"resultStatus"];
        
        //回调code
        if(code.integerValue==9000)
        {
            if(weakSelf.alipayResponseBlock)
            {
                weakSelf.alipayResponseBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(weakSelf.alipayResponseBlock)
            {
                weakSelf.alipayResponseBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(weakSelf.alipayResponseBlock)
            {
                weakSelf.alipayResponseBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(weakSelf.alipayResponseBlock)
            {
                weakSelf.alipayResponseBlock(-99, @"未知错误");
            }
        }
        
    }];
    
}




#pragma mark -------
#pragma mark -------  微信支付


+ (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
+ (BOOL)WXPayRegisterAppWithAppId:(NSString *)appId
{
    return [WXApi registerApp:appId];
}
- (BOOL)WXPayHandleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[JYPayManager sharePayManager]];
}
- (void)WXPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign responseBlock:(JYPayResponseBlock)block
{
    self.WXPayResponseBlock = block;
    
    if([WXApi isWXAppInstalled])
    {
        PayReq *req = [[PayReq alloc] init];
        req.openID = appId;
        req.partnerId = partnerId;
        req.prepayId = prepayId;
        req.package = package;
        req.nonceStr = nonceStr;
        req.timeStamp = (UInt32)timeStamp.integerValue;
        req.sign = sign;
        [WXApi sendReq:req];
    }
    else
    {
        if(self.WXPayResponseBlock)
        {
            self.WXPayResponseBlock(-3, @"未安装微信");
        }
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode)
        {
            case 0:
            {
                if(self.WXPayResponseBlock)
                {
                    self.WXPayResponseBlock(0, @"支付成功");
                }
                
                NSLog(@"支付成功");
                break;
            }
            case -1:
            {
                if(self.WXPayResponseBlock)
                {
                    self.WXPayResponseBlock(-1, @"支付失败");
                }
                
                NSLog(@"支付失败");
                break;
            }
            case -2:
            {
                if(self.WXPayResponseBlock)
                {
                    self.WXPayResponseBlock(-2, @"支付取消");
                }
                
                NSLog(@"支付取消");
                break;
            }
                
            default:
            {
                if(self.WXPayResponseBlock)
                {
                    self.WXPayResponseBlock(-99, @"未知错误");
                }
            }
                break;
        }
    }
}

#pragma mark -------
#pragma mark -------  银联支付

- (BOOL)UPPayHandleOpenURL:(NSURL*)url {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {

        JYPayManager *payManager = [JYPayManager sharePayManager];

        if([code isEqualToString:@"success"])
        {
            if(payManager.UPPayResponseBlock)
            {
                payManager.UPPayResponseBlock(0, @"支付成功");
            }

        }
        else if([code isEqualToString:@"fail"])
        {
            if(payManager.UPPayResponseBlock)
            {
                payManager.UPPayResponseBlock(-1, @"支付失败");
            }
        }
        else if([code isEqualToString:@"cancel"])
        {
            if(payManager.UPPayResponseBlock)
            {
                payManager.UPPayResponseBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(payManager.UPPayResponseBlock)
            {
                payManager.UPPayResponseBlock(-99, @"未知错误");
            }
        }

    }];

    return YES;
    
}

- (void)UPPayWithSerialNo:(NSString *)serialNo
               fromScheme:(NSString *)scheme
           viewController:(id)viewController
            responseBlock:(JYPayResponseBlock)block {
    //fromScheme是商户自定义协议  mode 是接入模式 "00" 表示线上环境"01"表示测试环境
    [[UPPaymentControl defaultControl] startPay:serialNo fromScheme:scheme mode:@"00" viewController:viewController];
    self.UPPayResponseBlock = block;
}

@end
