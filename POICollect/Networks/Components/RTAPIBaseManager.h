//
//  RTAPIBaseManager.h
//  POICollect
//
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

/**
 *  在调用成功后的params字典里面，用这个key可以取出requestID
 */
static NSString* const kRTAPIBaseManagerRequestID = @"kRTAPIBaseManagerRequestID";

@class RTAPIBaseManager;
@class AIFURLResponse;

/**
 *  请求返回数据的状态
 */
typedef NS_ENUM(NSUInteger, RTAPIManagerErrorType) {
    /**
     *  没有产生过API请求，这是manager的默认状态
     */
    RTAPIManagerErrorTypeDefault,
    /**
     *  API请求成功并且返回数据，这个时候的manager的数据是可以直接拿来用的
     */
    RTAPIManagerErrorTypeSuccess,
    /**
     *  API请求成功但是返回的数据不正确，如果回调数据验证函数返回值是NO，manager的状态就是这个
     */
    RTAPIManagerErrorTypeNoContent,
    /**
     *  参数错误，此时manager不会调用API，因为参数验证时在调用API之前做的
     */
    RTAPIManagerErrorTypeParamsError,
    /**
     *  请求超时
     */
    RTAPIManagerErrorTypeTimeout,
    /**
     *  网络不通，在调用API之前会判断一下当前的网络是否畅通，这个也是在调用API之前验证的，和上面的状态是有区别的
     */
    RTAPIManagerErrorTypeNoNetwork
};

/**
 *  请求的类型
 */
typedef NS_ENUM(NSUInteger, RTAPIManagerRequestType) {
    /**
     *  GET
     */
    RTAPIManagerRequestTypeGet,
    /**
     *  POST
     */
    RTAPIManagerRequestTypePost,
    /**
     *  DELETE
     */
    RTAPIManagerRequestTypeDelete,
    /**
     *  PUSH
     */
    RTAPIManagerRequestTypePush
};

/****************************************************************************
 *                              RTAPIManagerApiCallBackDelegate
 ****************************************************************************/

/**
 *  API的回调协议，所有的实现类都得实现这个方法
 */
@protocol RTAPIManagerApiCallBackDelegate <NSObject>

@required

/**
 *  请求成功回调函数
 *
 *  @param manager manager对象
 */
- (void)managerCallAPIDidSuccess:(RTAPIBaseManager*)manager;

/**
 *  请求失败回调函数
 *
 *  @param manager manager对象
 */
- (void)managerCallAPIDidFailed:(RTAPIBaseManager*)manager;

@end

/****************************************************************************
 *                              RTAPIManagerCallBackDataReformer
 ****************************************************************************/

@protocol RTAPIManagerCallBackDataReformer <NSObject>

@required

/**
 *  重新组装API数据对象
 *
 *  @param manager manager 对象
 *  @param data    数据
 *
 *  @return 转换后的数据
 
 
    代码样例：
    - (id)manager:(RTAPIBaseManager *)manager reformData:(NSDictionary *)data
    {
        if ([manager isKindOfClass:[xinfangManager class]]) {
            return [self xinfangPhoneNumberWithData:data];      //这是调用了派生后reformer子类自己实现的函数，别忘了reformer自己也是一个对象呀。
            //reformer也可以有自己的属性，当进行业务逻辑需要一些外部的辅助数据的时候，
            //外部使用者可以在使用reformer之前给reformer设置好属性，使得进行业务逻辑时，
            //reformer能够用得上必需的辅助数据。
        }
 
        if ([manager isKindOfClass:[zufangManager class]]) {
            return [self zufangPhoneNumberWithData:data];
        }
 
        if ([manager isKindOfClass:[ershoufangManager class]]) {
            return [self ershoufangPhoneNumberWithData:data];
        }
    }
 
 */
- (id)manager:(RTAPIBaseManager*)manager reformData:(NSDictionary*)data;

@end

/****************************************************************************
 *                              RTAPIManagerValidator
 ****************************************************************************/

/**
 *  验证器，用于检验API的返回或者调用API的参数是不是正确
 */
@protocol RTAPIManagerValidator <NSObject>

@required

/**
 *  所有的callback数据都应该放在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 *  因为判断的逻辑都在这里了。
 *  而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放回到controller的delegate方法里面去做
 *
 *  @param manager manager
 *  @param data    数据
 *
 *  @return 是否验证通过
 */
- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithCallBackData:(NSDictionary*)data;

/**
 *  验证请求的参数的方法。当调用API的参数是来自用户输入的时候，验证时必要的。
 *  当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。
 *
 *  @param manager manager对象
 *  @param data    参数的字典数据
 *
 *  @return 是否验证通过
 */
- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithParamsData:(NSDictionary*)data;

@end

/****************************************************************************
 *                              RTAPIManagerParamSourceDelegate
 ****************************************************************************/

/**
 *  获取调用API所需要的参数数据
 */
@protocol RTAPIManagerParamSourceDelegate <NSObject>

@required

/**
 *  获取请求的参数字典
 *
 *  @param manager manager对象
 *
 *  @return 返回的参数的字典 
 */
- (NSDictionary*)paramsForAPI:(RTAPIBaseManager*)manager;

@end

/****************************************************************************
 *                              RTAPIManager
 ****************************************************************************/

