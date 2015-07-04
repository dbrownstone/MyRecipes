//
//  XMLParser.h
//  
//
//  Created by David on 6/30/15.
//
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>

@property (strong,nonatomic) NSMutableArray *recipeList;
@property (strong,nonatomic) NSMutableDictionary *recipeInfo;

-(id) initWithURL:(NSURL *)url;

@end
