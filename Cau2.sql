CREATE DATABASE quanlyphongmay  
ON   
( NAME = data1,  
    FILENAME = 'D:\Dt1.mdf',  
    SIZE = 10,  
    MAXSIZE = 1000,  
    FILEGROWTH = 10 ),
	  ( NAME = data2,  
    FILENAME = 'D:\Dt2.mdf',  
    SIZE = 10,  
    MAXSIZE = 1000,  
    FILEGROWTH = 10 )
LOG ON  
( NAME = log1,  
    FILENAME = 'D:\SL1.ndf',  
    SIZE = 30MB,  
    MAXSIZE = 2048MB,  
    FILEGROWTH = 30MB ) ,  
	
( NAME = log2,  
    FILENAME = 'D:\SL2.ndf',  
    SIZE = 30MB,  
    MAXSIZE = 2000MB,  
    FILEGROWTH = 30MB )
	 ;  
use quanlyphongmay
 create table phongmay(
	maphong nvarchar (20) primary key,
	ghichu nvarchar (100)
	)

	create table maytinh (
	mamay nvarchar (20) primary key,
	ghichu nvarchar (100),
	maphong nvarchar (20)
	)

	create table monhoc(
	mamon nvarchar (20) primary key,
	tenmon nvarchar (100),
	sogio int
	)

	create table dangky (
	mamon nvarchar (20) ,
	maphong nvarchar (20),
	ngaydangky datetime,
	primary key (mamon, maphong)
	)

	alter table maytinh add foreign key (maphong) references phongmay (maphong)
	alter table dangky add foreign key (mamon) references monhoc(mamon)
	alter table dangky add foreign key (maphong) references phongmay (maphong)

CREATE LOGIN thaovt WITH PASSWORD = '0123456',
DEFAULT_DATABASE = quanlyphongmay
CREATE LOGIN camntt WITH PASSWORD = '0123456',
DEFAULT_DATABASE = quanlyphongmay

CREATE USER thaovt
FROM LOGIN thaovt
CREATE USER camntt
FROM LOGIN camntt

CREATE ROLE phongkt
GRANT create table
to phongkt

CREATE SERVER ROLE phongkythuat
USE master
alter server role dbcreator
add member phongkythuat

alter server role phongkythuat
add member thaovt

alter role phongkt
add member thaovt

alter role db_datareader add member camntt
grant insert on phongmay to camntt WITH GRANT OPTION


insert into phongmay values('111', 'aaaa')
insert into maytinh values('m1', 'bb', '111')

BACKUP DATABASE quanlyphongmay TO DISK='D:\qlpm.bak'

insert into phongmay values('222', 'cccc')
insert into maytinh values('m2', 'bb', '222')

BACKUP DATABASE quanlyphongmay TO DISK = 'D:\qlpm.DIF' WITH DIFFERENTIAL

insert into phongmay values('333', 'dddd')
insert into maytinh values('m3', 'bb', '333')

ALTER DATABASE quanlyphongmay SET RECOVERY FULL
BACKUP DATABASE quanlyphongmay TO DISK='D:\qlpm.bak'
BACKUP LOG quanlyphongmay TO DISK = 'D:\qlpm.TRN'