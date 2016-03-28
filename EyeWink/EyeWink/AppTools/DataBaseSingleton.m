//
//  DataBaseSingleton.m
//  EyeWink
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "DataBaseSingleton.h"

@implementation DataBaseSingleton

static sqlite3 *db = nil;
+(instancetype)shareDataBaseSingleton{
    static DataBaseSingleton *dataBaseSinglton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBaseSinglton = [[DataBaseSingleton alloc] init];
    });
    return dataBaseSinglton;
}

-(void)openDB{
    if(db != nil){
        NSLog(@"数据库已经打开");
        return;
    }
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    NSString *sqlPath = [path stringByAppendingPathComponent:@"EyeWink.sqlite"];
    NSLog(@"-----%@",sqlPath);
    
    int result = sqlite3_open(sqlPath.UTF8String, &db);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"打开数据库失败");
    }

}

#pragma mark-  carousel  table
//  carousel  table

-(void)creatCarouselTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS carousel(ID INTEGER PRIMARY KEY AUTOINCREMENT,img TEXT,url TEXT,kind TEXT)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建carousel表失败");
    }

}

-(void)deleteCarouselWithKind:(NSString *)kind{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM carousel WHERE kind = '%@'",kind];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }
}

-(void)insertCarouselTable:(Carousel *)carousel AndKind:(NSString *)kind{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO carousel(img,url,kind) VALUES('%@','%@','%@')",carousel.img,carousel.url,kind];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }
}

-(NSMutableArray *)selectCarouselWithKind:(NSString *)kind{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM carousel WHERE kind = '%@'",kind];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            
            const unsigned char *img = sqlite3_column_text(stmt, 1);
            const unsigned char *url = sqlite3_column_text(stmt, 2);
            
            NSInteger numberInteger = number;
            NSString *imgStr = [NSString stringWithUTF8String:(const char *)img];
            NSString *urlStr = [NSString stringWithUTF8String:(const char *)url];
            
            Carousel *carousel = [[Carousel alloc] init];
            carousel.img = imgStr;
            carousel.url = urlStr;
            
            [array addObject:carousel];
            [carousel release];
        }
    }
    else{
        NSLog(@"查询carousel表准备失败");
    }
    
    return array;

}

#pragma mark-  radio table
//  radio table
-(void)creatRadioTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS radio(ID INTEGER PRIMARY KEY AUTOINCREMENT, radioid TEXT,title TEXT,coverimg TEXT,uname TEXT,count INTEGER,desc TEXT,isnew INT,kind TEXT)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建radio表失败");
    }

}

-(void)dropRadioTable{
    NSString *sql = @"DROP TABLE radio";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"删除radio表失败");
    }

}

-(void)insertRadioTable:(Radio *)radio AndKind:(NSString *)kind{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO radio(radioid,title,coverimg,uname,count,desc,isnew,kind) VALUES('%@','%@','%@','%@','%ld','%@','%d','%@')",radio.radioid,radio.title,radio.coverimg,radio.uname,radio.count,radio.desc,radio.isnew,kind];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }
}

-(NSMutableArray *)selectRadioWithString:(NSString *)string{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM radio WHERE kind = '%@'",string];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            
            const unsigned char *radioid = sqlite3_column_text(stmt, 1);
            const unsigned char *title = sqlite3_column_text(stmt, 2);
            const unsigned char *coverimg = sqlite3_column_text(stmt, 3);
            const unsigned char *uname = sqlite3_column_text(stmt, 4);
            int count = sqlite3_column_int(stmt, 5);
            const unsigned char *desc = sqlite3_column_text(stmt, 6);
            int isnew = sqlite3_column_int(stmt, 7);
            
            NSInteger numberInteger = number;
            NSString *radioidStr = [NSString stringWithUTF8String:(const char *)radioid];
            NSString *titleStr = [NSString stringWithUTF8String:(const char *)title];
            NSString *coverimgStr = [NSString stringWithUTF8String:(const char *)coverimg];
            NSString *unameStr = [NSString stringWithUTF8String:(const char *)uname];
            NSInteger countInteger = count;
            NSString *descStr = [NSString stringWithUTF8String:(const char *)desc];
            NSInteger isnewInteger = isnew;
            
            Radio *radio = [[Radio alloc] init];
            radio.radioid = radioidStr;
            radio.title = titleStr;
            radio.coverimg = coverimgStr;
            radio.uname = unameStr;
            radio.count = countInteger;
            radio.desc = descStr;
            radio.isnew = isnewInteger;
            [array addObject:radio];
            [radio release];
        }
    }
    else{
        NSLog(@"查询consult表准备失败");
    }
    
    return array;



}


