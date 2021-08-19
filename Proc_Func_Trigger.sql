use QLVeXemPhim
go
create proc themnv 
@MaNV nchar(10),
@TenNV nvarchar(100),
@Giolam int,
@sdt nchar(10)
as
begin
	declare @luong money
	select @luong= giolam*18000 from NHANVIEN where MaNV=@MaNV
	insert into NHANVIEN values (@MaNV,@TenNV,@Giolam,@sdt,@luong)
end
exec themnv NV006, N'Nguyễn Văn Sự',40,null
go
alter proc timmanv 
@mnvout nchar(10) out
as 
begin
	declare @manv nchar(10)
	set @manv= 'NV001'
	declare @i int 
	set @i=1
	while exists (select manv from NHANVIEN where manv=@manv)
	begin
		set @i=@i+1;
		set @manv='NV'+REPLICATE('0',3- LEN(cast (@i as nvarchar)))+cast (@i as nvarchar)
	end
	set @mnvout=@manv
end
declare @mnvout nchar(10) 
exec timmanv @mnvout out 
select @mnvout
go

alter proc insertmave 
@maveout nchar(10) out
as 
begin
	declare @mave nchar(10)
	set @mave= '000001'
	declare @i int 
	set @i=1
	while exists (select mave from VE where mave=@mave)
	begin
		set @i=@i+1;
		set @mave=REPLICATE('0',6- LEN(cast (@i as nvarchar)))+cast (@i as nvarchar)
	end
	set @maveout=@mave
end
declare @maveout nchar(10) 
exec insertmave @maveout out 
select @maveout
GO
alter proc insertVE
@mave nchar(10), 
@masc nchar(10), 
@maghe nchar(10),
@mahd nchar(10),
@dotuoi nvarchar(50)
as
begin
	declare @giave int
	declare @loaighe nchar(10)
	set @loaighe=(select loaighe from ghe where maghe=@maghe)
	if (@dotuoi=N'Trẻ em')
		select @giave=0.5*Gia from loaighe where loaighe=@loaighe
	else
		select @giave=gia from loaighe where loaighe=@loaighe
	INSERT INTO VE (MaVe,MaSC,MaGhe,MaHD,DoTuoi,GiaVe)
	VALUES (@mave,@masc,@maghe,@mahd,@dotuoi,@giave)
end
declare @maveout nchar(10) 
exec insertmave @maveout out 
exec insertVE @maveout,'SC000001','G0007','HD000001',N'Người lớn'
--exec insertVE @maveout,'1','12','0001',N'Trẻ em kgkg'
--delete ve where MaVe = '000001'


GO

alter proc themmsc 
@mscout nchar(10) out
as 
begin
	declare @ma nchar(10)
	set @ma= 'SC000001'
	declare @i int 
	set @i=1
	while exists (select MaSC from SUATCHIEU where MaSC=@ma)
	begin
		set @i=@i+1;
		set @ma='SC'+REPLICATE('0',6-LEN(cast (@i as nvarchar)))+cast (@i as nvarchar)
	end
	set @mscout=@ma
end
declare @mscout nchar(10) 
exec themmsc @mscout out 
select @mscout
go
create proc themsuatchieu
@masc nchar(10),
@ngay date,
@giobd time,
@maphong nchar(10),
@maphim nchar(10)
as
begin
	declare @thoiluong int,@gioketthuc int,@gio int,@phut int,@thoigian nvarchar(8),@ketthuc time(7)
	set @thoiluong=(select thoiluong from phim where maphim=@maphim)
	declare @giokt time
	set @gioketthuc = datepart(hour,@giobd)*60+ DATEPART(MINUTE,@giobd)+@thoiluong
	set @gio = @gioketthuc/60
	set @phut = @gioketthuc%60
	set @thoigian = cast(@gio as nvarchar)+':'+CAST(@phut as nvarchar) + ':00'
	set @ketthuc = CAST (@thoigian as time(7))
	insert into SUATCHIEU values(@masc,@ngay,@giobd,@ketthuc,@maphong,@maphim)
end

declare @mscout nchar(10) 
exec themmsc @mscout out 
--select @mscout
exec themsuatchieu @mscout,'2019/10/02','08:15:00','P01','P0003'
go
create trigger khongxoave on VE
for delete
as
begin
	RAISERROR (N'Dữ liệu không được xoá!!!',1,1)
	ROLLBACK
end
GO
use QLVeXemPhim
alter TRIGGER THEMVE ON VE
FOR INSERT,update
AS 
BEGIN
	DECLARE @MAVE NCHAR(10),@MAHD NCHAR(10), 
	@TONGTIEN MONEY,@maghe nchar(10),
	@dotuoi nvarchar(20),@gia money,
	@makh nchar(10),@maud nchar(10)
	SELECT @MAVE=MAVE,@maghe=MaGhe,@dotuoi=DoTuoi,@MAHD=MaHD FROM inserted
	select @gia=lg.Gia from LOAIGHE lg, Ghe g where lg.LoaiGhe=g.LoaiGhe and g.MaGhe = @maghe
	set @TONGTIEN = 0
	if(@dotuoi=N'Trẻ em')
		set @gia=0.5*@gia
	update ve set GiaVe = @gia where MaVe = @MAVE
	select @TONGTIEN = @TONGTIEN+ GiaVe from ve where MaHD = @MAHD
	select @makh=MaKH from HOADON where MaHD=@MAHD
	IF EXISTS ( SELECT * FROM THETV WHERE MaKH = @makh)
	BEGIN
		declare @diemtichluy int = @TONGTIEN/10000
		declare @loaithe nvarchar(10)
		if(@diemtichluy >=500)
			set @loaithe = 'VVIP'
		ELSE IF(@diemtichluy>=200)
			SET @loaithe = 'VIP'
		ELSE IF(@diemtichluy >=50)
			SET @loaithe = 'LOYALTY'
		ELSE
			SET @loaithe = 'MEMBER'
		UPDATE THETV SET DiemTichLuy = @diemtichluy,LoaiThe = @loaithe WHERE MaKH = @makh
		
		SELECT @maud = MaUuDai FROM UD_THE WHERE LoaiThe = @loaithe
		DECLARE @TYLE INT
		SELECT @TYLE = TyLeKhuyenMai FROM UUDAI WHERE MaUuDai = @maud
		SET @TONGTIEN = @TONGTIEN*(CAST((100-@TYLE)/100 AS float))
	END
	update HOADON set TongTien = @TONGTIEN where MaHD = @MAHD
END
