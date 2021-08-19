--cau 1
--cau 2
alter table sanpham
add ghichu varchar(20) ;
--cau 3
alter table khachhang
add loaikh varchar(30);
--cau 4
alter table sanpham
alter column ghichu varchar(20);
--cau 5
alter table sanpham
drop column ghichu;
--cau 6
alter table sanpham
alter column ghichu varchar(20);
--cau 7
alter table sanpham
add constraint CK_sanpham check(dvt='cay' or dvt='cai' or dvt='quyen' or dvt='chuc');

--cau 8
alter table sanpham
add check(gia >= 500);
--cau 9
alter table cthd
add check(sl>0);
--C:\Users\huyhi\AppData\Local\Temp
--cau 10
select ngdk as ngaykhachhangdangky
from khachhang
where ngdk>ngsinh;
--cau 11
create trigger HD_C11
on hoadon
for Insert,Update
as
begin
  declare @ngdk datetime,@nghd datetime
  select @ngdk=ngdk,@nghd=nghd
  from inserted i,khachhang k
  where i.makh=k.makh
  if (@nghd<@ngdk)
   begin
   rollback tran
    print(N'không đúng')
    
   end
  else
    print(N'Đúng')

end

select * from hoadon

--cau 12
create trigger ngbh_C11
on hoadon
for insert
as
begin
  declare @ngvl datetime,@nghd datetime
  select @ngvl=ngvl,@nghd=nghd
  from hoadon h,nhanvien n
  where h.manv=n.manv
  if(@ngvl>@nghd)
  begin
  rollback tran
  print N'sai'
  end
  else
  print N'Thanh cong'
end
--cau 13
create trigger cthd_C11
on hoadon
for insert
as
begin
  declare @sohd int
  select @sohd=hoadon.sohd
  from hoadon,cthd,inserted
  where hoadon.sohd=cthd.sohd
  if (@sohd<0)
  begin
  rollback tran

  end
  else
  print 'dung'
end
--cau 14

--cau 15
--2.2
--cau 1
select masp,tensp
from sanpham
where nuocsx='Thailan';
--cau 2
select masp,tensp
from sanpham
where dvt in ('cay','quyen');
--cau 3
select masp,tensp
from sanpham
where masp like 'B%01';
--cau 4
select masp,tensp
from sanpham
where nuocsx='Trung Quoc' and (gia between 30000 and 40000);
--cau 5
select masp,tensp
from sanpham
where (nuocsx in ('Trung Quoc' ,'Thailan') )and (gia between 30000 and 40000);
--cau 6
select sohd,trigia
from hoadon
where nghd between 1/1/2017 and 2/1/2017;
--cau 7
select sohd,trigia
from hoadon
where nghd between 1/1/2017 and 31/1/2017
order by nghd asc,trigia desc;
--cau 8
select khachhang.makh , hoten
from hoadon,khachhang
where hoadon.makh=khachhang.makh and nghd= '1/1/2017';
--cau 9
select sohd,trigia
from hoadon,nhanvien
where hoadon.makh=nhanvien.hoten and nghd= '28/10/2016' and hoten='Nguyen Van B';
--cau 10
select c.masp,tensp
from sanpham s,cthd c,khachhang k,hoadon h
where s.masp=c.masp and k.makh=h.makh and c.sohd=h.sohd and hoten='Nguyen Van A' and (MONTH(ngdk)=10 and YEAR(ngdk)=2006);