//  carouselRadio table
/*
-(void)creatcarouselRadioTable;

-(void)insertcarouselRadioTable:(Radio *)radio;

-(void)dropcarouselRadioTable;

-(NSMutableArray *)selectAllCarouselRadio;
*/

#pragma mark-  radioDetail table
//  radioDetail  table
-(void)creatRadioDetailTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS radioDetail(ID INTEGER PRIMARY KEY AUTOINCREMENT, coverimg TEXT,icon TEXT,uname TEXT,title TEXT,musicvisitnum INTEGER,musicVisit TEXT,musicUrl TEXT,tingid TEXT,sharetext TEXT,shareurl TEXT,kind TEXT,radioid TEXT,isnew INT,desc TEXT)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建radioDetail表失败");
    }

}

-(void)insertRadioDetailTable:(Radio *)radio AndKind:(NSString *)kind AndRadioid:(NSString *)radioid{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO radioDetail(coverimg,icon,uname,title,musicvisitnum,musicVisit,musicUrl,tingid,sharetext,shareurl,kind,radioid,isnew,desc) VALUES('%@','%@','%@','%@','%ld','%@','%@','%@','%@','%@','%@','%@','%d','%@')",radio.coverimg,radio.icon,radio.uname,radio.title,radio.musicvisitnum,radio.musicVisit,radio.musicUrl,radio.tingid,radio.sharetext,radio.shareurl,kind,radioid,radio.isnew,radio.desc];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }

}

//-(void)dropRadioDetailTable{
//    NSString *sql = @"DROP TABLE radioDetail";
//    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
//    if(result == SQLITE_OK){
//        NSLog(@"删除radioDetail表成功");
//    }
//    else{
//        NSLog(@"删除radioDetail表失败");
//    }
//
//}

-(void)deleteRadioDetailWithRadioid:(NSString *)radioid{

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM radioDetail WHERE radioid = '%@'",radioid];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }


}

-(NSMutableArray *)selectRadioDetailWithString:(NSString *)string AndRadioid:(NSString *)radioid{

    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM radioDetail WHERE kind = '%@' AND radioid = '%@'",string,radioid];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            
            const unsigned char *coverimg = sqlite3_column_text(stmt, 1);
            const unsigned char *icon = sqlite3_column_text(stmt, 2);
            const unsigned char *uname = sqlite3_column_text(stmt, 3);
            const unsigned char *title = sqlite3_column_text(stmt, 4);
            int musiccisitnum = sqlite3_column_int(stmt, 5);
            const unsigned char *musicVisit = sqlite3_column_text(stmt, 6);
            const unsigned char *musicUrl = sqlite3_column_text(stmt, 7);
            const unsigned char *tingid = sqlite3_column_text(stmt, 8);
            const unsigned char *sharetext = sqlite3_column_text(stmt, 9);
            const unsigned char *shareurl = sqlite3_column_text(stmt, 10);
            int isnew = sqlite3_column_int(stmt, 13);
            const unsigned char *desc = sqlite3_column_text(stmt, 14);
            
            NSInteger numberInteger = number;
            NSString *coverimgStr = [NSString stringWithUTF8String:(const char *)coverimg];
            NSString *iconStr = [NSString stringWithUTF8String:(const char *)icon];
            NSString *unameStr = [NSString stringWithUTF8String:(const char *)uname];
            NSString *titleStr = [NSString stringWithUTF8String:(const char *)title];
            NSInteger musiccisitnumInteger = musiccisitnum;
            NSString *musicVisitStr = [NSString stringWithUTF8String:(const char *)musicVisit];
            NSString *musicUrlStr = [NSString stringWithUTF8String:(const char *)musicUrl];
            NSString *tingidStr = [NSString stringWithUTF8String:(const char *)tingid];
            NSString *sharetextStr = [NSString stringWithUTF8String:(const char *)sharetext];
            NSString *shareurlStr = [NSString stringWithUTF8String:(const char *)shareurl];
            NSInteger isnewInteger = isnew;
            NSString *descStr = [NSString stringWithUTF8String:(const char *)desc];
            
            Radio *radio = [[Radio alloc] init];
            radio.coverimg = coverimgStr;
            radio.icon = iconStr;
            radio.uname = unameStr;
            radio.title = titleStr;
            radio.musicvisitnum = musiccisitnumInteger;
            radio.musicVisit = musicVisitStr;
            radio.musicUrl = musicUrlStr;
            radio.tingid = tingidStr;
            radio.sharetext = sharetextStr;
            radio.shareurl = shareurlStr;
            radio.isnew = isnewInteger;
            radio.desc = descStr;
            
            [array addObject:radio];
            [radio release];
        }
    }
    else{
        NSLog(@"查询radioDetail表准备失败");
    }
    
    return array;

}

