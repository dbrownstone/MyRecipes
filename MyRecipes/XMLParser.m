//
//  XMLParser.m
//  
//
//  Created by David on 6/30/15.
//
//

#import "XMLParser.h"

@implementation XMLParser {
    NSXMLParser *parser;
    NSMutableString *element;
    NSMutableDictionary *recipeInfo;
}

-(id) initWithURL:(NSString *)url {
    if(self == [super init]) {
        parser = [[NSXMLParser alloc]
                  initWithContentsOfURL:[NSURL URLWithString:url]];
        [parser setDelegate:self];
        [parser parse];
    }
    return self;
}


- (void)parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName
                                       namespaceURI:(NSString*)namespaceURI
                                      qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    if (!self.recipeList) {
        self.recipeList = [[NSMutableArray alloc] init];
    }
    NSLog(@"Started Element %@", elementName);
    element = [NSMutableString string];
    if ([elementName isEqualToString:@"RecipeID"]) {
        if (recipeInfo) {
            [self.recipeList addObject:recipeInfo];
        }
        recipeInfo = [[NSMutableDictionary alloc]init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                      namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName {
    
    NSLog(@"Found an element named: %@ with a value of: %@", elementName, element);
    [recipeInfo setValue:element forKey:elementName];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(element == nil) {
        element = [[NSMutableString alloc] init];
    }
    [element appendString:string];
}

@end
