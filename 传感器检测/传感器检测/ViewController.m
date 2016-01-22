//
//  ViewController.m
//  传感器检测
//
//  Created by GFY on 16/1/21.
//  Copyright © 2016年 GFY. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *X1;
@property (weak, nonatomic) IBOutlet UISlider *Y1;
@property (weak, nonatomic) IBOutlet UISlider *Z1;
@property (weak, nonatomic) IBOutlet UIProgressView *X2;
@property (weak, nonatomic) IBOutlet UIProgressView *Y2;
@property (weak, nonatomic) IBOutlet UIProgressView *Z2;
@property (weak, nonatomic) UIView * view1;
@property (weak, nonatomic) UIView * view2;
@property (weak, nonatomic) UIView * view3;
@property (nonatomic,strong) CMMotionManager *motionManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(187, 508, 0, 12)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(187, 556, 0, 12)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(187, 606, 0, 12)];
    view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor greenColor];
    view3.backgroundColor = [UIColor blueColor];
    self.view1 = view1;
    self.view2 = view2;
    self.view3 = view3;
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
    [self.view addSubview:self.view3];
    
    self.motionManager = [[CMMotionManager alloc] init];
    if (![self.motionManager isGyroAvailable]) {
        NSLog(@"陀螺仪不可用");
    }
    if (![self.motionManager isAccelerometerAvailable]) {
        NSLog(@"加速计不可用");
    }
    if (![self.motionManager isMagnetometerAvailable]) {
        NSLog(@"磁力计不可用");
    }
    self.motionManager.gyroUpdateInterval = 1/ 20.0;
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        if (error) {
            NSLog(@"陀螺仪不可用");
        }
        self.X1.value = gyroData.rotationRate.x;
        self.Y1.value = gyroData.rotationRate.y;
        self.Z1.value = gyroData.rotationRate.z;
    }];
    
    self.motionManager.magnetometerUpdateInterval = 1/ 20.0;
    [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        if (error) {
            NSLog(@"磁力计出错");
            return ;
        }
        self.X2.progress = magnetometerData.magneticField.x / 200.0;
//        NSLog(@"%f---1",magnetometerData.magneticField.x);
        self.Y2.progress = magnetometerData.magneticField.y/ 100.0;
//        NSLog(@"%f---2",magnetometerData.magneticField.y);
        self.Z2.progress = magnetometerData.magneticField.z/ -1000.0;
//        NSLog(@"%f---3",magnetometerData.magneticField.z);
    }];
    self.motionManager.accelerometerUpdateInterval = 1 / 20.0;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"加速计出错了");
                return ;
            }
//            NSLog(@"%@",[NSThread currentThread]);
            if (accelerometerData.acceleration.x >= 0 ){
                CGRect rect1 = self.view1.frame;
                rect1.size.width = accelerometerData.acceleration.x *100;
//                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view1.frame = rect1;
//                });
            }else{
                CGRect rect1 = self.view1.frame;
                rect1.size.width = -accelerometerData.acceleration.x *100;
                rect1.origin.x = 187 - rect1.size.width;
//                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view1.frame = rect1;
//                });
            }
            
            if (accelerometerData.acceleration.y >= 0 ){
                CGRect rect1 = self.view2.frame;
                rect1.size.width = accelerometerData.acceleration.y *100;
//                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view2.frame = rect1;
//                });
            }else{
                CGRect rect1 = self.view2.frame;
                rect1.size.width = -accelerometerData.acceleration.y *100;
                rect1.origin.x = 187 - rect1.size.width;
//                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view2.frame = rect1;
//                });
            }
            if (accelerometerData.acceleration.z >= 0 ){
                CGRect rect1 = self.view3.frame;
                rect1.size.width = accelerometerData.acceleration.z *100;
//                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view3.frame = rect1;
//                });
            }else{
                CGRect rect1 = self.view3.frame;
                rect1.size.width = -accelerometerData.acceleration.z *100;
//                NSLog(@"%f",rect1.size.width);
                rect1.origin.x = 187 - rect1.size.width;
//                NSLog(@"%f",rect1.origin.x);
//                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view3.frame = rect1;
//                });
            }
            //        NSLog(@" x :  %f   y : %f   z  :  %f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
            //        self.X2.progress = self.motionManager.accelerometerData.acceleration.x;
            //        self.Y2.progress = self.motionManager.accelerometerData.acceleration.y;
            //        self.Z2.progress = self.motionManager.accelerometerData.acceleration.z;
        }];    

//    });
}
@end
