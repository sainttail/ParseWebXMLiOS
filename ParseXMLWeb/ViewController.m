//
//  ViewController.m
//  ParseXMLWeb
//
//  Created by Eakawat Tantamjarik on 9/25/2557 BE.
//  Copyright (c) 2557 Codium. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DTHTMLParser.h"

@interface ViewController () <DTHTMLParserDelegate>

@end

@implementation ViewController {
    NSString *currentElement;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request Server

- (void)loadWebServer
{
    AFHTTPRequestOperationManager *request = [AFHTTPRequestOperationManager manager];
    request.responseSerializer = [AFHTTPResponseSerializer serializer];
    [request GET:@"http://www.google.com" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DTHTMLParser *parser = [[DTHTMLParser alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        parser.delegate = self;
        [parser parse];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure : %@", error);
    }];
}

#pragma mark - DTHTMLParser Delegate

- (void)parserDidStartDocument:(DTHTMLParser *)parser
{
    NSLog(@"Start Document");
}

- (void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
    if ([elementName isEqualToString:@"title"]) {
        NSLog(@"start element : %@, attrs : %@", elementName, attributeDict);
    }
}

- (void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName
{
    if ([elementName isEqualToString:@"title"]) {
        NSLog(@"end element : %@", elementName);
    }
}

- (void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"title"]) {
        NSLog(@"found chars : %@", string);
    }
}

- (void)parserDidEndDocument:(DTHTMLParser *)parser
{
    NSLog(@"End Document");
}

#pragma mark - Action

- (IBAction)buttonClicked
{
    [self loadWebServer];
}

@end
