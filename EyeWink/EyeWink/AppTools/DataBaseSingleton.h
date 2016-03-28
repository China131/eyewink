//
//  DataBaseSingleton.h
//  EyeWink
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Radio.h"
#import "Shop.h"
#import "Read.h"
#import "Cartoon.h"
#import "Carousel.h"
#import "Video.h"

@interface DataBaseSingleton : NSObject


+(instancetype)shareDataBaseSingleton;

-(void)openDB;

//  carousel  tabel

-(void)creatCarouselTable;

-(void)deleteCarouselWithKind:(NSString *)kind;

-(void)insertCarouselTable:(Carousel *)carousel AndKind:(NSString *)kind;

-(NSMutableArray *)selectCarouselWithKind:(NSString *)kind;

//  radio table

-(void)creatRadioTable;

-(void)dropRadioTable;

-(void)insertRadioTable:(Radio *)radio AndKind:(NSString *)kind;

-(NSMutableArray *)selectRadioWithString:(NSString *)string;


//  carouselRadio table
/*
-(void)creatcarouselRadioTable;

-(void)insertcarouselRadioTable:(Radio *)radio;

-(void)dropcarouselRadioTable;

-(NSMutableArray *)selectAllCarouselRadio;
*/

//  radioDetail  table

-(void)creatRadioDetailTable;

-(void)insertRadioDetailTable:(Radio *)radio AndKind:(NSString *)kind AndRadioid:(NSString *)radioid;

-(void)deleteRadioDetailWithRadioid:(NSString *)radioid;

-(NSMutableArray *)selectRadioDetailWithString:(NSString *)string AndRadioid:(NSString *)radioid;


//  shop  table

-(void)creatShopTable;

-(void)insertShopTable:(Shop *)shop;

-(void)dropShopTable;

-(NSMutableArray *)selectAllShop;


//  read  table

-(void)creatReadTable;

-(void)insertReadTable:(Read *)read;

-(void)dropReadTable;

-(NSMutableArray *)selectAllRead;


//  readDetail  table

-(void)creatReadDetailTable;

-(void)insertReadDetailTable:(Read *)read AndTypeID:(NSInteger)typeID;

-(void)deleteReadDetailWithTypeID:(NSInteger)typeID;

-(void)dropRadioDetailTable;

-(NSMutableArray *)selectReadDetailWithTypeID:(NSInteger)typeID;

//  comic  table

-(void)creatComicTable;

-(void)insertComicTable:(Cartoon *)cartoon;

-(void)dropComicTable;

-(NSMutableArray *)selectIsLikeComic;

-(NSMutableArray *)selectAllComic;

- (void) updateTable:(Cartoon *)cartoon;

//  isLikeComic table

-(void)creatisLikeComicTable;

-(void)insertisLikeComicTable:(Cartoon *)cartoon;

-(void)dropisLikeComicTable;

-(NSMutableArray *)selectAllisLikeComic;

-(void)deleteisLikeComicWithTitle:(NSString *)title;


//  video   table

-(void)creatVideoTable;

-(void)insertVideoTable:(Video *)video;

-(void)dropVideoTable;

-(NSMutableArray *)selectAllVideo;

@end














