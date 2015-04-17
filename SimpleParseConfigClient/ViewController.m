//
//  ViewController.m
//  SimpleParseConfigClient
//
//  Created by Le Huy on 4/16/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ViewController.h"
#import "SimpleParseConfigClient.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textViewData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textViewData.text = self.textViewData.text = [NSString stringWithFormat:@"%@", [SimpleParseConfigClient sharedInstance].appConfig];
    
    [SimpleParseConfigClient setAppId:@"Put your app id here"];
    [SimpleParseConfigClient setAPIKey:@"Put your rest api key here"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnRequestConfigSelected:(id)sender {
    self.textViewData.text = @"Loading...";
    [[SimpleParseConfigClient sharedInstance] requestConfigOnCompleted:^(NSDictionary *app) {
        self.textViewData.text = [NSString stringWithFormat:@"%@", app];
    }];
}

@end
