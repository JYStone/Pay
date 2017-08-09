//
//  JYPayManager.h
//  iOS 支付封装
//
//  Created by 金靖媛 on 2017/8/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 支付结果
 * 支付成功                                         code = 0
 * 支付失败                                         code = -1
 * 支付取消                                         code = -2
 * 未安装app                                        code = -3
 * 设备或系统不支持，或者用户未绑卡(适用于ApplePay)       code = -4
 * 未知错误                                         code = -99
 */
@interface JYPayManager : NSObject
typedef void(^JYPayResponseBlock)(NSInteger responseCode, NSString *responseMsg);

/*
    实例化一个支付管理对象
 */
+ (instancetype)sharePayManager;

/*
    支付完成返回app
 */
+ (BOOL)handleOpenAppUrl:(NSURL *)url;

#pragma mark -- 支付宝
/*
     重要说明:
     privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
     防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
     https://doc.open.alipay.com/docs/doc.htm?spm=a219a.7629140.0.0.KrZ4Rv&treeId=193&articleId=105295&docType=1
 */

/*
 * 发起支付宝支付
 * order 服务器返回的sign
 * scheme 支付宝回掉的scheme 同设置的一样
 * block 返回结果
 */

- (void)aliPayOrder:(NSString *)order scheme:(NSString *)scheme responseBlock:(JYPayResponseBlock)block;
#pragma mark -- 微信

/*
     注册微信支付
     appId : 微信开放平台审核通过的应用APPID
     return : 是否注册成功
     https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1
 */
+ (BOOL)WXPayRegisterAppWithAppId:(NSString *)appId;
/*
     发起微信支付
     appId 微信开放平台审核通过的应用APPID
     partnerId 微信支付分配的商户号
     prepayId 微信生成的预支付回话标识，该值有效期为2小时
     package 暂填写固定值Sign=WXPay
     nonceStr 随机字符串，不长于32位。推荐随机数生成算法
     timeStamp 时间戳，请见接口规则-参数规定
     sign 签名，详见签名生成算法
     block 支付结果回调
 */
- (void)WXPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign responseBlock:(JYPayResponseBlock)block;

#pragma mark -- 银联

/**
     发起银联支付
     serialNo 是交易流水号
     viewController 发起支付的控制器
 block 支付结果回调
 https://open.unionpay.com/ajweb/help/file/techFile?cateLog=Development_kit
 */
- (void)UPPayWithSerialNo:(NSString *)serialNo
               fromScheme:(NSString *)scheme
           viewController:(id)viewController
            responseBlock:(JYPayResponseBlock)block;
#pragma mark -- 苹果内购
#pragma mark -- 百度钱包
// http://developer.baidu.com/platform/s37
@end
