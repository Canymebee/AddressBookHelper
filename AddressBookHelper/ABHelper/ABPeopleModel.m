//
//  ABPeopleModel.m
//  AddressBookHelper
//
//  Created by Rain on 14/11/3.
//  Copyright (c) 2014年 Canymebee. All rights reserved.
//

#import "ABPeopleModel.h"

@implementation ABSimpleModel

-(id)init
{
    self = [super init];
    if (self) {
        self.type = @"";
    }
    return self;
}

@end


@implementation ABNameModel


@end


@implementation ABPhoneModel


@end


@implementation ABEmailModel


@end


@implementation ABUrlModel


@end


@implementation ABAddressModel


@end


@implementation ABDateModel


@end


@implementation ABPeopleModel

- (id)init
{
    self = [super init];
    if (self) {
        self.name = [[ABNameModel alloc] init];
        self.phones = [[NSMutableArray alloc] init];
        self.emails = [[NSMutableArray alloc] init];
        self.url = [[NSMutableArray alloc] init];
        self.address = [[NSMutableArray alloc] init];
        self.date = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

