/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBPasteboard.h"

#import "FBErrorBuilder.h"

@implementation FBPasteboard

+ (BOOL)setData:(NSData *)data forType:(NSString *)type error:(NSError **)error
{
  UIPasteboard *pb = UIPasteboard.generalPasteboard;
  if ([type.lowercaseString isEqualToString:@"plaintext"]) {
    pb.string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  } else if ([type.lowercaseString isEqualToString:@"image"]) {
    pb.image = [UIImage imageWithData:data];
  } else if ([type.lowercaseString isEqualToString:@"url"]) {
    NSString *urlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    pb.URL = [[NSURL alloc] initWithString:urlString];
  } else {
    NSString *description = [NSString stringWithFormat:@"Unsupported content type: %@", type];
    if (error) {
      *error = [[FBErrorBuilder.builder withDescription:description] build];
    }
    return NO;
  }
  return YES;
}

+ (NSData *)dataForType:(NSString *)type error:(NSError **)error
{
  UIPasteboard *pb = UIPasteboard.generalPasteboard;
  if ([type.lowercaseString isEqualToString:@"plaintext"]) {
    if (pb.hasStrings) {
      return [pb.string dataUsingEncoding:NSUTF8StringEncoding];
    }
  } else if ([type.lowercaseString isEqualToString:@"image"]) {
    if (pb.hasImages) {
      return UIImagePNGRepresentation((UIImage *)pb.image);
    }
  } else if ([type.lowercaseString isEqualToString:@"url"]) {
    if (pb.hasURLs) {
      return [NSData dataWithContentsOfURL:(NSURL *)pb.URL];
    }
  } else {
    NSString *description = [NSString stringWithFormat:@"Unsupported content type: %@", type];
    if (error) {
      *error = [[FBErrorBuilder.builder withDescription:description] build];
    }
    return nil;
  }
  return [@"" dataUsingEncoding:NSUTF8StringEncoding];
}

@end
