//
//  ABPeopleModel.h
//  AddressBookHelper
//
//  Created by Rain on 14/11/3.
//  Copyright (c) 2014年 Canymebee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AddressBookAttributes) {
    eABPeopleName            = 0b1,
    eABPeoplePhones          = 0b10,
    eABPeopleEmails          = 0b100,
    eABPeopleCompany         = 0b1000,
    eABPeopleAvatar          = 0b10000,
    eABPeopleUrl             = 0b100000,
    eABPeopleAddress         = 0b1000000
};

@interface ABPeopleModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *     name;
@property (nonatomic, strong) NSMutableArray *          phones;
@property (nonatomic, strong) NSMutableArray *          emails;
@property (nonatomic, strong) UIImage *                 avatar;
@property (nonatomic, strong) NSString *                company;
@property (nonatomic, strong) NSString *                url;
@property (nonatomic, strong) NSString *                address;
@property (nonatomic, strong) NSDate *                  birthday;
@property (nonatomic, strong) NSDate *                  date;

@end
