//
//  ABHelper.h
//  AddressBookHelper
//
//  Created by Rain on 14/11/3.
//  Copyright (c) 2014年 Canymebee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABReaderHelper : NSObject


+ (BOOL)checkAccess;
+ (BOOL)requireAccess;
+ (NSArray *)getAddressBookWithAttributes:(NSUInteger)attributes;

@end
