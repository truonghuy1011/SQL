--bài 1.1)

SELECT count(ma) FROM (SELECT COUNT(ma_docgia) AS ma 
FROM Muon group by ma_docgia, ngayGio_muon) AS tk

--Bài 1.2)
SELECT COUNT(ma_docgia)*100.0/(SELECT COUNT(ma_docgia) FROM DocGia) AS tong 
FROM DocGia
WHERE ma_docgia in (SELECT ma_docgia FROM Muon)

(SELECT Muon.ma_docgia,COUNT(Muon.ma_docgia) FROM Muon, DocGia WHERE Muon.ma_docgia = DocGia.ma_docgia GROUP by Muon.ma_docgia)

--Bài 1.3)
SELECT max(tg) AS N'số lượng nhiều nhất một người đã mượn'
FROM(
SELECT COUNT(Muon.ma_cuonsach) AS tg FROM Muon, DocGia 
WHERE Muon.ma_docgia = DocGia.ma_docgia 
GROUP by Muon.ma_docgia
) AS tong

--Bài 1.4)
SELECT COUNT(CuonSach.isbn)*100/(SELECT COUNT(isbn) FROM CuonSach)
FROM CuonSach
WHERE CuonSach.isbn in (SELECT isbn FROM Muon WHERE YEAR(ngayGio_muon) = 2002 group by isbn)
----------------------------------------STORE PROCEDURE---------------------------------------------------
--Bài 4.1)
GO
CREATE PROC sp_ThongTinDocGia (@MADOCGIA SMALLINT)
AS
BEGIN
	IF	(@MADOCGIA % 2 = 0)
	BEGIN
		SELECT DocGia.*, TreEm.* FROM DocGia, TreEm WHERE DocGia.ma_docgia = TreEm.ma_docgia AND DocGia.ma_docgia = @MADOCGIA AND TreEm.ma_docgia = @MADOCGIA
	END
	ELSE
	BEGIN
		SELECT DocGia.*, NguoiLon.* FROM DocGia, NguoiLon WHERE DocGia.ma_docgia = NguoiLon.ma_docgia AND DocGia.ma_docgia = @MADOCGIA AND NguoiLon.ma_docgia = @MADOCGIA
	END
END
EXEC sp_ThongTinDocGia 3

--Bài 4.2)
GO
CREATE PROC sp_ThongTinDauSachC1 (@isbn INT)--CÁCH 1
AS
BEGIN
	SELECT *, (SELECT COUNT(tinhtrang) FROM Cuonsach AS cs WHERE tinhtrang = 'Y' and ds.isbn = cs.isbn GROUP BY isbn) AS soluong
	FROM DauSach AS ds join (SELECT ma_tuASach, tuASach, tacgia FROM TuASach) AS ts 
	ON (ts.ma_tuASach = ds.ma_tuASach AND ds.isbn = @isbn)
END
EXEC sp_ThongTinDauSachC1 1

GO
CREATE PROC sp_ThongTinDauSachC2 (@isbn INT)--CÁCH 2
AS
BEGIN
	SELECT tuASach, tacgia, tomtat, ngonngu, bia, trangthai, count(*)
	FROM dausach ds, tuASach ts, cuonsach cs
	WHERE ds.ma_tuASach = ts.ma_tuASach AND ds.isbn = cs.isbn AND ds.isbn = @isbn AND tinhtrang = 'Y'
	GROUP BY tuASach, tacgia, tomtat, ngonngu, bia, trangthai
END
EXEC sp_ThongTinDauSachC2 1

--Bài 4.3)
GO
CREATE PROC sp_ThongtinNguoilonDangmuon
AS
BEGIN
	SELECT ngl.*
	FROM Nguoilon AS ngl JOIN (SELECT ma_DocGia FROM Muon) AS T ON (T.ma_DocGia = ngl.ma_DocGia)
	WHERE NOT EXISTS (SELECT * FROM QuaTrinhMuon AS qt WHERE T.ma_DocGia = qt.ma_DocGia)
	GROUP BY ngl.ma_docgia, ngl.sonha, ngl.quan, ngl.han_sd, ngl.duong, ngl.dienthoai
END
EXEC sp_ThongtinNguoilonDangmuon

--Bài 4.4)
GO
CREATE PROC sp_ThongtinNguoilonQuahan
AS
BEGIN
	SELECT NGL.*, DG.ho, DG.tenlot, DG.ten, DG.NgaySinh
	FROM NguoiLon NGL,Muon M,DocGia DG 
	WHERE NGL.ma_docgia = M.ma_docgia AND NGL.ma_docgia = DG.ma_docgia AND DATEDIFF(DAY, ngayGio_muon, GETDATE())>14 
	AND M.isbn NOT IN(SELECT isbn FROM QuaTrinhMuon) AND M.ma_cuonsach NOT IN(SELECT ma_cuonsach FROM QuaTrinhMuon)
	GROUP BY NGL.ma_docgia, NGL.sonha, NGL.duong, NGL.quan, NGL.dienthoai, NGL.han_sd, DG.ho, DG.tenlot, DG.ten, DG.NgaySinh
