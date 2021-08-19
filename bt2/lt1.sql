--cau 1
--cau 2
alter table sanpham
add ghichu varchar(20);
--cau 3
alter table khachhang
add loaikh tinyint;
--cau 4
update khachhang
set hoten='Nguyen Van B'
where makh='KH01';
--cau 5
update khachhang
set hoten='Nguyen Van Hoan' 
where makh='KH08' and ngdk=YEAR(2007);
--cau 6
alter table sanpham
alter column ghichu varchar(100);
--cau 7
alter table sanpham
drop column ghichu;
--cau 8
delete from khachhang
where ngsinh=YEAR(1971);
--cau 9
delete from khachhang
where ngsinh=YEAR(1971)and ngdk=YEAR(2006);
--cau 10
delete from khachhang
where makh='KH01';