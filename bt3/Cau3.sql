create database quanlynhanvien
on(
	name = Data1,
	filename = 'D:\Data1.mdf',
	size = 10,
	maxsize = unlimited,
	filegrowth = 10
),
(
	name = Data2,
	filename = 'D:\Data2.mdf',
	size = 10,
	maxsize = 1024,
	filegrowth = 10
)
log on(
	name = log1,
	filename = 'D:\log1.ndf',
	size = 30,
	maxsize = unlimited,
	filegrowth = 30
)
use quanlynhanvien

create table phongban(
	maphong varchar(20) primary key,
	tenphong nvarchar(100),
	dienthoai int
)
create table nhanvien(
	manv varchar(20) primary key,
	tennv nvarchar(100),
	gioitinh nvarchar(3),
	ngaysinh date,
	diachi nvarchar(200),
	maphong varchar(20)
)
alter table nhanvien add foreign key (maphong) references phongban(maphong)

insert into  phongban values ('p1','phong1','0123456')
insert into  nhanvien values ('nv1','nguyenhoduytri','nam','2019-09-09','HCM','p1')
backup database quanlynhanvien to disk = 'D:\qlnv.bak'

insert into  phongban values ('p2','phong2','01234567')
insert into  nhanvien values ('nv2','nhdtri','nam','2019-09-09','HCM','p2')
backup database quanlynhanvien to disk = 'D:\qlnv.DIF' with differential

insert into  phongban values ('p3','phong3','012345678')
insert into  nhanvien values ('nv3','hdtri','nam','2019-09-09','HCM','p3')
alter database quanlynhanvien set recovery full 
backup database quanlynhanvien to disk = 'D:\qlnv.bak'
backup log quanlynhanvien to disk = 'D:\qlnv.TRN'


drop database quanlynhanvien

restore database quanlynhanvien from disk ='D:\qlnv.bak' with standby = 'D:\qlnv.bak'
