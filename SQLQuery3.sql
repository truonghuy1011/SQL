﻿create database QUANLITHUVIEN
GO 
USE QUANLIQUYTUTHIEN
GO
--PROCEDURE

CREATE PROC SP_ten
   @ten_TENNV NVARCHAR(100)
AS 
BEGIN
   DECLARE @ten_MANV CHAR(10);
   SET @ten_MANV = 'NV001';
   IF (@ten_MANV = 'NV002')
      SET @ten_TENNV =N'Nguyễn Thị Thu Hồng';
	else 
	SET @ten_TENNV =N'Nguyễn Thị Thu Cẩm';
end

CREATE PROC SP_THEMDOITUONG
  ( @THEMDOITUONG_MADOITUONG CHAR(10),@THEMDOITUONG_TENDOITUONG NVARCHAR(100))
  AS 
  BEGIN
   