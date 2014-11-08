//
//  ABHelper.m
//  AddressBookHelper
//
//  Created by Rain on 14/11/3.
//  Copyright (c) 2014年 Canymebee. All rights reserved.
//

#import "ABReaderHelper.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ABPeopleModel.h"

@implementation ABReaderHelper

+ (BOOL)checkAccess
{
    CFErrorRef * err = nil;
    ABAddressBookRegisterExternalChangeCallback(ABAddressBookCreateWithOptions(nil, err), ABExternalChangeCallbackFunc, (__bridge void *)(self));
    
    return kABAuthorizationStatusAuthorized == ABAddressBookGetAuthorizationStatus();
}

void ABExternalChangeCallbackFunc (ABAddressBookRef ntificationaddressbook,CFDictionaryRef info,void *context)
{
    NSDate * startTime = [NSDate date];
    NSDate * finishTime = [NSDate date];
    NSLog(@"*** Update AddressBook DB when external changed TIME : %f", [finishTime timeIntervalSinceDate:startTime]);
}


+ (BOOL)requireAccess
{
    CFErrorRef * err = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, err);
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != nil) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else {
        accessGranted = YES;
    }
    
    return accessGranted;
}


+ (NSArray *)getAddressBookWithAttributes:(NSUInteger)attributes;
{
    CFErrorRef * err = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, err);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex count = ABAddressBookGetPersonCount(addressBook);
    NSMutableArray * contactsInfo = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i ++ ) {
        ABPeopleModel * people = [[ABPeopleModel alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        if (eABPeopleName == (attributes & eABPeopleName)) {
            if (ABRecordCopyValue(person, kABPersonLastNameProperty) || ABRecordCopyValue(person, kABPersonMiddleNameProperty) || ABRecordCopyValue(person, kABPersonFirstNameProperty)) {
                people.name.lastName = NotNilString((__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty));
                people.name.middleName = NotNilString((__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty));
                people.name.firstName = NotNilString((__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty));
            }
        }
        if (eABPeoplePhones == (attributes & eABPeoplePhones)) {
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex j = 0; j < ABMultiValueGetCount(multiPhones); j ++) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, j);
                CFStringRef phoneNumberLabelRef = ABMultiValueCopyLabelAtIndex(multiPhones, j);
                NSString * phoneNumber = NotNilString((__bridge NSString *) phoneNumberRef);
                NSString * phoneNumberLabel = NotNilString((__bridge NSString *)phoneNumberLabelRef);
                ABPhoneModel * phone = [[ABPhoneModel alloc] init];
                phone.phone = phoneNumber;
                phone.type = phoneNumberLabel;
                [people.phones addObject:phone];
            }
        }
        if (eABPeopleEmails == (attributes & eABPeopleEmails)) {
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            for(CFIndex j = 0; j < ABMultiValueGetCount(multiEmails); j ++) {
                NSString * email = NotNilString((__bridge NSString *) ABMultiValueCopyValueAtIndex(multiEmails, j));
                NSString * emailLabel = NotNilString((__bridge NSString *)ABMultiValueCopyLabelAtIndex(multiEmails, j));
                ABEmailModel * emailModel = [[ABEmailModel alloc] init];
                emailModel.email = email;
                emailModel.type = emailLabel;
                [people.emails addObject:email];
            }
        }
        if (eABPeopleCompany == (attributes & eABPeopleCompany)) {
            people.company = (__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);;
        }
        if (eABPeopleAvatar == (attributes & eABPeopleAvatar)) {
            NSData * imagedata = (__bridge NSData *)ABPersonCopyImageData(person);
            UIImage * avatar = [UIImage imageWithData:imagedata];
            people.avatar = avatar;
        }
        if (eABPeopleUrl == (attributes & eABPeopleUrl)) {
            ABMultiValueRef urls = ABRecordCopyValue(person, kABPersonURLProperty);
            for (int j = 0; j < ABMultiValueGetCount(urls); j ++) {
                NSString * urlRef = (__bridge NSString *)ABMultiValueCopyValueAtIndex(urls, j);
                NSString * urlLabel = (__bridge NSString * )ABMultiValueCopyLabelAtIndex(urls, j);
                ABUrlModel * url = [[ABUrlModel alloc] init];
                url.url = urlRef;
                url.type = urlLabel;
                [people.url addObject:url];
            }
        }
        if (eABPeopleAddress == (attributes & eABPeopleAddress)) {
            ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
            for (int i = 0 ; i < ABMultiValueGetCount(address); i ++) {
                CFDictionaryRef addressDict = ABMultiValueCopyValueAtIndex(address, i);
                ABAddressModel * addressModel = [[ABAddressModel alloc] init];
                addressModel.type = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(address, i);
                if (CFDictionaryContainsKey(addressDict, kABPersonAddressStreetKey)) {
                    NSString * street = (__bridge NSString *)CFDictionaryGetValue(addressDict, kABPersonAddressStreetKey);
                    addressModel.street = street;
                }
                if (CFDictionaryContainsKey(addressDict, kABPersonAddressCityKey)) {
                    NSString * city = (__bridge NSString *)CFDictionaryGetValue(addressDict, kABPersonAddressCityKey);
                    addressModel.city = city;
                }
                if (CFDictionaryContainsKey(addressDict, kABPersonAddressCountryKey)) {
                    NSString * country = (__bridge NSString *)CFDictionaryGetValue(addressDict, kABPersonAddressCountryKey);
                    addressModel.country = country;
                }
                if (CFDictionaryContainsKey(addressDict, kABPersonAddressStateKey)) {
                    NSString * state = (__bridge NSString *)CFDictionaryGetValue(addressDict, kABPersonAddressStateKey);
                    addressModel.state = state;
                }
                if (CFDictionaryContainsKey(addressDict, kABPersonAddressZIPKey)) {
                    NSString * zipCode = (__bridge NSString *)CFDictionaryGetValue(addressDict, kABPersonAddressZIPKey);
                    addressModel.zipCode = zipCode;
                }
                if (CFDictionaryContainsKey(addressDict, kABPersonAddressCountryCodeKey)) {
                    NSString * countryCode = (__bridge NSString *)CFDictionaryGetValue(addressDict, kABPersonAddressCountryKey);
                    addressModel.countryCode = countryCode;
                }
                [people.address addObject:addressModel];
            }
        }
        if (eABPeopleBirthday == (attributes & eABPeopleBirthday)) {
            people.birthday = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        }
        [contactsInfo addObject:people];
    }
    addressBook = nil;
    return contactsInfo;
}

////////////////////////////////////////////////////////////////
//Simple function for nil objects
NSString * NotNilString(NSString * obj)
{
    if (obj == nil) {
        obj = @"";
    }
    return obj;
}

@end