END
EXEC sp_ThongtinNguoilonQuahan

--Bài 4.5)
GO
CREATE PROC sp_DocGiaCoTreEmMuon
AS
BEGIN
	SELECT	M.ma_docgia 
	FROM	 Muon M,NguoiLon NGL 
	WHERE	M.ma_docgia = NGL.ma_docgia AND M.ma_docgia 
	IN	(SELECT ma_docgia_nguoilon FROM ( SELECT M.ma_docgia FROM Muon M,TreEm TE WHERE M.ma_docgia = TE.ma_docgia GROUP BY M.ma_docgia) TRX ,TreEm Y WHERE TRX.ma_docgia = Y.ma_docgia)
	GROUP BY M.ma_docgia
END
EXEC sp_DocGiaCoTreEmMuon

--Bài 4.6)
GO
CREATE PROC sp_CapNhatTrangThaiDauSach ( @dausach SMALLINT)
AS
BEGIN
	IF EXISTS(SELECT*FROM CuonSach WHERE isbn=@dausach)
	update DauSach SET trangthai='Y' WHERE isbn=@dausach
	ELSE update DauSach SET trangthai='N' WHERE isbn=@dausach
END

--Bài 4.7)
GO
CREATE PROC sp_ThemTuASach (@ts NVARCHAR(63)=NULL, @tg NVARCHAR(31)=NULL, @tt VARCHAR(222)=NULL)
AS
BEGIN
	DECLARE @ma_tuASach SMALLINT=1
	WHILE EXISTS (SELECT * FROM TuASach WHERE ma_tuASach = @ma_tuASach)
		SET @ma_tuASach = @ma_tuASach+1;
		IF(@ts IS NOT NULL OR @tg IS NOT NULL OR @tt IS NOT NULL)
		BEGIN
			IF EXISTS( SELECT*FROM TuASach WHERE tomtat=@tt)
			BEGIN
				PRINT N'BỊ TRÙNG DỮ LIỆU'
			END
			ELSE
			BEGIN
				INSERT INTO TuASach(ma_tuASach,TuASach,tacgia,tomtat)
				VALUES (@ma_tuASach,@ts,@tg,@tt)
			END
		END
		ELSE PRINT N'cHƯA NHẬP XONG'
END

--Bài 4.8)
GO
CREATE PROC sp_ThemCuonSach (@isbn INT = NULL)
AS
BEGIN
	IF @isbn IS NULL PRINT N'Chưa nhập mã đầu sách'
	ELSE
	BEGIN
		IF EXISTS (SELECT*FROM DauSach WHERE isbn=@isbn)
		BEGIN
			DECLARE @ma_cuonsach SMALLINT=1
			WHILE EXISTS (SELECT*FROM CuonSach WHERE Ma_CuonSach=@ma_cuonsach and isbn=@isbn)
				SET @ma_cuonsach=@ma_cuonsach+1
				INSERT INTO CuonSach(isbn,Ma_CuonSach,TinhTrang)
				VALUES (@isbn,@ma_cuonsach,'Y')
			exec sp_CapnhatTrangthaiDausach @isbn
		END
		ELSE PRINT N'Mã đầu sách không tồn tại'
	END
END

--Bài 4.9)
GO
CREATE PROC sp_ThemNguoiLon
(	@ho NVARCHAR(15),
	@tenlot NVARCHAR(1),
	@ten NVARCHAR(15),
	@ngaysinh SMALLDATETIME,
	@sonha NVARCHAR(15),
	@duong NVARCHAR(63),
	@quan NVARCHAR(2),
	@sdt NVARCHAR(13),
	@han_sd SMALLDATETIME)
AS
BEGIN
	DECLARE @ma_docgia SMALLINT=1
	WHILE EXISTS (SELECT*FROM DocGia WHERE ma_docgia=@ma_docgia )
		SET @ma_docgia=@ma_docgia+1
		INSERT INTO DocGia(ma_docgia,ho,tenlot,ten,NgaySinh)
		VALUES (@ma_docgia,@ho,@tenlot,@ten,@ngaysinh)
		IF  DATEDIFF(YEAR,@ngaysinh,GETDATE())>=18
		BEGIN
			INSERT INTO NguoiLon(ma_docgia,sonha,duong,quan,dienthoai,han_sd)
			VALUES (@ma_docgia,@sonha,@duong,@quan,@sdt,@han_sd)
		END
		ELSE
		BEGIN
			PRINT N'KHÔNG ĐỦ TUỔI NGƯỜI LỚN'
		END
