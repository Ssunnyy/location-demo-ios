//
//  SDKManager.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "SDKManager.h"

@implementation SDKManager

static SDKManager *staticManager;

+(SDKManager *)defaultManager{
    if(!staticManager){
        staticManager = [SDKManager new];
    }
    return staticManager;
}


-(NSString *)uuid{
    if(!_uuid){
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *uuidStr = [userdefault valueForKey:@"sdkuuid"];
        if(uuidStr.length == 0){
            uuidStr = [self creatUUID];
            [userdefault setValue:uuidStr forKey:@"sdkuuid"];
            [userdefault synchronize];
        }
        _uuid = uuidStr;
    }
    return _uuid;
}

-(NSString *)creatUUID{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString *idStr = (__bridge NSString *)string;
    return idStr;
}


-(BOOL)PrivacyOK{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //定位功能可用
        return YES;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        return NO;
    }
    return YES;
}

-(void)clear{
    
    self.tracingstarted = NO;
    self.tracingPathStarted = NO;
    self.circleQueryTracingStarted = NO;
    [self.locationService removeAllObservers];
    [self.locationService stopTracingPositionForKey:[self uuid]];
    [self.locationService stopRecordingPathForKey:[self uuid]];
    
}
@end