#pragma mark-  shop table
//  shop  table

-(void)creatShopTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS shop(ID INTEGER PRIMARY KEY AUTOINCREMENT,contentid TEXT,title TEXT,coverimg TEXT,buyurl TEXT)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建shop表失败");
    }
}

-(void)insertShopTable:(Shop *)shop{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO shop(contentid,title,coverimg,buyurl) VALUES('%@','%@','%@','%@')",shop.contentid,shop.title,shop.coverimg,shop.buyurl];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }

}

-(void)dropShopTable{
    NSString *sql = @"DROP TABLE shop";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"删除shop表失败");
    }

}

-(NSMutableArray *)selectAllShop{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = @"SELECT * FROM shop";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        //        NSLog(@"查询consult表准备成功");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            
            const unsigned char *contentid = sqlite3_column_text(stmt, 1);
            const unsigned char *title = sqlite3_column_text(stmt, 2);
            const unsigned char *coverimg = sqlite3_column_text(stmt, 3);
            const unsigned char *buyurl = sqlite3_column_text(stmt, 4);
            
            NSInteger numberInteger = number;
            NSString *contentidStr = [NSString stringWithUTF8String:(const char *)contentid];
            NSString *titleStr = [NSString stringWithUTF8String:(const char *)title];
            NSString *coverimgStr = [NSString stringWithUTF8String:(const char *)coverimg];
            NSString *buyurlStr = [NSString stringWithUTF8String:(const char *)buyurl];
            
            Shop *shop = [[Shop alloc] init];
            shop.contentid = contentidStr;
            shop.title = titleStr;
            shop.coverimg = coverimgStr;
            shop.buyurl = buyurlStr;
            
            [array addObject:shop];
            [shop release];
        }
    }
    else{
        NSLog(@"查询shop表准备失败");
    }
    
    return array;


}

#pragma mark-  read table
//  read  table

-(void)creatReadTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS read(ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,enname TEXT,coverimg TEXT,type INTEGER)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建read表失败");
    }
}

-(void)insertReadTable:(Read *)read{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO read(name,enname,coverimg,type) VALUES('%@','%@','%@','%ld')",read.name,read.enname,read.coverimg,read.type];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }
}

-(void)dropReadTable{
    NSString *sql = @"DROP TABLE read";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"删除read表失败");
    }
}

-(NSMutableArray *)selectAllRead{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = @"SELECT * FROM read";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        //        NSLog(@"查询consult表准备成功");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            const unsigned char *enname = sqlite3_column_text(stmt, 2);
            const unsigned char *coverimg = sqlite3_column_text(stmt, 3);
            int type = sqlite3_column_int(stmt, 4);
            
            NSInteger numberInteger = number;
            NSString *nameStr = [NSString stringWithUTF8String:(const char *)name];
            NSString *ennameStr = [NSString stringWithUTF8String:(const char *)enname];
            NSString *coverimgStr = [NSString stringWithUTF8String:(const char *)coverimg];
            NSInteger typeInteger = type;
            
            Read *read = [[Read alloc] init];
            read.name = nameStr;
            read.enname = ennameStr;
            read.coverimg = coverimgStr;
            read.type = typeInteger;
            
            [array addObject:read];
            [read release];
        }
    }
    else{
        NSLog(@"查询read表准备失败");
    }
    
    return array;
}

