//
//  ERecureDetailViewController.m
//  eHealth
//
//  Created by god on 13-4-16.
//  Copyright (c) 2013年 god. All rights reserved.
//

#import "ERecureDetailViewController.h"
#import <sqlite3.h>
#define databaseName @"ehealth.db"

@interface ERecureDetailViewController ()<UINavigationBarDelegate>
{
    UIButton *barItem;
}
@end

@implementation ERecureDetailViewController

@synthesize imageView, textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(Go)];
    
    /*
    UINavigationBar *bb =  [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.NVBar = bb;

    [self.view addSubview:bb];
     */

    
    CGFloat width = self.view.bounds.size.width;
    NSLog(self.eid);
    
    UITextView* TV = [[UITextView alloc]initWithFrame:CGRectMake(30, 30, width - 60, 80)];
    sqlite3* database;
    if( sqlite3_open([[self dataFilePath:databaseName] UTF8String], &database) != SQLITE_OK ){
        sqlite3_close(database);
        NSAssert(0, @"failed to open database");
    }
    NSString* query = [NSString stringWithFormat:@"%@%@",@"SELECT exerciseDescription FROM exercise WHERE eid = ",self.eid ];
    sqlite3_stmt* statement;
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK ){
        sqlite3_step(statement);
        char *s = (char *)sqlite3_column_text(statement, 0);
        TV.text = [NSString stringWithUTF8String:s];
        
        sqlite3_finalize(statement);
    }
    TV.font = [UIFont boldSystemFontOfSize:20];
    self.textView = TV;
    TV.editable = NO;
    [self.view addSubview:self.textView];
    sqlite3_close(database);
    
    NSString* pictureName = [NSString stringWithFormat:@"%@%@",@"ex",self.eid];
    NSString* pictruePath = [[NSBundle mainBundle]pathForResource:pictureName ofType:@"jpg"];
    if( pictruePath ){
        UIImage* i = [UIImage imageWithContentsOfFile:pictruePath];
        UIImageView* iView = [[UIImageView alloc]initWithImage:i];
        CGFloat pWidth = i.size.width * 0.7;
        [iView setFrame:CGRectMake((width - pWidth)/2, 30 + 80, i.size.width*0.7, i.size.height*0.7)];
        self.imageView = iView;
        [self.view addSubview:self.imageView];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)dataFilePath:(NSString *)fileName
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:fileName];
}

- (void)Go
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
