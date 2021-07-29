-- 设置客户端链接服务端的编码
set names utf8;
-- 丢弃数据库，如果存在
drop database if exists gfrproducts;
-- 创建新的数据库，设置储存编码
create database gfrproducts charset=utf8;
-- 进入数据库
use gfrproducts;
-- 创建数据表
create table productsclass(
    id int primary key auto_increment,
    foodclass varchar(25) not null
);
create table productsdetails(
    id int primary key auto_increment,
    foodname varchar(26) not null,
    price decimal(6,2) not null,
    type int not null,
    imgurl varchar(1000) not null,
    taste varchar(26)
);
ALTER TABLE productsdetails ADD ordernum int default 0; 
-- ALTER TABLE productsdetails DROP ordernum;

create table productsorder(
    id int primary key auto_increment,
    seatnum int,
    footname varchar(26),
    state int not null,
    taste varchar(26),
    time date not null,
    price decimal(6,2) not null,
		imgurl varchar(1000) not null,
		chefname varchar(32)
);

create table useraccount(
    id int primary key auto_increment,
    username varchar(18) not null unique,
    userpwd varchar(18) not null,
    type int not null,
    state boolean #1/0
);

create table combo(
id int primary key auto_increment,
comboname varchar(18) not null,
content varchar(18) not null,
price int not null
)
insert into combo values(null,'套餐A','炸酱面;煎蛋;冰红茶',22)

-- 插入数据
insert into productsclass values(null,'传统面食');
insert into productsclass values(null,'饺子');
insert into productsclass values(null,'炒面');
insert into productsclass values(null,'拌面');
insert into productsclass values(null,'炒饭');
insert into productsclass values(null,'盖浇饭');
insert into productsclass values(null,'汤羹');
insert into productsclass values(null,'特色菜');
insert into productsclass values(null,'小吃类');
insert into productsclass values(null,'精品凉菜');
insert into productsclass values(null,'饮品自取');
insert into productsclass values(null,'套餐A');
insert into productsclass values(null,'套餐B');
insert into productsclass values(null,'套餐C');