#pragma mark-  readDetail  table
//  readDetail  table

-(void)creatReadDetailTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS readDetail(ID INTEGER PRIMARY KEY AUTOINCREMENT,detail_coverimg TEXT,detail_name TEXT,detail_title TEXT,detail_content TEXT,detail_id TEXT,typeID INTEGER)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建readDetail表失败");
    }

}

-(void)insertReadDetailTable:(Read *)read AndTypeID:(NSInteger)typeID{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO readDetail(detail_coverimg,detail_name,detail_title,detail_content,detail_id,typeID) VALUES('%@','%@','%@','%@','%@','%ld')",read.detail_coverimg,read.detail_name,read.detail_title,read.detail_content,read.detail_id,typeID];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"插入readDetail失败")
    }
}

-(void)deleteReadDetailWithTypeID:(NSInteger)typeID{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM readDetail WHERE typeID = '%ld'",typeID];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"删除readDetail数据失败");
    }

}

-(NSMutableArray *)selectReadDetailWithTypeID:(NSInteger)typeID{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM readDetail WHERE typeID = '%ld'",typeID];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            
            const unsigned char *detail_coverimg = sqlite3_column_text(stmt, 1);
            const unsigned char *detail_name = sqlite3_column_text(stmt, 2);
            const unsigned char *detail_title = sqlite3_column_text(stmt, 3);
            const unsigned char *detail_content = sqlite3_column_text(stmt, 4);
            const unsigned char *detail_id = sqlite3_column_text(stmt, 5);
            
            NSInteger numberInteger = number;
            NSString *detail_coverimgStr = [NSString stringWithUTF8String:(const char *)detail_coverimg];
            NSString *detail_nameStr = [NSString stringWithUTF8String:(const char *)detail_name];
            NSString *detail_titleStr = [NSString stringWithUTF8String:(const char *)detail_title];
            NSString *detail_contentStr = [NSString stringWithUTF8String:(const char *)detail_content];
            NSString *detail_idStr = [NSString stringWithUTF8String:(const char *)detail_id];
            
            Read *read = [[Read alloc] init];
            read.detail_coverimg = detail_coverimgStr;
            read.detail_name = detail_nameStr;
            read.detail_title = detail_titleStr;
            read.detail_content = detail_contentStr;
            read.detail_id = detail_idStr;
            
            [array addObject:read];
            [read release];
        }
    }
    else{
        NSLog(@"查询readDetail表准备失败");
    }
    
    return array;
}

#pragma mark-  cartoon  table
//  comic  table

-(void)creatComicTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS comic(ID INTEGER PRIMARY KEY AUTOINCREMENT,user_nickname TEXT,user_avatar_url TEXT,topic_title TEXT,title TEXT,topic_cover_image_url TEXT,topic_description TEXT,url TEXT,topic_comics_count INTEGER,shared_count INTEGER,likes_count INTEGER,comments_count INTEGER,isLike INTEGER)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建comic表失败");
    }

}

-(void)insertComicTable:(Cartoon *)cartoon{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO comic(user_nickname,user_avatar_url,topic_title,title,topic_cover_image_url,topic_description,url,topic_comics_count,shared_count,likes_count,comments_count,isLike) VALUES('%@','%@','%@','%@','%@','%@','%@','%ld','%ld','%ld','%ld','%d')",cartoon.user_nickname,cartoon.user_avatar_url,cartoon.topic_title,cartoon.title,cartoon.topic_cover_image_url,cartoon.topic_description,cartoon.url,cartoon.topic_comics_count,cartoon.shared_count,cartoon.likes_count,cartoon.comments_count,cartoon.isLike];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }
}

-(void)dropComicTable{
    NSString *sql = @"DROP TABLE comic";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"删除comic表失败");
    }
}

