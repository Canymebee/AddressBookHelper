//
//  ViewController.m
//  AddressBookHelper
//
//  Created by Rain on 14/11/3.
//  Copyright (c) 2014年 Canymebee. All rights reserved.
//

#import "ViewController.h"
#import "ABReaderHelper.h"
#import "ABPeopleModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([ABReaderHelper requireAccess]) {
        NSArray * arr = [ABReaderHelper getAddressBookWithAttributes:0b111111];
        for (ABPeopleModel * people in arr) {
            NSLog(@"name : %@ %@ %@", people.name[@"firstName"], people.name[@"middleName"], people.name[@"lastName"]);
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
