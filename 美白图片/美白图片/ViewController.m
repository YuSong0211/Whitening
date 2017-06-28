//
//  ViewController.m
//  美白图片
//
//  Created by  椒徒科技 on 2017/6/27.
//  Copyright © 2017年 jiaotukeji. All rights reserved.
//

#import "ViewController.h"
#import "ImageUtils.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickWhitening:(id)sender {
    
    self.imageView.image = [ImageUtils imageProcess:self.imageView.image];
    
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/flower.png"];
    [UIImagePNGRepresentation(self.imageView.image) writeToFile:imagePath atomically:NO];
    
    NSLog(@"%@",imagePath);
}

@end