END
EXEC sp_ThemNguoiLon N'QUANG','V',N'VŨ','06/10/2005',N'11E',N'111','1','0909','12/6/2020'

--Bài 4.10)
GO
CREATE PROC sp_ThemTreEm(@ho NVARCHAR(15), @tenlot NVARCHAR(1), @ten NVARCHAR(15), @ngaysinh SMALLDATETIME, @ma_docgia_nguoilon SMALLINT)
AS
BEGIN
	DECLARE @ma_docgia SMALLINT=1
	WHILE EXISTS (SELECT*FROM DocGia WHERE ma_docgia=@ma_docgia )
		SET @ma_docgia=@ma_docgia+1
		INSERT INTO DocGia(ma_docgia,ho,tenlot,ten,NgaySinh)
		VALUES (@ma_docgia,@ho,@tenlot,@ten,@ngaysinh)
		IF  EXISTS(SELECT *FROM NguoiLon WHERE ma_docgia=@ma_docgia_nguoilon)
		BEGIN
			IF EXISTS(SELECT ma_docgia_nguoilon FROM TreEm WHERE ma_docgia_nguoilon=@ma_docgia_nguoilon group by ma_docgia_nguoilon having count(*)  >=2)
				PRINT N'ĐỘC GIẢ NÀY ĐÃ BẢO LÃNH HƠN 2 NGƯỜI'
			ELSE 
				INSERT INTO TreEm(ma_docgia,ma_docgia_nguoilon)
				VALUES (@ma_docgia,@ma_docgia_nguoilon)
		END
		ELSE
		BEGIN
			PRINT N'KHÔNG PHẢI NGƯỜI LỚN'
		END
END
EXEC sp_ThemTreEm N'QUANG','Q','CONM','4/5/2010',1

--Bài 4.11)
GO
CREATE PROC sp_XoaDocGia (@ma_docgia INT =NULL)
AS
BEGIN
	DECLARE @ma_treem1 int,@ma_treem2 int 
	IF not EXISTS  ( SELECT*FROM DocGia WHERE ma_docgia=@ma_docgia)
	BEGIN
		PRINT N'ĐỌC GIẢ KHÔNG TỒN TẠI'
	END
	ELSE IF EXISTS (SELECT*FROM Muon WHERE ma_docgia=@ma_docgia)
	BEGIN
		PRINT N'KO XÓA DUOC'
	END
	ELSE IF EXISTS (SELECT *FROM NguoiLon WHERE ma_docgia=@ma_docgia)
	BEGIN
		IF NOT EXISTS (SELECT *FROM TreEm WHERE ma_docgia_nguoilon=@ma_docgia)
		BEGIN
			DELETE FROM NguoiLon WHERE ma_docgia=@ma_docgia
			DELETE FROM QuaTrinhMuon WHERE ma_docgia=@ma_docgia
			DELETE FROM DangKy WHERE ma_docgia=@ma_docgia
			DELETE FROM DocGia WHERE ma_docgia=@ma_docgia
			END
		ELSE 
		BEGIN
			SELECT @ma_treem1=max(ma_docgia) FROM TreEm WHERE ma_docgia_nguoilon=@ma_docgia
			SELECT @ma_treem2=ma_docgia FROM TreEm WHERE ma_docgia_nguoilon=@ma_docgia AND ma_docgia !=@ma_treem1
			DELETE FROM TreEm WHERE ma_docgia=@ma_treem1
			DELETE FROM TreEm WHERE ma_docgia=@ma_treem2
			DELETE FROM NguoiLon WHERE ma_docgia=@ma_docgia
			DELETE FROM QuaTrinhMuon WHERE ma_docgia=@ma_docgia
			DELETE FROM DangKy WHERE ma_docgia=@ma_docgia
			DELETE FROM DocGia WHERE ma_docgia=@ma_docgia
		END
	END
	ELSE 
	BEGIN
		DELETE FROM TreEm WHERE ma_docgia=@ma_docgia
		DELETE FROM QuaTrinhMuon WHERE ma_docgia=@ma_docgia
		DELETE FROM DangKy WHERE ma_docgia=@ma_docgia
		DELETE FROM DocGia WHERE ma_docgia=@ma_docgia
	END
END
EXEC sp_XoaDocGia 91

