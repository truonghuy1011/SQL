backup database bt1
to disk= 'D:\SQL\bt1\bt1'
with differential

/*drop table khachhang;
drop table nhanvien;
drop table hoadon;
drop table cthd;
drop table sanpham;*/
--tao bang khachhang
create table khachhang(
makh char(4) not null primary key,
hoten varchar(40) ,
dchi varchar(50),
sodt varchar(20),
ngsinh datetime,
ngdk datetime,
doanhso money
);
--du lieu khachhang

insert into khachhang(makh,hoten,dchi,sodt,ngsinh,ngdk,doanhso)
values('KH01','Nguyen Van A','7 tran hung dao,q5,tphcm',0898981234,22-07-1960,22-10-2006,130000000),
('KH02','Nguyen Van C','78 tran hung da,q5,tphcm',0894441234,22-07-1980,22-10-2006,135000000),
('KH03','Nguyen Van D','79 tran hung dao,q7,tphcm',0812121234,22-07-1965,22-10-2006,23000000),
('KH04','Nguyen Van L','71 tran hung dao,q6,tphcm',0111981234,22-07-1999,22-10-2006,5600000),
('KH05','Nguyen Van N','72 tran hung dao,q5,tphcm',0898981555,22-07-1961,22-10-2006,9800000),
('KH06','Nguyen Van V','734 tran hung dao,q9,tphcm',0222981234,22-07-1962,22-10-2006,1200000),
('KH07','Nguyen Van Y','77/2 tran hung dao,q12,tphcm',0666981234,22-07-1963,22-10-2007,10000),
('KH08','Nguyen Van X','75/23 tran hung dao,q11,tphcm',0898986764,22-07-1964,22-10-2007,12300000);


--tao bang nhanvien
create table nhanvien(
manv char(4) not null primary key,
hoten varchar(40)  ,
sodt varchar(20),
ngvl datetime,

);
--du lieu nhanvien

insert into nhanvien(manv,hoten,sodt,ngvl)
values('NV01','Nguyen Phu Nhut',0999576345,23/10/2006),
('NV02','Nguyen Van B',0993336345,21/01/2006),
('NV03','Nguyen Nhut',0999576665,27/11/2006),
('NV04','Nguyen Phuc Nhut',0988876345,24/12/2006),
('NV05','Nguyen Phuc BOn',0988996345,24/12/2006);

--tao bang sanpham
create table sanpham(
masp char(4) not null primary key,
tensp varchar(40) ,
dvt varchar(20),
nuocsx varchar(40),
gia money ,

);

--du lieu sanpham
insert into sanpham(masp,tensp,dvt,nuocsx,gia)
values('BC01','But chi','cay','Singapore',19000),
('BC02','But chi','cay','VN',19400),
('BB03','But chi','cay','Malaysia',34000),
('BB04','But chi','cay','Thailan',67000),
('TV05','Tap','quyen','Singapore',22000),
('TV06','Tap','quyen','Singapore',12100),
('ST07','Thuoc','cai','Lao',77000),
('ST08','Gom','cai','Myanma',3400),
('ST09','So tay','quyen','Nam Phi',2300);

--tao bang hoadon
create table hoadon(
sohd int not null primary key,
manv char(4) not null ,
makh char(4) not null,
nghd datetime,
trigia money,
constraint FK_manv foreign key(manv) references nhanvien(manv),
constraint FK_makh foreign key(makh) references khachhang(makh)
);
--du lieu hoadon
insert into hoadon(sohd,manv,makh,nghd,trigia)
values(1001,'NV01','KH01',23/07/2006,320000),
(1002,'NV02','KH01',23/07/2006,320000),
(1003,'NV01','KH03',23/07/2006,320000),
(1004,'NV03','KH02',23/07/2006,320000),
(1005,'NV04','KH04',23/07/2006,320000),
(1006,'NV05','KH05',23/07/2006,320000),
(1007,'NV01','KH01',23/07/2006,320000)
;

--tao bang sanpham
create table cthd(
sohd int not null primary key,
masp char(4) not null ,
sl int,
constraint FK_masp foreign key(masp) references sanpham(masp),
);
--du lieu cthd
insert into cthd(sohd,masp,sl)
values(1007,'BC01',10),
(1001,'BC01',30),
(1006,'BC02',20),
(1004,'BC02',40),
(1001,'BB03',70),
(1002,'BB03',90),
(1002,'BB04',100),
(1003,'TV05',101),
(1004,'TV06',16),
(1005,'ST07',17),
(1006,'ST08',18),
(1007,'ST09',11),
(1001,'ST09',105),
(1001,'ST07',109)
;