-(NSMutableArray *)selectIsLikeComic{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = @"SELECT * FROM comic WHERE isLike = 1";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            const unsigned char *user_nickname = sqlite3_column_text(stmt, 1);
            const unsigned char *user_avatar_url = sqlite3_column_text(stmt, 2);
            const unsigned char *topic_title = sqlite3_column_text(stmt, 3);
            const unsigned char *title = sqlite3_column_text(stmt, 4);
            const unsigned char *topic_cover_image_url = sqlite3_column_text(stmt, 5);
            const unsigned char *topic_description = sqlite3_column_text(stmt, 6);
            const unsigned char *url = sqlite3_column_text(stmt, 7);
            int topic_comics_count = sqlite3_column_int(stmt, 8);
            int shared_count = sqlite3_column_int(stmt, 9);
            int likes_count = sqlite3_column_int(stmt, 10);
            int comments_count = sqlite3_column_int(stmt, 11);
            
            NSInteger numberInteger = number;
            NSString *user_nicknameStr = [NSString stringWithUTF8String:(const char *)user_nickname];
            NSString *user_avatar_urlStr = [NSString stringWithUTF8String:(const char *)user_avatar_url];
            NSString *topic_titleStr = [NSString stringWithUTF8String:(const char *)topic_title];
            NSString *titleStr = [NSString stringWithUTF8String:(const char *)title];
            NSString *topic_cover_image_urlStr = [NSString stringWithUTF8String:(const char *)topic_cover_image_url];
            NSString *topic_descriptionStr = [NSString stringWithUTF8String:(const char *)topic_description];
            NSString *urlStr = [NSString stringWithUTF8String:(const char *)url];
            NSInteger topic_comics_countInteger = topic_comics_count;
            NSInteger shared_countInteger = shared_count;
            NSInteger likes_countInteger = likes_count;
            NSInteger comments_countInteger = comments_count;
            
            Cartoon *cartoon = [[Cartoon alloc] init];
            cartoon.user_nickname = user_nicknameStr;
            cartoon.user_avatar_url = user_avatar_urlStr;
            cartoon.topic_title = topic_titleStr;
            cartoon.title = titleStr;
            cartoon.topic_cover_image_url = topic_cover_image_urlStr;
            cartoon.topic_description = topic_descriptionStr;
            cartoon.url = urlStr;
            cartoon.topic_comics_count = topic_comics_countInteger;
            cartoon.shared_count = shared_countInteger;
            cartoon.likes_count = likes_countInteger;
            cartoon.comments_count = comments_countInteger;
            cartoon.isLike = 1;
            
            [array addObject:cartoon];
            [cartoon release];
        }
    }
    else{
        NSLog(@"查询comic表准备失败");
    }
    
    return array;

}

-(NSMutableArray *)selectAllComic{

    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = @"SELECT * FROM comic";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            const unsigned char *user_nickname = sqlite3_column_text(stmt, 1);
            const unsigned char *user_avatar_url = sqlite3_column_text(stmt, 2);
            const unsigned char *topic_title = sqlite3_column_text(stmt, 3);
            const unsigned char *title = sqlite3_column_text(stmt, 4);
            const unsigned char *topic_cover_image_url = sqlite3_column_text(stmt, 5);
            const unsigned char *topic_description = sqlite3_column_text(stmt, 6);
            const unsigned char *url = sqlite3_column_text(stmt, 7);
            int topic_comics_count = sqlite3_column_int(stmt, 8);
            int shared_count = sqlite3_column_int(stmt, 9);
            int likes_count = sqlite3_column_int(stmt, 10);
            int comments_count = sqlite3_column_int(stmt, 11);
            int isLike = sqlite3_column_int(stmt, 12);
            
            NSInteger numberInteger = number;
            NSString *user_nicknameStr = [NSString stringWithUTF8String:(const char *)user_nickname];
            NSString *user_avatar_urlStr = [NSString stringWithUTF8String:(const char *)user_avatar_url];
            NSString *topic_titleStr = [NSString stringWithUTF8String:(const char *)topic_title];
            NSString *titleStr = [NSString stringWithUTF8String:(const char *)title];
            NSString *topic_cover_image_urlStr = [NSString stringWithUTF8String:(const char *)topic_cover_image_url];
            NSString *topic_descriptionStr = [NSString stringWithUTF8String:(const char *)topic_description];
            NSString *urlStr = [NSString stringWithUTF8String:(const char *)url];
            NSInteger topic_comics_countInteger = topic_comics_count;
            NSInteger shared_countInteger = shared_count;
            NSInteger likes_countInteger = likes_count;
            NSInteger comments_countInteger = comments_count;
            BOOL isLikeBOOL = isLike;
            
            Cartoon *cartoon = [[Cartoon alloc] init];
            cartoon.user_nickname = user_nicknameStr;
            cartoon.user_avatar_url = user_avatar_urlStr;
            cartoon.topic_title = topic_titleStr;
            cartoon.title = titleStr;
            cartoon.topic_cover_image_url = topic_cover_image_urlStr;
            cartoon.topic_description = topic_descriptionStr;
            cartoon.url = urlStr;
            cartoon.topic_comics_count = topic_comics_countInteger;
            cartoon.shared_count = shared_countInteger;
            cartoon.likes_count = likes_countInteger;
            cartoon.comments_count = comments_countInteger;
            cartoon.isLike = isLikeBOOL;
            
            [array addObject:cartoon];
            [cartoon release];
        }
    }
    else{
        NSLog(@"查询comic表准备失败");
    }
    
    return array;
    
}