--Bài 4.12)
GO
CREATE PROC sp_MuonSach(@isbn INT=NULL ,@ma_cuonsach SMALLINT=NULL,@ma_docgia INT=NULL)
AS
BEGIN
	DECLARE @soluongMuon INT,@ma_treem1 INT,@ma_treem2 INT,@ma_nguoilon INT
	IF EXISTS (SELECT *FROM Muon WHERE isbn=@isbn and ma_docgia=@ma_docgia )
	BEGIN
		PRINT N'QUYỂN SÁCH ĐÃ MƯỢN'
	END
	ELSE
	BEGIN
		SELECT @soluongMuon=COUNT(*) FROM Muon WHERE ma_docgia=@ma_docgia group by ma_docgia
		IF EXISTS (SELECT*FROM NguoiLon WHERE ma_docgia=@ma_docgia)
		BEGIN
			SELECT @ma_treem1=max(ma_docgia) FROM TreEm WHERE ma_docgia_nguoilon=@ma_docgia
			SELECT @ma_treem2=ma_docgia FROM TreEm WHERE ma_docgia_nguoilon=@ma_docgia and ma_docgia !=@ma_treem1
			SELECT @soluongMuon=@soluongMuon+COUNT(*) FROM Muon WHERE ma_docgia=@ma_treem1 group by ma_docgia
			SELECT @soluongMuon=@soluongMuon+COUNT(*) FROM Muon WHERE ma_docgia=@ma_treem2 group by ma_docgia
			IF(@soluongMuon>= 5)
			BEGIN
				PRINT N'SỐ LƯỢNG MƯỢN NHIỀU'
				return
			END
		END
		ELSE
		BEGIN
			IF(@soluongMuon>=1)
			BEGIN
				PRINT N'SỐ LƯỢNG MƯỢN NHIỀU'
				return
			END
			ELSE IF(@soluongMuon<1)
			BEGIN
				SELECT @ma_nguoilon=ma_docgia_nguoilon FROM TreEm WHERE ma_docgia=@ma_docgia
				SELECT @soluongMuon=COUNT(*) FROM Muon WHERE ma_docgia=@ma_docgia group by ma_docgia
				IF(@soluongMuon>=5) 
				BEGIN
					PRINT N'SỐ LƯỢNG MƯỢN CỦA NGƯỜI LỚN VÀ TRẺ EM NHIỀU'
					return
				END
			END
		END
	IF EXISTS (SELECT *FROM CuonSach WHERE isbn=@isbn and Ma_CuonSach=@ma_cuonsach and TinhTrang='Y')
	BEGIN
		INSERT INTO Muon(isbn,ma_cuonsach,ma_docgia,ngayGio_muon,ngay_hethan)
		VALUES (@isbn,@ma_cuonsach,@ma_docgia,GETDATE(),DATEADD(DAY,14,GETDATE()))
		update CuonSach SET TinhTrang='N' WHERE isbn=@isbn and Ma_CuonSach=@ma_cuonsach
		PRINT N'MƯỢN THÀNH CÔNG'
	END
	ELSE
		INSERT INTO DangKy(isbn,ma_docgia,ngaygio_dk,ghichu)
		VALUES (@isbn,@ma_docgia,GETDATE(),NULL)
		PRINT N'SÁCH HẾT HẠN DK'
	END
END

--Bài 4.13)

----------------------------------------TRIGGER---------------------------------------------------
--Bài 5.1)
GO
CREATE TRIGGER tg_delMuon ON muon FOR DELETE
AS
BEGIN
	DECLARE @isbn INT, @ma_cuonsach INT
	SELECT @isbn = isbn, @ma_cuonsach = ma_cuonsach
	FROM DELETED
	UPDATE cuonsach SET tinhtrang = 'Y' WHERE isbn = @isbn AND ma_cuonsach = @ma_cuonsach
END

--Bài 5.2)
GO
CREATE TRIGGER tg_insMuon ON muon FOR DELETE
AS
BEGIN
	DECLARE @isbn INT, @ma_cuonsach INT
	SELECT @isbn = isbn, @ma_cuonsach = ma_cuonsach
	FROM DELETED
	UPDATE cuonsach SET tinhtrang = 'N' WHERE isbn = @isbn AND ma_cuonsach = @ma_cuonsach
END

--Bài 5.3)
GO
CREATE TRIGGER tg_updCuonSach ON CuonSach FOR UPDATE
AS
BEGIN
	DECLARE @isbn INT, @TinhTrang NVARCHAR(1)
	SELECT @isbn = isbn, @TinhTrang = TinhTrang FROM INSERTED
	UPDATE DauSach SET trangthai = @TinhTrang WHERE isbn = @isbn
END

SELECT * FROM CuonSach, DauSach WHERE CuonSach.isbn = DauSach.isbn