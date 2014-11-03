//
//  ABPeopleModel.m
//  AddressBookHelper
//
//  Created by Rain on 14/11/3.
//  Copyright (c) 2014年 Canymebee. All rights reserved.
//

#import "ABPeopleModel.h"

@implementation ABPeopleModel

- (id)init
{
    self = [super self];
    if (self) {
        self.name = [[NSMutableDictionary alloc] init];
        self.phones = [[NSMutableArray alloc] init];
        self.emails = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