- (void) updateTable:(Cartoon *)cartoon{
    NSString *sql = [NSString stringWithFormat:@"UPDATE comic SET isLike = '%d' WHERE  title = '%@'",cartoon.isLike,cartoon.title];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
        NSLog(@"成功修改表");
    }
    else{
        NSLog(@"修改表失败");
    }
}

#pragma mark-  video  table
//  video   table

-(void)creatVideoTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS video(ID INTEGER PRIMARY KEY AUTOINCREMENT,mp4_url TEXT,title TEXT,user_avatar_url TEXT,user_name TEXT,url TEXT)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建video表失败");
    }
}

-(void)insertVideoTable:(Video *)video{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO video(mp4_url,title,user_avatar_url,user_name,url) VALUES('%@','%@','%@','%@','%@')",video.mp4_url,video.title,video.user_avatar_url,video.user_name,video.url];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }

}

-(void)dropVideoTable{
    NSString *sql = @"DROP TABLE video";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"删除video表失败");
    }

}

-(NSMutableArray *)selectAllVideo{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = @"SELECT * FROM video";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            const unsigned char *mp4_url = sqlite3_column_text(stmt, 1);
            const unsigned char *title = sqlite3_column_text(stmt, 2);
            const unsigned char *user_avatar_url = sqlite3_column_text(stmt, 3);
            const unsigned char *user_name = sqlite3_column_text(stmt, 4);
            const unsigned char *url = sqlite3_column_text(stmt, 5);

            
            NSInteger numberInteger = number;
            NSString *mp4_urlStr = [NSString stringWithUTF8String:(const char *)mp4_url];
            NSString *titleStr = [NSString stringWithUTF8String:(const char *)title];
            NSString *user_avatar_urlStr = [NSString stringWithUTF8String:(const char *)user_avatar_url];
            NSString *user_nameStr = [NSString stringWithUTF8String:(const char *)user_name];
            NSString *urlStr = [NSString stringWithUTF8String:(const char *)url];
            
            Video *video = [[Video alloc] init];
            video.mp4_url = mp4_urlStr;
            video.title = titleStr;
            video.user_avatar_url = user_avatar_urlStr;
            video.user_name = user_nameStr;
            video.url = urlStr;
            
            [array addObject:video];
            [video release];
        }
    }
    else{
        NSLog(@"查询video表准备失败");
    }
    
    return array;

}

#pragma mark-  isLikeComic table
//  isLikeComic table

-(void)creatisLikeComicTable{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS isLikeComic(ID INTEGER PRIMARY KEY AUTOINCREMENT,user_nickname TEXT,user_avatar_url TEXT,topic_title TEXT,title TEXT,topic_cover_image_url TEXT,topic_description TEXT,url TEXT,topic_comics_count INTEGER,shared_count INTEGER,likes_count INTEGER,comments_count INTEGER,isLike INTEGER)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"创建isLikeComic表失败");
    }

}

