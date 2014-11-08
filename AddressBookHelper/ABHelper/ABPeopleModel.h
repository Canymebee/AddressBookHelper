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
    eABPeopleAddress         = 0b1000000,
    eABPeopleBirthday        = 0b10000000,
    eABPeopleDate            = 0b100000000
};

@interface ABSimpleModel : NSObject

@property (nonatomic, strong) NSString *                type;

@end

@interface ABNameModel : ABSimpleModel

@property (nonatomic, strong) NSString *                firstName;
@property (nonatomic, strong) NSString *                middleName;
@property (nonatomic, strong) NSString *                lastName;

@end


@interface ABPhoneModel : ABSimpleModel

@property (nonatomic, strong) NSString *                phone;

@end


@interface ABEmailModel : ABSimpleModel

@property (nonatomic, strong) NSString *                email;

@end

@interface ABUrlModel : ABSimpleModel

@property (nonatomic, strong) NSString *                url;

@end

@interface ABAddressModel : ABSimpleModel

@property (nonatomic, strong) NSString *                city;
@property (nonatomic, strong) NSString *                state;
@property (nonatomic, strong) NSString *                country;
@property (nonatomic, strong) NSString *                street;
@property (nonatomic, strong) NSString *                zipCode;
@property (nonatomic, strong) NSString *                countryCode;

@end

@interface ABDateModel : ABSimpleModel

@property (nonatomic, strong) NSString *                date;

@end

@interface ABPeopleModel : NSObject

@property (nonatomic, strong) ABNameModel *             name;
@property (nonatomic, strong) NSMutableArray *          phones;
@property (nonatomic, strong) NSMutableArray *          emails;
@property (nonatomic, strong) UIImage *                 avatar;
@property (nonatomic, strong) NSString *                company;
@property (nonatomic, strong) NSMutableArray *          url;
@property (nonatomic, strong) NSMutableArray *          address;
@property (nonatomic, strong) NSDate *                  birthday;
@property (nonatomic, strong) NSMutableArray *          date;

@end
