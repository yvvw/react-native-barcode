#ifndef Result_h
#define Result_h

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic) NSNumber *raw;
@property (nonatomic) NSString *content;

+ (instancetype)initWith:(NSNumber *)raw And:(NSString *)content;

-(BOOL)isEqual:(Result *)object;

@end

#endif
