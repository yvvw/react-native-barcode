#import "Result.h"

@implementation Result

+ (instancetype)initWith:(NSNumber *)raw And:(NSString *)content
{
    Result *result = [[Result alloc] init];
    result.raw = raw;
    result.content = content;
    return result;
}

- (BOOL)isEqual:(Result *)object
{
    return [_raw isEqualToNumber:[object raw]] && [_content isEqualToString:[object content]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Result{ raw=%@, content=%@ }", _raw, _content];
}

@end
