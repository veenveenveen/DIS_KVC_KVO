//
//  NSKeyValueIvarSetter.m
//  DIS_KVC_KVO
//
//  Created by renjinkui on 2017/1/7.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "NSKeyValueIvarSetter.h"
#import "NSSetValueForKeyInIvar.h"
#import "NSKeyValueContainerClass.h"

void _NSSetValueAndNotifyForKeyInIvar(id object, SEL selector, id value, NSString *key, Ivar ivar, IMP imp) {
    [object willChangeValueForKey:key];
    
    ((void (*)(id,SEL,id,NSString *, Ivar))imp)(object,NULL,value,key,ivar);
    
    [object didChangeValueForKey:key];
}

@implementation NSKeyValueIvarSetter

- (id)initWithContainerClassID:(id)containerClassID key:(NSString *)key containerIsa:(Class)containerIsa ivar:(Ivar)ivar {
    IMP imp = NULL;
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    switch (*typeEncoding) {
        case 'c': {
            imp = (IMP)_NSSetCharValueForKeyInIvar;
        }
            break;
        case 'd': {
            imp = (IMP)_NSSetDoubleValueForKeyInIvar;
        }
            break;
        case 'f': {
            imp = (IMP)_NSSetFloatValueForKeyInIvar;
        }
            break;
        case 'i': {
            imp = (IMP)_NSSetIntValueForKeyInIvar;
        }
            break;
        case 'l': {
            imp = (IMP)_NSSetLongValueForKeyInIvar;
        }
            break;
        case 'q': {
            imp = (IMP)_NSSetLongLongValueForKeyInIvar;
        }
            break;
        case 's': {
            imp = (IMP)_NSSetShortValueForKeyInIvar;
        }
            break;
        case 'Q': {
            imp = (IMP)_NSSetUnsignedLongLongValueForKeyInIvar;
        }
            break;
        case 'L': {
            imp = (IMP)_NSSetUnsignedLongValueForKeyInIvar;
        }
            break;
        case 'B': {
            imp = (IMP)_NSSetBoolValueForKeyInIvar;
        }
            break;
        case 'C': {
            imp = (IMP)_NSSetUnsignedCharValueForKeyInIvar;
        }
            break;
        case 'I': {
            imp = (IMP)_NSSetUnsignedIntValueForKeyInIvar;
        }
            break;
        case 'S': {
            imp = (IMP)_NSSetUnsignedShortValueForKeyInIvar;
        }
            break;
        case '#':
        case '@':{
            objc_ivar_memory_management_t mngMent = _class_getIvarMemoryManagement(containerIsa, ivar);
            if(mngMent > objc_ivar_memoryUnretained) {
                imp = (IMP)_NSSetObjectSetIvarValueForKeyInIvar;
            }
            else if (mngMent == objc_ivar_memoryStrong) {
                imp = (IMP)_NSSetObjectSetStrongValueForKeyInIvar;
            }
            else if (mngMent == objc_ivar_memoryWeak) {
                imp = (IMP)_NSSetObjectSetWeakValueForKeyInIvar;
            }
            else if (mngMent == objc_ivar_memoryUnretained) {
                imp = (IMP)_NSSetObjectSetAssignValueForKeyInIvar;
            }
            else {
                imp = (IMP)_NSSetObjectSetManualValueForKeyInIvar;
            }
        }
            break;
        case '{': {
            char* idx = index(typeEncoding, '=');
            if (idx == NULL) {
                imp = (IMP)_NSSetValueInIvar;
            }
            else if (strncmp(typeEncoding, "{CGPoint=ff}", idx - typeEncoding) == 0){
                imp = (IMP)_NSSetPointValueForKeyInIvar;
            }
            else if (strncmp(typeEncoding, "{_NSPoint=ff}", idx - typeEncoding) == 0){
                imp = (IMP)_NSSetPointValueForKeyInIvar;
            }
            else if (strncmp(typeEncoding, "{_NSRange=II}", idx - typeEncoding) == 0){
                imp = (IMP)_NSSetRangeValueForKeyInIvar;
            }
            else if (strncmp(typeEncoding, "{CGRect={CGPoint=ff}{CGSize=ff}}", idx - typeEncoding) == 0){
                imp = (IMP)_NSSetRectValueForKeyInIvar;
            }
            else if (strncmp(typeEncoding, "{_NSRect={_NSPoint=ff}{_NSSize=ff}}", idx - typeEncoding) == 0){
                imp = (IMP)_NSSetRectValueForKeyInIvar;
            }
            else if (strncmp(typeEncoding, "{CGSize=ff}", idx - typeEncoding) == 0){
                imp = (IMP)_NSSetSizeValueForKeyInIvar;
            }
            else if (strncmp(typeEncoding, "{_NSSize=ff}", idx - typeEncoding) == 0){
                imp = (IMP)_NSSetSizeValueForKeyInIvar;
            }
            else {
                imp = (IMP)_NSSetValueInIvar;
            }
        }
            break;
        default:
            break;
    }
    
    if (imp) {
        SEL sel = NULL;
        void *extraArguments[3];
        NSUInteger argumentCount = 0;
        
        if (_NSKVONotifyingMutatorsShouldNotifyForIsaAndKey(containerIsa, key)) {
            sel = NULL;
            
            extraArguments[0] = key;
            extraArguments[1] = ivar;
            extraArguments[2] = imp;
            
            imp = (IMP)_NSSetValueAndNotifyForKeyInIvar;
            
            argumentCount = 3;
        }
        else {
            sel = NULL;
            
            extraArguments[0] = key;
            extraArguments[1] = ivar;
            extraArguments[2] = NULL;
            
            argumentCount = 2;
        }
        
        self = [super initWithContainerClassID:containerClassID key:key implementation:imp selector:sel extraArguments:extraArguments count:argumentCount];
        
        return self;
    }
    
    return nil;
}

- (struct objc_ivar *)ivar {
    return (struct objc_ivar *)self.extraArgument2;
}

@end