-(void)insertisLikeComicTable:(Cartoon *)cartoon{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO isLikeComic(user_nickname,user_avatar_url,topic_title,title,topic_cover_image_url,topic_description,url,topic_comics_count,shared_count,likes_count,comments_count,isLike) VALUES('%@','%@','%@','%@','%@','%@','%@','%ld','%ld','%ld','%ld','%d')",cartoon.user_nickname,cartoon.user_avatar_url,cartoon.topic_title,cartoon.title,cartoon.topic_cover_image_url,cartoon.topic_description,cartoon.url,cartoon.topic_comics_count,cartoon.shared_count,cartoon.likes_count,cartoon.comments_count,cartoon.isLike];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }

}

-(void)dropisLikeComicTable{
    NSString *sql = @"DROP TABLE isLikeComic";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
        NSLog(@"删除isLikeComic表失败");
    }

}

-(NSMutableArray *)selectAllisLikeComic{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = @"SELECT * FROM isLikeComic";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if(result == SQLITE_OK){
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int number = sqlite3_column_int(stmt, 0);
            const unsigned char *user_nickname = sqlite3_column_text(stmt, 1);
            const unsigned char *user_avatar_url = sqlite3_column_text(stmt, 2);
            const unsigned char *topic_title = sqlite3_column_text(stmt, 3);
            const unsigned char *title = sqlite3_column_text(stmt, 4);
            const unsigned char *topic_cover_image_url = sqlite3_column_text(stmt, 5);
            const unsigned char *topic_description = sqlite3_column_text(stmt, 6);
            const unsigned char *url = sqlite3_column_text(stmt, 7);
            int topic_comics_count = sqlite3_column_int(stmt, 8);
            int shared_count = sqlite3_column_int(stmt, 9);
            int likes_count = sqlite3_column_int(stmt, 10);
            int comments_count = sqlite3_column_int(stmt, 11);
            int isLike = sqlite3_column_int(stmt, 12);
            
            NSInteger numberInteger = number;
            NSString *user_nicknameStr = [NSString stringWithUTF8String:(const char *)user_nickname];
            NSString *user_avatar_urlStr = [NSString stringWithUTF8String:(const char *)user_avatar_url];
            NSString *topic_titleStr = [NSString stringWithUTF8String:(const char *)topic_title];
            NSString *titleStr = [NSString stringWithUTF8String:(const char *)title];
            NSString *topic_cover_image_urlStr = [NSString stringWithUTF8String:(const char *)topic_cover_image_url];
            NSString *topic_descriptionStr = [NSString stringWithUTF8String:(const char *)topic_description];
            NSString *urlStr = [NSString stringWithUTF8String:(const char *)url];
            NSInteger topic_comics_countInteger = topic_comics_count;
            NSInteger shared_countInteger = shared_count;
            NSInteger likes_countInteger = likes_count;
            NSInteger comments_countInteger = comments_count;
            BOOL isLikeBOOL = isLike;
            
            Cartoon *cartoon = [[Cartoon alloc] init];
            cartoon.user_nickname = user_nicknameStr;
            cartoon.user_avatar_url = user_avatar_urlStr;
            cartoon.topic_title = topic_titleStr;
            cartoon.title = titleStr;
            cartoon.topic_cover_image_url = topic_cover_image_urlStr;
            cartoon.topic_description = topic_descriptionStr;
            cartoon.url = urlStr;
            cartoon.topic_comics_count = topic_comics_countInteger;
            cartoon.shared_count = shared_countInteger;
            cartoon.likes_count = likes_countInteger;
            cartoon.comments_count = comments_countInteger;
            cartoon.isLike = isLikeBOOL;
            
            [array addObject:cartoon];
            [cartoon release];
        }
    }
    else{
        NSLog(@"查询isLikeComic表准备失败");
    }
    
    return array;

}

-(void)deleteisLikeComicWithTitle:(NSString *)title{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM isLikeComic WHERE title = '%@'",title];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if(result == SQLITE_OK){
    }
    else{
    }
}




@end
