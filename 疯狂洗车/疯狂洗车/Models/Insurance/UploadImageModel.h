//
//  UploadImageModel.h
//  
//
//  Created by cts on 15/9/24.
//
//

#import "JsonBaseModel.h"

@interface UploadImageModel : JsonBaseModel

@property (strong, nonatomic) NSString *img_type;

@property (strong, nonatomic) NSString *img_url;

@property (strong, nonatomic) NSString *img_id;

@end