/**
 *  RTAPIManager的子类必须符合这个protocol
 */
@protocol RTAPIManager <NSObject>

@required

- (NSString*)methodName;

- (NSString*)serviceType;

- (RTAPIManagerRequestType)requestType;

@optional

- (void)cleanData;

- (NSDictionary*)reformParams:(NSDictionary*)params;

- (BOOL)shouldCache;

@end

/****************************************************************************
 *                              RTAPIManagerIntercepter
 ****************************************************************************/

/**
 *  拦截器，RTAPIBaseManager的派生类必须符合这些protocol；
 */
@protocol RTAPIManagerIntercepter <NSObject>

@optional

- (void)manager:(RTAPIBaseManager*)manager beforePreformSuccessWithResponse:(AIFURLResponse*)response;
- (void)manager:(RTAPIBaseManager*)manager afterPreformSuccessWithResponse:(AIFURLResponse*)response;

- (void)manager:(RTAPIBaseManager*)manager beforePreformFailWithResponse:(AIFURLResponse*)response;
- (void)manager:(RTAPIBaseManager*)manager afterPreformFailWithResponse:(AIFURLResponse*)response;

- (void)manager:(RTAPIBaseManager*)manager shouldCallAPIWithParams:(NSDictionary*)params;
- (void)manager:(RTAPIBaseManager*)manager afterCallingAPIWithParams:(NSDictionary*)params;

@end

/****************************************************************************
 *                              RTAPIBaseManager
 ****************************************************************************/

/**
 *  基类
 */
@interface RTAPIBaseManager : NSObject

#pragma mark - 属性

/**
 *  回调协议
 */
@property (nonatomic, weak) id<RTAPIManagerApiCallBackDelegate> delegate;

/**
 *  参数的数据源
 */
@property (nonatomic, weak) id<RTAPIManagerParamSourceDelegate> paramSource;

/**
 *  验证器
 */
@property (nonatomic, weak) id<RTAPIManagerValidator> validator;

/**
 *  派生类的对象,因为里面会用到NSObject的方法，所以不用id
 */
@property (nonatomic, weak) NSObject<RTAPIManager>* child;

/**
 *  拦截器
 */
@property (nonatomic, weak) id<RTAPIManagerIntercepter> intercepter;

/**
 *  BaseManager是不会去设置errorMessage的，派生的子类manager可能要给controller提供错误信息。所以为了统一外部调用的出口，设置了这个变量。
 *  派生的子类需要通过extension来保证errorMessage在对外只读的情况下，使派生的manager类对errorMessage具有读写权限
 */
@property (nonatomic, copy, readonly) NSString* errorMessage;

/**
 *  错误类型
 */
@property (nonatomic, readonly) RTAPIManagerErrorType errType;

/**
 *  网络是不是畅通
 */
@property (nonatomic, assign, readonly) BOOL isReachable;

/**
 *  是不是正在加载 
 */
@property (nonatomic, assign, readonly) BOOL isLoading;

#pragma mark - 公共实例方法

- (void)fetchDataWithReformer:(id<RTAPIManagerCallBackDataReformer>)reformer;

/**
 *  开始加载数据，尽量使用这个方法，这个方法会通过param source来获取参数，这使得参数的生成逻辑位于controller中的固定位置 
 *
 *  @return 返回的是 NSInteger 的 requestId
 */
- (NSInteger)loadData;

/**
 *  取消所有的请求 
 */
- (void)cancelAllRequests;

/**
 *  取消requestId对应的请求
 *
 *  @param requestId requestId
 */
- (void)cancelRequestWithRequestId:(NSInteger)requestId;

#pragma mark - 拦截器方法，继承之后需要调用一下super

- (void)beforePreformSuccessWithResponse:(AIFURLResponse*)response;
- (void)afterPreformSuccessWithResponse:(AIFURLResponse*)response;

- (void)beforePreformFailWithResponse:(AIFURLResponse*)response;
- (void)afterPreformFailWithResponse:(AIFURLResponse*)response;

- (void)shouldCallAPIWithParams:(NSDictionary*)params;
- (void)afterCallingAPIWithParams:(NSDictionary*)params;

/**
 *  用于给继承的类做重载，在调用API之前额外添加一些参数,但不应该在这个函数里面修改已有的参数。
 *  子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
 *  RTAPIBaseManager会先调用这个函数，然后才会调用到 id<RTAPIManagerValidator> 中的 manager:isCorrectWithParamsData:
 *  所以这里返回的参数字典还是会被后面的验证函数去验证的。
 *
 *  假设同一个翻页Manager，ManagerA的paramSource提供page_size=15参数，ManagerB的paramSource提供page_size=2参数
 *  如果在这个函数里面将page_size改成10，那么最终调用API的时候，page_size就变成10了。然而外面却觉察不到这一点，因此这个函数要慎用。
 *
 *  这个函数的适用场景：
 *  当两类数据走的是同一个API时，为了避免不必要的判断，我们将这一个API当作两个API来处理。
 *  那么在传递参数要求不同的返回时，可以在这里给返回参数指定类型。
 *
 *  @param params 原始参数
 *
 *  @return 返回转换后的参数
 */
- (NSDictionary*)reformParams:(NSDictionary*)params;

- (void)cleanData;

- (BOOL)shouldCache;

@end
