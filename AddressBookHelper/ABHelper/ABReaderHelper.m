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
        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        if (eABPeopleName == (attributes & eABPeopleName)) {
            if (ABRecordCopyValue(person, kABPersonLastNameProperty) || ABRecordCopyValue(person, kABPersonMiddleNameProperty) || ABRecordCopyValue(person, kABPersonFirstNameProperty)) {
                [people.name setObject:NotNilString((__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty)) forKey:@"lastName"];
                [people.name setObject:NotNilString((__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty)) forKey:@"middleName"];
                [people.name setObject:NotNilString((__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) )forKey:@"firstName"];
            }
        }
        if (eABPeoplePhones == (attributes & eABPeoplePhones)) {
            for(CFIndex j = 0; j < ABMultiValueGetCount(multiPhones); j ++) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, j);
                NSString * phoneNumber = NotNilString((__bridge NSString *) phoneNumberRef);
                [people.phones addObject:phoneNumber];
            }
        }
        if (eABPeopleEmails == (attributes & eABPeopleEmails)) {
            for(CFIndex j = 0; j < ABMultiValueGetCount(multiEmails); j ++) {
                CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multiEmails, j);
                NSString * email = NotNilString((__bridge NSString *) emailRef);
                [people.emails addObject:email];
            }
        }
        if (eABPeopleCompany == (attributes & eABPeopleCompany)) {
            NSString * company = (__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
            people.company = company;
        }
        if (eABPeopleAvatar == (attributes & eABPeopleAvatar)) {
            NSData * imagedata = (__bridge NSData *)ABPersonCopyImageData(person);
            UIImage * avatar = [UIImage imageWithData:imagedata];
            people.avatar = avatar;
        }
        [contactsInfo addObject:people];
    }
    
    return contactsInfo;
}

+ (NSArray *)getAllPhoneNumbers
{
    NSArray * allUsers = [self getAddressBookWithAttributes:eABPeoplePhones];
    NSMutableArray * allPhones = [[NSMutableArray alloc] initWithCapacity:allUsers.count];
    for (NSDictionary * user in allUsers) {
        for (NSString * phone in user[@"Phones"]) {
            [allPhones addObject:phone];
        }
    }
    return allPhones;
}

+ (NSArray *)getAllEmails
{
    NSArray * allUsers = [self getAddressBookWithAttributes:eABPeopleEmails];
    NSMutableArray * allEmails = [[NSMutableArray alloc] initWithCapacity:allUsers.count];
    for (NSDictionary * user in allUsers) {
        for (NSString * email in user[@"Emails"]) {
            [allEmails addObject:email];
        }
    }
    return allEmails;
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
