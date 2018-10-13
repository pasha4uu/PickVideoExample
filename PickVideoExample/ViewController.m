//
//  ViewController.m
//  PickVideoExample
//
//  Created by PASHA on 12/10/18.
//  Copyright © 2018 Pasha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)pickVideoTap:(id)sender {
  
  
    NSLog(@"got a movie");
  NSURL * pathA = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"abc" ofType:@"mp4"]];
 // NSURL *url = [[NSURL alloc] initWithString:@"https://s3-eu-west-1.amazonaws.com/alf-proeysen/Bakvendtland-MASTER.mp4"];
  // NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
  // NSData *webData = [NSData dataWithContentsOfFile:path;
  // NSLog(@"%@",webData);
  //   [self post:webData];
  // create a player view controller
//  AVPlayer * player = [AVPlayer playerWithURL:pathA];
//  AVPlayerViewController * controller = [[AVPlayerViewController alloc] init];
//
//  [self addChildViewController:controller];
//  [self.view addSubview:controller.view];
//
//  controller.view.frame = CGRectMake(20,50,320,300);
//  controller.player = player;
//  controller.showsPlaybackControls = YES;
// // [player pause];
//  [player play];
  
  
  // Present videos from which to choose
  UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
  videoPicker.delegate = self; // ensure you set the delegate so when a video is chosen the right method can be called

  videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
  // This code ensures only videos are shown to the end user
  videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];

  videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
  [self presentViewController:videoPicker animated:YES completion:nil];
//
//  UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
//  videoPicker.delegate = self;
//  videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
// // videoPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];‌
//  videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
//  videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
//  [self presentViewController:videoPicker animated:YES completion:nil];

}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//
//  // This is the NSURL of the video object
//  self.videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//
//  NSLog(@"VideoURL = %@", self.videoURL);
//  [self uploadVideo];
//  [picker dismissViewControllerAnimated:YES completion:NULL];
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:NULL];
}


//for posting video you need to use this function after image picker delegate

- (NSData *)generatePostDataForData:(NSData *)uploadData
{
  // Generate the post header:
  NSString *post = [NSString stringWithCString:"--AaB03x\r\nContent-Disposition: form-data; name=\"upload[file]\"; filename=\"somefile\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" encoding:NSASCIIStringEncoding];
  
  // Get the post header int ASCII format:
  NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  
  // Generate the mutable data variable:
  NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
  [postData setData:postHeaderData];
  
   // add image
  [postData appendData: uploadData];
  
  // Add the closing boundry:
  [postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
  
  // Return the post data:
  return postData;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

   [self dismissViewControllerAnimated:YES completion:nil];
    NSData *webData = [NSData dataWithContentsOfURL:[info objectForKey:UIImagePickerControllerMediaURL]];
   [self post:webData];
    AVPlayer * player = [AVPlayer playerWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    AVPlayerViewController * controller = [[AVPlayerViewController alloc] init];
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
  
    controller.view.frame = CGRectMake(20,50,320,300);
    controller.player = player;
    controller.showsPlaybackControls = YES;
    // [player pause];
    [player play];

    
 
}
 // for post video use this function
  
  - (void)post:(NSData *)fileData
  {
    
    NSLog(@"POSTING");
    
    // Generate the postdata:
    NSData *postData = [self generatePostDataForData: fileData];
    NSString *postLength = [NSString stringWithFormat:@"%ld", [postData length]];
    
    // Setup the request:
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://192.168.1.3:2300/admin/for-pasha-files"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Execute the reqest:
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] ;
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
      NSLog(@"my data is :  %@ ",dic);
    }];
    [task resume];

  }

@end
