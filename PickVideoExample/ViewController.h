//
//  ViewController.h
//  PickVideoExample
//
//  Created by PASHA on 12/10/18.
//  Copyright © 2018 Pasha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (IBAction)pickVideoTap:(id)sender;

@property NSURL * videoURL;
@end

