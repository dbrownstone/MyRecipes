#import "UIColor+Hextentions.h"

@implementation UIColor (UIColor_Hextensions)

+ (UIColor*)colorWithHexValue:(NSString*)hexValue
{
    //Default
    UIColor *defaultResult = [UIColor blackColor];
    
    //Strip prefixed # hash
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [[hexValue substringFromIndex:1] capitalizedString];
    }
    
    //Determine if 3,4,6 or 8 digits
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3 || [hexValue length] == 4)
    {
        componentLength = 1;
    }
    else if ([hexValue length] == 6 || [hexValue length] == 8)
    {
        componentLength = 2;
    }
    else
    {
        return defaultResult;
    }
    
    BOOL isValid = YES;
    CGFloat components[4];
    if ([hexValue length] == 3 || [hexValue length] == 6) {
        components[3] = 1.0f;
    }
    
    //Seperate the R,G,B values
    for (NSUInteger i = 0; i < [hexValue length]/2; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 255.0f;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:components[3]];
}

@end
