//
//  Article.m
//  JasonParsing
//
//  Created by Kenan Uzel on 4/8/15.
//  Copyright (c) 2015 Kenan Uzel. All rights reserved.
//

#import "Article.h"

@implementation Article

//maps JSON to properties
+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             
             @"title" : @"title",
             @"excerpt" : @"excerpt",
             @"body" : @"content",
             @"url" : @"url",
             @"date" : @"date",
             @"author" : @"author",
             @"attachments" : @"attachments",
             @"categories" : @"categories"
             };
}
//formats the date
+ (NSDateFormatter *) dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

//transforms the URL
+ (NSValueTransformer *) urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

//transforms the date
+ (NSValueTransformer *) dateJSONTransformer {
    
    
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *str, BOOL *success, NSError **error) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date, BOOL *success, NSError **error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

//transform attachments with a Attachments object
+(NSValueTransformer *) attachmentsTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:Attachments.class];
}

//transform attachments with a ArticleCategory object
+(NSValueTransformer *) categoriesTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ArticleCategory.class];
}

+(NSDictionary *) deserializeArticleInfoFromJSON:(NSDictionary *)articleJSON {
    
    NSError *error;
    NSDictionary *articleInfo = [MTLJSONAdapter modelOfClass:[Article class] fromJSONDictionary:articleJSON error:&error];
    if (error) {
        NSLog(@"Couldn't convert article JSON to Article Models: %@", error);
        return nil;
    }
    return articleInfo;
}

+(NSData *) serializeArticleInforIntoNSData:(NSArray *)articleInfo {
    
    NSError *error;
    NSArray *articleJSON = [MTLJSONAdapter JSONArrayFromModels:articleInfo error:&error];
    if (error) {
        NSLog(@"Couldn't create article JSON Array: %@", error);
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:articleJSON options:0 error:&error];
    if (error) {
        NSLog(@"Couldn't convert article JSON into NSData: %@", error);
        return nil;
    }
    
    return jsonData;
    
}


-(instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    
    self= [super initWithDictionary:dictionaryValue error:error];
    
    if (self == nil) {
        return nil;
    }
    
    return self;
}



@end
