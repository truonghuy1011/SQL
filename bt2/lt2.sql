--cau 1
select masp,tensp
from sanpham
where nuocsx='Singapore';
--cau 2
select masp,tensp
from sanpham
where dvt='cay' and dvt='quyen';
--cau 3
select masp,tensp
from sanpham
where masp like'B%01';
--cau 4
select masp,tensp
from sanpham
where nuocsx='Singapore' and gia between 19000 and 70000;
--cau 5
select masp,tensp
from sanpham
where nuocsx='Singapore' or nuocsx='Thailan' and gia between 19000 and 70000;
--cau 6
select sohd,trigia
from hoadon
where nghd between '1/1/2007' and '2/1/2007';
--cau 7
select sohd,trigia
from hoadon
where nghd between '1/1/2007' and '31/1/2007'
order by nghd asc , trigia desc;
--cau 8
select makh,hoten
from khachhang
where ngdk='1/1/2007';
--cau 9
select h.sohd,h.trigia
from hoadon as h,nhanvien as n
where h.manv=n.manv and
n.hoten='Nguyen Van B'
and nghd='28/10/2006';
--cau 10
select sanpham.masp,sanpham.tensp
from (khachhang join hoadon on khachhang.makh=hoadon.makh)
join (sanpham join cthd on sanpham.masp=cthd.masp)
on cthd.sohd=hoadon.sohd
where 
khachhang.hoten='Nguyen Van C'--and nghd between 1/10/2006 and 31/10/2006;