insert into productsdetails values(null,'红烧牛肉面','18.00',1,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0610%252F67208d32j00qughca001wc000k000c4c.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311366&t=5728e19dad1256e27ea2f6dd6f26a431','不要香菜;不要辣',0);


insert into productsdetails values(null,'传统牛肉拉面','10.00',1,'https://img2.baidu.com/it/u=3629461318,4196603831&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'酸菜牛肉面','13.00',1,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fyouxiid.cn%2Fd%2Ffile%2F20200602%2Fzqbxpy0ptyw2622.png&refer=http%3A%2F%2Fyouxiid.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311525&t=c7a507f3447952e7a6168753897125b4','不要香菜',0);
insert into productsdetails values(null,'牛肉水饺','14.00',2,'https://img1.baidu.com/it/u=924549645,3018013591&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'牛肉炒刀削','16.00',3,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.yzcdn.cn%2Fupload_files%2F2015%2F10%2F11%2FFvmE_QXbxwKpz0gJTaSV_0F4Z9np.png%3FimageView2%2F2%2Fw%2F580%2Fh%2F580%2Fq%2F75%2Fformat%2Fpng&refer=http%3A%2F%2Fimg.yzcdn.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311677&t=7254d856edb6f13ae1417c0bb0423b31','不要香菜',0);
insert into productsdetails values(null,'牛肉炒拉条','15.00',3,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi2.chuimg.com%2Fc946065f996340539bb6d214afb2e96c_4288w_2848h.jpg%3FimageView2%2F2%2Fw%2F660%2Finterlace%2F1%2Fq%2F90&refer=http%3A%2F%2Fi2.chuimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311729&t=dafff46bc3db6549c9974a20f52126c5','不要香菜',0);
insert into productsdetails values(null,'鸡蛋刀削面','16.00',3,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic131.huitu.com%2Fpic%2F20191024%2F1149609_20191024130850650070_0.jpg&refer=http%3A%2F%2Fpic131.huitu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311792&t=c973ee2da23f7d7660417940e22898fc','不要香菜',0);
insert into productsdetails values(null,'葱油拌面','14.00',4,'https://img2.baidu.com/it/u=4031271370,1068257693&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'炸酱面','10.00',4,'https://img1.baidu.com/it/u=2441243244,3571505444&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'干拌面','15.00',4,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.ecook.cn%2Fweb%2F262686479.jpg%21wd320&refer=http%3A%2F%2Fpic.ecook.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311865&t=10d93e85a7f011e35c10a0a6021935e6','不要香菜',0);
insert into productsdetails values(null,'蛋炒饭','11.00',5,'https://img0.baidu.com/it/u=1193477672,1104010993&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'兰州炒饭','15.00',5,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fdownload-p160-drcn.platform.hicloud.com%2Fdl%2Fhuafans%2Fpic%2F2019%2F02%2F25%2F4f0f7515e1f9db931d98ae5f7eb860b2_mmexport1550590380077.jpg%3Fmode%3Ddownload&refer=http%3A%2F%2Fdownload-p160-drcn.platform.hicloud.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311923&t=e1bab8e66a9e3e87e05fd7f0f6501d05','不要香菜',0);
insert into productsdetails values(null,'牛肉炒饭','13.00',5,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fdpic.tiankong.com%2Ft7%2Fwb%2FQJ9114972567.jpg&refer=http%3A%2F%2Fdpic.tiankong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311959&t=d8270a7bba560b7fd39a3c567a2f9491','不要香菜',0);
insert into productsdetails values(null,'红烧牛肉盖浇饭','18.00',6,'https://img1.baidu.com/it/u=851090530,1630553949&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'土豆烧牛肉盖浇饭','17.00',6,'https://img1.baidu.com/it/u=1219704603,3579475298&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'牛肉汤','12.00',7,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.lyqilixiang.com%2FUpload%2F20200114094454_4245.jpg&refer=http%3A%2F%2Fwww.lyqilixiang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311998&t=8e7ddb24ef7b5dd87d9b841fce166863','不要香菜',0);
insert into productsdetails values(null,'西红柿鸡蛋汤','10.00',7,'https://img2.baidu.com/it/u=1185705464,2849021934&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'红烧牛肉','39.00',8,'https://img0.baidu.com/it/u=1733450719,725271710&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'孜然牛肉','39.00',8,'https://img0.baidu.com/it/u=1514886591,2118608820&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'青椒土豆丝','18.00',8,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.yzcdn.cn%2Fupload_files%2F2015%2F04%2F25%2FFv-rhO7SzbOUkhQcTkOdIBG6i0BR.jpg%3FimageView2%2F2%2Fw%2F580%2Fh%2F580%2Fq%2F75%2Fformat%2Fjpg&refer=http%3A%2F%2Fimg.yzcdn.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626312032&t=45120f379e3f4df13c530f0b45a03843','不要香菜',0);
insert into productsdetails values(null,'酸辣白菜','18.00',8,'https://img1.baidu.com/it/u=2894328520,3602213488&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'肉夹馍','10.00',9,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.91jm.com%2F2016%2F11%2Fy8u6IOp58429.jpg&refer=http%3A%2F%2Fimg.91jm.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626312064&t=a063f70f4641dd7979005823ff77fd54','不要香菜',0);
insert into productsdetails values(null,'煎蛋','2.00',9,'https://img1.baidu.com/it/u=2608442870,2607528828&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'馕饼','5.00',9,'https://img2.baidu.com/it/u=2222617491,1723542833&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'爽口笋丝','20.00',10,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.51yuansu.com%2Fpic3%2Fcover%2F02%2F39%2F24%2F59c29c5392739_610.jpg&refer=http%3A%2F%2Fpic.51yuansu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626312557&t=b8334a6087616b8a907a79da1233d434','不要香菜',0);
insert into productsdetails values(null,'醋泡花生','18.00',10,'https://img2.baidu.com/it/u=2943333508,2469164210&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'凉拌黄瓜','10.00',10,'https://img2.baidu.com/it/u=285235899,91224395&fm=26&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'可口可乐','4.00',11,'https://img0.baidu.com/it/u=378629626,3035260511&fm=224&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'雪碧','4.00',11,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa2.att.hudong.com%2F01%2F64%2F50200009239445156062645923858_w.jpg&refer=http%3A%2F%2Fa2.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626312160&t=f21467d82c682e9cd00b945fa095cfb4','不要香菜',0);
insert into productsdetails values(null,'茉莉蜜茶','3.00',11,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimgqn.koudaitong.com%2Fupload_files%2F2015%2F05%2F05%2FFkxoFK-KvXF9CLpjY_v3HWmmNzC6.jpg%21280x280.jpg&refer=http%3A%2F%2Fimgqn.koudaitong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626312194&t=9f51933b309b56e97f8c36fa1bd30d4c','不要香菜',0);
insert into productsdetails values(null,'绿茶','3.00',11,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.yzcdn.cn%2Fupload_files%2F2016%2F04%2F17%2FFsKRi4e_Aihb9-_2bzprROQOFH2T.jpg%21280x280.jpg&refer=http%3A%2F%2Fimg.yzcdn.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626312238&t=bc84a9908e830c2f9537d6bafcceb3ae','不要香菜',0);
insert into productsdetails values(null,'冰红茶','3.00',11,'https://img1.baidu.com/it/u=1483740445,1516949802&fm=224&fmt=auto&gp=0.jpg','不要香菜',0);
insert into productsdetails values(null,'果粒橙','4.00',11,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimgqn.koudaitong.com%2Fupload_files%2F2015%2F04%2F10%2FFnsUeRCdxaOxDSUZw-NwRTISAj00.jpg%21580x580.jpg&refer=http%3A%2F%2Fimgqn.koudaitong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626312271&t=bbf272656893cb6189448c6458536c01','不要香菜',0);

insert into productsorder values(null,12,'红烧牛肉面',0,'不要香菜','2021.06.07','18.00','https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0610%252F67208d32j00qughca001wc000k000c4c.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311366&t=5728e19dad1256e27ea2f6dd6f26a431',null);
insert into productsorder values(null,8,'牛肉水饺',0,'不要香菜','2021.05.03','14.00','https://img1.baidu.com/it/u=924549645,3018013591&fm=26&fmt=auto&gp=0.jpg',null);
insert into productsorder values(null,2,'炒拉条',0,'不要香菜','2021.06.07','10.00','https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi2.chuimg.com%2Fc946065f996340539bb6d214afb2e96c_4288w_2848h.jpg%3FimageView2%2F2%2Fw%2F660%2Finterlace%2F1%2Fq%2F90&refer=http%3A%2F%2Fi2.chuimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626311729&t=dafff46bc3db6549c9974a20f52126c5',null);
insert into productsorder values(null,5,'葱油拌面',0,'不要香菜','2021.06.08','14.00','https://img2.baidu.com/it/u=4031271370,1068257693&fm=26&fmt=auto&gp=0.jpg',null);

insert into useraccount values(null,'admin','123',0,1);
insert into useraccount values(null,'GFR','123',0,1);
insert into useraccount values(null,'FWY1','123',1,0);
insert into useraccount values(null,'FWY2','123',1,1);
insert into useraccount values(null,'FWY3','123',1,1);



