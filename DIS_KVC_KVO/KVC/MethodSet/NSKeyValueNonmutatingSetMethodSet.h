//
//  NSKeyValueNonmutatingSetMethodSet.h
//  DIS_KVC_KVO
//
//  Created by renjinkui on 2017/2/16.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "NSKeyValueNonmutatingCollectionMethodSet.h"

@interface NSKeyValueNonmutatingSetMethodSet : NSKeyValueNonmutatingCollectionMethodSet
@property (nonatomic, assign) struct objc_method * count;
@property (nonatomic, assign) struct objc_method * enumerator;
@property (nonatomic, assign) struct objc_method * member;
@end
