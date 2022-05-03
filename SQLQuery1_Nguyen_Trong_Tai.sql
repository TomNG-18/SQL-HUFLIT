CREATE DATABASE QL_SINHVIEN
USE QL_SINHVIEN
CREATE TABLE KETQUA
(
	MaSV char (3),
	MaMH char (2),
	LanThi Tinyint,
	Diem Decimal(4,2),
	constraint PK_KETQUA primary key (MaSV,MaMH,LanThi)
)
create table DMKHOA
(
	MaKhoa char(2) constraint PK_Khoa primary key,
	TenKhoa nVarChar(20),
)
create table DMMH
(
	MaMH char(2) constraint PK_DMMH primary key,
	TenMH nVarchar(30),
	SoTiet Tinyint,
)
create table DMSV
(
	MaSV char(3) constraint PK_DMSV primary key,
	HoSV nvarchar(30),
	TenSV Nvarchar(10),
	Phai bit,
	NgaySinh Date,
	NoiSinh nvarchar(25),
	MaKH char(2),
	HocBong float,
)


INSERT INTO KETQUA(MaSV, MaMH, LanThi, Diem)
VALUES('A01', '01', 1, 3),
('A01', '01', 2, 6),
('A01', '02', 2, 6),
('A01', '03', 1, 5),
('A02', '01', 1, 4.5),
('A02', '01', 2, 7),
('A02', '03', 1, 10),
('A02', '05', 1, 9),
('A03', '01', 1, 2),
('A03', '01', 2, 5),
('A03', '03', 1, 2.5),
('A03', '03', 2, 4),
('A04', '05', 2, 10),
('B01', '01', 1, 7),
('B01', '03', 1, 2.5),
('B01', '03', 2, 5),
('B02', '02', 1, 6),
('B02', '04', 1, 10)

INSERT INTO DMMH(MaMH, TenMH, SoTiet)
VALUES ('01', N'Cơ sở dữ liệu', 45),
('02',N'Trí tuệ nhân tạo', 43),
('03',N'Truyền tin', 40),
('04',N'Đồ hoạ', 60),
('05',N'Văn phạm', 35),
('06',N'Kỹ thuật lập trình', 45)

INSERT INTO DMKHOA(MaKhoa, TenKhoa)
VALUES('AV', N'Anh Văn'),
('TH', N'Tin học'), 
('TR', N'Triết học'),
('VL', N'Vật lý')

INSERT INTO DMSV(MaSV, HoSV, TenSV, Phai, NgaySinh, NoiSinh, MaKH, HocBong)
VALUES('A01',N'Nguyễn Thị', N'Hải', 1, '02/23/1993', N'Hà Nội', 'TH', 130000),
('A02', N'Trần Văn', N'Chính', 0, '12/24/1992', N'Bình Định','VL', 130000),
('A03', N'Lê Thu Bạch', N'Yến', 1, '02/21/1993', N'Tp HCM','TH', 170000),
('A04', N'Trần Anh', N'Tuấn', 0, '12/20/1994', N'Hà Nội','AV', 80000),
('B01', N'Trần Thanh', N'Mai', 1, '08/12/1993', N'Hải Phòng','TR', 0),
('B02', N'Trần Thị Thu', N'Thuỷ', 1, '01/02/1994', N'Tp HCM','AV', 0)

alter table KETQUA add 
	constraint FK_KetQua_SinhVien foreign key(MaSV) references DMSV(MaSV),
	constraint FK_KetQua_DMMH foreign key(MaMH) references DMMH(MaMH)
alter table DMSV add 	
	constraint FK_DMSV_DMKHOA foreign key(MaKH) references DMKHOA(MaKhoa)
	
-- Kiểm tra các bảng: 
sp_tables DMMH
--Kiểm tra cấu trúc bảng: 
sp_columns DMMH
-- Kiểm tra khóa chính: 
sp_pkeys KETQUA
--Kiểm tra các ràng buộc trong bảng: 
sp_helpconstraint DMSV
sp_help 'dbo.DMSV'

--3.1 Thêm vào DMKHOA thuộc tính NamTL(năm thành lập) có kiểu dữ liệu là int.
ALTER TABLE DMKHOA ADD NamTL int
--3.2 Thay đổi kiểu dữ liệu NamTL thành smallInt
ALTER TABLE DMKHOA
ALTER COLUMN NamTL smallint
--3.3 Đổi tên NamTL thành NamThanhLap
EXEC sp_rename 'DMKHOA.NamTL', 'NamThanhLap'
--3.4 Xóa thuộc tính NamThanhLap
ALTER TABLE DMKHOA DROP COLUMN NamThanhLap
--3.5 Xóa ràng buộc khóa ngoại giữa sinh viên và khoa
ALTER TABLE DMSV DROP FK_DMSV_KHOA
--(chú ý: fk_dmsv_khoa là tên khóa ngoại do người dùng đặt)
--3.6 Tạo ràng buộc khóa ngoại giữa sinh viên và khoa
ALTER TABLE DMSV ADD CONSTRAINT FK_DMSV_KHOA FOREIGN
KEY(MaKH) REFERENCES DMKHOA (MaKH)

--4.1. Thêm tất cả dữ liệu bằng lệnh insert.
--Câu lệnh: 
INSERT INTO DMMH
VALUES ('01', N'Cơ sở dứ liệu', 45)
--4.2. Cập nhật số tiết của môn Văn phạm thành 45 tiết.
--Câu lệnh: 
UPDATE DMMH
SET SoTiet = 45
WHERE TenMH = N'Văn phạm'
--4.3. Cập nhật tên của sinh viên Trần Thanh Mai thành Trần Thanh Kỳ.
UPDATE DMSV
SET TenSV = N'Kỳ'
WHERE MaSV = 'B01'
--4.4. Cập nhật phái của sinh viên Trần Thanh Kỳ thành phái Nam.
UPDATE DMSV
SET Phai = 0
WHERE MaSV = 'B01'
--4.5. Cập nhật ngày sinh của sinh viên Trần thị thu Thuỷ thành 05/07/1997.
UPDATE DMSV
SET NgaySinh = 1997-07-05
WHERE MaSV = 'B02'
--4.6. Tăng học bổng cho tất cả những sinh viên có mã khoa “AV” thêm 100000.
--Câu lệnh: 
UPDATE DMSV
SET HocBong = HocBong + 100000
WHERE MaKH = 'AV'
--4.7. Xoá tất cả những dòng có điểm thi lần 2 nhỏ nhơn 5 trong bảng KETQUA.
--Câu lệnh: 
DELETE FROM KETQUA
WHERE LANTHI = 2 AND DIEM < 5

--1.1. Danh sách các môn học có tên bắt đầu bằng chữ T, gồm các thông tin: Mã môn, Tên
--môn, Số tiết.
--Câu lệnh: 
SELECT MaMH, TenMH, SoTiet
FROM DMMH
WHERE TenMH like N'T%'
--1.2. Liệt kê danh sách những sinh viên có chữ cái cuối cùng trong tên là I, gồm các thông
--tin: Họ tên sinh viên, Ngày sinh, Phái.
SELECT  HoSV, TenSV, NgaySinh, Phai
FROM DMSV
WHERE TenSV LIKE N'%i%'
--1.3. Danh sách những khoa có ký tự thứ hai của tên khoa có chứa chữ N, gồm các thông
--tin: Mã khoa, Tên khoa.
SELECT MaKhoa, TenKhoa
FROM DMKHOA
WHERE TenKhoa LIKE N'%_n'
--1.4. Liệt kê những sinh viên mà họ có chứa chữ Thị.
SELECT MaSV, HoSV, TenSV
FROM DMSV
WHERE HoSV LIKE N'%Thị%'
--1.5. Cho biết danh sách những sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ a
--đến m, gồm các thông tin: Mã sinh viên, Họ tên sinh viên, Phái, Học bổng.
SELECT MaSV, HoSV, TenSV, Phai, HocBong  
FROM DMSV
WHERE TenSV LIKE N'[A-M%]'
--1.6. Liệt kê các sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội, gồm các thông
--tin: Họ tên sinh viên, Mã khoa, Nơi sinh, Học bổng.
SELECT  HoSV +' '+TenSV AS HoTen, MaSV, NoiSinh, HocBong  
FROM DMSV
WHERE HocBong >= 150000 and NoiSinh = N'HÀ NỘI'

--1.7. Danh sách các sinh viên của khoa AV văn và khoa VL, gồm các thông tin: Mã sinh
--viên, Mã khoa, Phái.
SELECT MaSV, MaKH, Phai 
FROM DMSV
WHERE MaKH = 'AV' OR MaKH = 'VL'
--1.8. Cho biết những sinh viên có ngày sinh từ ngày 01/01/1992 đến ngày 05/06/1993
--gồm các thông tin: Mã sinh viên, Ngày sinh, Nơi sinh, Học bổng.
SELECT MaSV, NgaySinh, NoiSinh, HocBong
FROM DMSV
WHERE NgaySinh BETWEEN '01/01/1992 ' AND '05/06/1993'
--1.9. Danh sách những sinh viên có học bổng từ 80.000 đến 150.000, gồm các thông tin:
--Mã sinh viên, Ngày sinh, Phái, Mã khoa.
SELECT MaSV, NgaySinh, Phai, MaKH
FROM DMSV
WHERE HocBong BETWEEN 80000 AND 150000
--1.10. Cho biết những môn học có số tiết lớn hơn 30 và nhỏ hơn 45, gồm các thông tin: Mã
--môn học, Tên môn học, Số tiết.
SELECT MaMH, TenMH, SoTiet
FROM DMMH
WHERE SoTiet > 30 AND SoTiet < 45
--1.11. Liệt kê những sinh viên nam của khoa Anh văn và khoa tin học, gồm các thông tin:
--Mã sinh viên, Họ tên sinh viên, tên khoa, Phái.
SELECT MaSV, HoSV, TenSV, TenKhoa, Phai
FROM DMKHOA, DMSV
WHERE DMKHOA.MaKhoa = DMSV.MaKH 
AND
      Phai = 0 AND 
	  (TenKhoa = N'Anh văn' OR TenKhoa = N'Tin học')
--1.12. Liệt kê những sinh viên có điểm thi môn sơ sở dữ liệu nhỏ hơn 5, gồm thông tin: Mã
--sinh viên, Họ tên, phái, điểm
SELECT DMSV.MaSV, HoSV, TenSV, Phai, Diem
FROM KETQUA, DMSV, DMMH
WHERE KETQUA.MaSV = DMSV.MaSV 
AND KETQUA.MaMH = DMMH.MaMH
AND TenMH = N'Cơ sở dứ liệu' AND Diem < 5
--1.13. Liệt kê những sinh viên học khoa Anh văn mà không có học bổng, gồm thông tin:
--Mã sinh viên, Họ và tên, tên khoa, Nơi sinh, Học bổng.
SELECT MASV, HOSV, TENSV, TENKHOA, NOISINH, HOCBONG
FROM DMSV, DMKHOA
WHERE DMSV.MAKH = DMKHOA.MAKHOA AND TENKHOA = N'Anh Văn' AND HOCBONG = 0
----------------------------------------------------------------------------------


--2. Order by (Sắp xếp)
--2.1. Cho biết danh sách những sinh viên mà tên có chứa ký tự nằm trong khoảng từ a đến
--m, gồm các thông tin: Họ tên sinh viên, Ngày sinh, Nơi sinh. Danh sách được sắp
--xếp tăng dần theo tên sinh viên.
--Câu lệnh: 
--giảm dần
SELECT HoSV+ ' ' +TenSV [Họ Tên] , NgaySinh [Ngày Sinh], NoiSinh [Nơi Sinh]
FROM DMSV
WHERE TenSV like '%[a-m]%'
ORDER BY TenSV DESC
--Tăng dần
SELECT HoSV+ ' ' +TenSV [Họ Tên] , NgaySinh [Ngày Sinh], NoiSinh [Nơi Sinh]
FROM DMSV
WHERE TenSV like '%[a-m]%'
ORDER BY TenSV 
--2.2. Liệt kê danh sách sinh viên, gồm các thông tin sau: Mã sinh viên, Họ sinh viên, Tên
--sinh viên, Học bổng. Danh sách sẽ được sắp xếp theo thứ tự Mã sinh viên tăng dần.
SELECT MaSV [Mã sinh viên], HoSV+ ' ' +TenSV [Họ Tên], HocBong [Học Bổng]
FROM DMSV
ORDER BY MaSV
--2.3. Thông tin các sinh viên gồm: Họ tên sinh viên, Ngày sinh, Học bổng. Thông tin sẽ
--được sắp xếp theo thứ tự Ngày sinh tăng dần và Học bổng giảm dần.
SELECT MaSV [Mã sinh viên], HoSV+ ' ' +TenSV [Họ Tên], HocBong [Học Bổng]
FROM DMSV
ORDER BY NgaySinh, HocBong DESC
--2.4. Cho biết danh sách các sinh viên có học bổng lớn hơn 100,000, gồm các thông tin:
--Mã sinh viên, Họ tên sinh viên, Mã khoa, Học bổng. Danh sách sẽ được sắp xếp theo
--thứ tự Mã khoa giảm dần.
--GIẢM DẦN
SELECT MaSV [Mã sinh viên], HoSV+ ' ' +TenSV [Họ Tên], HocBong [Học Bổng], MaKH
FROM DMSV
WHERE HocBong > 100000
ORDER BY MaKH DESC
--TĂNG DẦN
SELECT MaSV [Mã sinh viên], HoSV+ ' ' +TenSV [Họ Tên], HocBong [Học Bổng], MaKH
FROM DMSV
WHERE HocBong > 100000
ORDER BY MaKH

--3. Truy vấn sử dụng hàm: year, month, day, getdate, case, ….
--3.1. Danh sách sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02, gồm các thông tin:
--Họ sinh viên, Tên sinh viên, Nơi sinh, Ngày sinh.
--Câu lệnh: 
SELECT HoSV, TenSV, NoiSinh, NgaySinh
FROM DMSV
WHERE NoiSinh like N'Hà Nội' AND MONTH(NgaySinh) = 2
--3.2. Cho biết những sinh viên có tuổi lớn hơn 20, thông tin gồm: Họ tên sinh viên, Tuổi,
--Học bổng.
--Hướng dẫn: Tuoi = YEAR(GETDATE()) - YEAR(NgaySinh)
SELECT HoSV+ ' ' +TenSV [Họ Tên],YEAR(GETDATE()) - YEAR(NgaySinh)  [Tuổi], HocBong [Học Bổng]
FROM DMSV
WHERE  YEAR(GETDATE()) - YEAR(NgaySinh) > 20

--3.3. Danh sách những sinh viên có tuổi từ 20 đến 25, thông tin gồm: Họ tên sinh viên,
--Tuổi, Tên khoa.
SELECT HoSV+ ' ' +TenSV [Họ Tên],YEAR(GETDATE()) - YEAR(NgaySinh)  [Tuổi], TenKhoa [Tên Khoa]
FROM DMSV, DMKHOA
WHERE DMSV.MaKH = DMKHOA.MaKhoa AND YEAR(GETDATE()) - YEAR(NgaySinh) BETWEEN 25 AND 30

--3.4. Danh sách sinh viên sinh vào mùa xuân năm 1990, gồm các thông tin: Họ tên sinh
--viên, Phái, Ngày sinh. (dùng hàm datepart(“q”,ngaysinh))

SELECT HoSV+ ' ' +TenSV [Họ Tên] ,Phai [Phai], NgaySinh [Ngày Sinh]
FROM DMSV
WHERE datepart("q", NgaySinh) = 1 AND YEAR(NgaySinh) = 1993

--3.5. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Phái, Mã
--khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá
--trị của học bổng lớn hơn 150,000 và ngược lại hiển thị là “Mức trung bình”
--Câu lệnh: 
SELECT MaSV, Phai, MaKH,
MucHocBong = CASE 
				WHEN HocBong > 100000 THEN N'Học bổng cao' 
				ELSE N'Mức trung bình' 
			 END
FROM DMSV
--3.6. Cho biết kết quả điểm thi của các sinh viên, gồm các thông tin: Họ tên sinh viên, Mã
--môn học, lần thi, điểm, kết quả (nếu điểm nhỏ hơn 5 thì rớt ngược lại đậu).
SELECT HoSV+ ' ' +TenSV [Họ Tên], MaMH [Mã môn học], LanThi [Lần Thi], Diem [Điểm],
[Kết quả] = CASE 
			WHEN Diem < 5 THEN N'Rớt' ELSE N'Đậu' 
         END
FROM KETQUA KQ, DMSV SV
WHERE KQ.MaSV = SV.MaSV 

--4. Truy vấn sử dụng hàm kết hợp: max, min, count, sum, avg và gom nhóm
--4.1. Cho biết tổng số sinh viên của toàn trường.Trường ĐH Ngoại Ngữ - Tin Học

--Câu lệnh:
SELECT Count(*) AS SLSV
FROM DMSV

--4.2. Cho biết tổng sinh viên và tổng sinh viên nữ.
SELECT Count(*) AS SLSV, N'Sinh viên nữ' = sum(CASE Phai WHEN 1 then 1 else 0 END)
FROM DMSV 

--4.3. Cho biết tổng số sinh viên của từng khoa.
Câu lệnh: 
SELECT s.MaKH, TenKhoa, COUNT(distinct MaSV) As SoSV
FROM DMSV s, DMKHOA k
WHERE s.MaKH = k.MaKhoa
GROUP BY s.MaKH, TenKhoa
--4.4. Cho biết số lượng sinh viên học từng môn (dùng Distinct loại trùng nhau)
--Câu lệnh: 
SELECT M.MaMH, TenMH, COUNT(Distinct K.MaSV) As SoSV
FROM DMMH M, KETQUA K
WHERE M.MaMH = K.MaMH
GROUP BY M.MaMH, TenMH
--4.5. Cho biết số lượng môn học mà mỗi sinh viên đã học.
SELECT s.MaSV ,HoSV +' '+ TenSV [Họ và Tên], Count(distinct k.MaMH) as SoMH
FROM DMSV s, KETQUA k
WHERE k.MaSV = s.MaSV
GROUP BY s.MaSV,HoSV, TenSV
--4.6. Cho biết học bổng cao nhất của mỗi khoa.
SELECT s.MaKH, k.TenKhoa ,MAX(HocBong)
FROM DMSV s, DMKHOA k
WHERE s.MaKH = k.MaKhoa
GROUP BY MaKH, TenKhoa
--4.7. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa.
--(Hướng dẫn: dùng SUM kết hợp với CASE...)
SELECT K.MaKhoa,TenKhoa,
SUM(CASE WHEN Phai = 0 THEN 1 ELSE 0 END ) AS TNAM,
SUM(CASE WHEN Phai = 1 THEN 1 ELSE 0 END ) AS TNU
FROM DMKHOA K,DMSV SV
WHERE K.MaKhoa= SV.MaKH
GROUP BY K.MaKhoa,TenKhoa
--4.8. Cho biết số lượng sinh viên theo từng độ tuổi.
SELECT YEAR(getdate()) - YEAR(NgaySinh) As TUOI, Count(MaSV) [Số Sinh viên]
FROM DMSV
GROUP BY YEAR(getdate()) - YEAR(NgaySinh)
--4.9. Cho biết số lượng sinh viên đậu và số lượng sinh viên rớt của từng môn trong lần thi 1
SELECT TenMH, 'Số sinh viên Đậu'=sum(case when k.Diem >= 5 then 1 else 0 end ),
'Số sinh viên Rớt'=sum(case when k.Diem < 5 then 1 else 0 end )
FROM KETQUA k, DMMH m
WHERE k.MaMH = m.MaMH
GROUP BY TenMH


--5. Truy vấn theo điều kiện gom nhóm.
-- Điều kiện trên nhóm
--SELECT <danh sách các cột>
--FROM <danh sách các bảng>
--WHERE <điều kiện>
--GROUP BY <danh sách các cột gom nhóm>
--HAVING <điều kiện trên nhóm>
--5.1. Cho biết năm sinh nào có 2 sinh viên đang theo học tại trường.
--Câu lệnh: 

SELECT YEAR(NgaySinh) as NamSinh
FROM DMSV
GROUP BY YEAR(NgaySinh)
HAVING COUNT(MaSV) = 2 

--5.2. Cho biết nơi nào có hơn 2 sinh viên đang theo học tại trường.
SELECT NoiSinh
FROM DMSV
GROUP BY NoiSinh
HAVING COUNT(MaSV) = 2
--5.3. Cho biết môn nào có trên 3 sinh viên dự thi.
SELECT TenMH [Tên Môn Học], COUNT(distinct k.MaSV)
FROM KETQUA k, DMMH m
WHERE k.MaMH = m.MaMH
GROUP BY TenMH
HAVING COUNT(m.MaMH) > 3

--5.4. Cho biết sinh viên thi lại trên 2 lần.
SELECT HoSV+' '+TenSV [Họ và tên]
FROM DMSV s, KETQUA k
WHERE k.MaSV = s.MaSV
and LanThi > 2
GROUP BY  HoSV, TenSV


--5.5. Cho biết sinh viên nam có điểm trung bình lần 1 trên 7.0
SELECT HoSV+' '+TenSV [Họ và tên]
FROM DMSV s, KETQUA k
WHERE  k.MaSV = s.MaSV
and LanThi = 1 and Phai = 0
GROUP BY HoSV, TenSV
HAVING AVG(Diem) > 7
--5.6. Cho biết danh sách sinh viên rớt trên 2 môn ở lần thi 1.
SELECT HoSV+' '+TenSV [Họ và tên]
FROM DMSV s, KETQUA k 
WHERE k.MaSV = s.MaSV
and LanThi = 1 and Diem < 5
GROUP BY HoSV, TenSV
HAVING COUNT(distinct MaMH) > 2
--5.7. Cho biết khoa nào có nhiều hơn 2 sinh viên nam.
SELECT TenKhoa [Tên Khoa]
FROM DMSV s, DMKHOA m
WHERE s.MaKH = m.MaKhoa
and Phai = 0
GROUP BY TenKhoa
HAVING COUNT(MaSV) > 2

--5.8. Cho biết khoa có 2 sinh đạt học bổng từ 100.000 đến 200.000.
SELECT TenKhoa [Tên Khoa]
FROM DMSV s, DMKHOA m
WHERE s.MaKH = m.MaKhoa
and HocBong between 100000 and 200000
GROUP BY TenKhoa
HAVING COUNT(MaSV) = 2
--5.9. Cho biết sinh viên nam học trên từ 3 môn trở lên
SELECT   HoSV+' '+TenSV [Họ và tên]
FROM DMSV s, KETQUA k
WHERE s.MaSV = k.MaSV
and Phai = 0
GROUP BY HoSV, TenSV
HAVING COUNT(distinct MaMH) >= 3
--5.10. Cho biết sinh viên có điểm trung bình lần 1 từ 7 trở lên nhưng không có môn nào
--dưới 5.
SELECT   HoSV+' '+TenSV [Họ và tên]
FROM DMSV s, KETQUA k
WHERE s.MaSV = k.MaSV
and LanThi = 1
GROUP BY HoSV, TenSV
HAVING AVG(Diem)>7
--5.11. Cho biết môn không có sinh viên rớt ở lần 1. (rớt là điểm <5)
SELECT TenMH [Tên Môn Học]
FROM KETQUA k, DMMH m
WHERE k.MaMH = m.MaMH
and LanThi = 1
GROUP BY TenMH
HAVING AVG(Diem) >= 5
--5.12. Cho biết sinh viên đăng ký học hơn 3 môn mà thi lần 1 không bị rớt môn nào.
SELECT   HoSV+' '+TenSV [Họ và tên]
FROM DMSV s, KETQUA k
WHERE s.MaSV = k.MaSV
and LanThi = 1
GROUP BY HoSV, TenSV
HAVING COUNT(distinct MaKH) > 3 and AVG(Diem)>7

--6.1.  Cho biết sinh viên nào có học bổng cao nhất.
--B1. Tìm giá trị học bổng cao nhất (trả về một giá trị duy nhất).
--B2. Lấy những sinh viên có học bổng bằng học bổng B1
--Câu lệnh:   
SELECT * FROM DMSV
WHERE HocBong = 
(
SELECT MAX(HocBong) 
FROM DMSV
)
--6.2.  Cho biết những sinh viên có điểm thi lần 1 môn cơ sở dữ liệu cao nhất.
select *
from DMSV
where MaSV = 
(
	select  MaSV [Mã Sinh viên] 
	from	KETQUA k, DMMH m
	where	k.MaMH = m.MaMH
	and		LanThi = 1
	and		TenMH = N'Cơ sở dữ liệu'
	and		Diem =
	(	
		select  MAX(Diem)
		from	KETQUA k, DMMH m
		where	k.MaMH = m.MaMH
		and		LanThi = 1
		and		TenMH = N'Cơ sở dữ liệu'
	)
)
--6.3.  Cho biết sinh viên khoa anh văn có tuổi lớn nhất.
select	MaSV [Mã Sinh viên], HoSV + ' ' + TenSV [Họ Tên]
from	DMSV, DMMH
where	
TenMH = N'Anh Văn'
and YEAR(NgaySinh) = 
(
		select	MIN(Year(NgaySinh))
		from	DMSV s, DMMH m
		where TenMH = N'Anh Văn'
)
--6.4.  Cho biết những sinh viên có cùng nơi sinh với sinh viên có mã số “A01”
select MaSV
from DMSV
where NoiSinh = 
(
	select NoiSinh
	from DMSV
	where MaSV = 'A01'
)

select MaSV
from DMSV s1
where NoiSinh = 
(
	select NoiSinh
	from DMSV s2
	where MaSV = 'A01'
	and s1.MaSV <> s2.MaSV
)
--6.5.  Cho biết sinh viên khoa anh văn học môn văn phạm có điểm thi lần 1 thấp nhất.

select s.MaSV [Mã Sinh viên], HoSV + ' ' + TenSV [Họ Tên]
from DMKHOA k, DMSV s, DMMH m, KETQUA kq
where 
kq.MaMH = m.MaMH
and s.MaSV = kq.MaSV
and k.MaKhoa = m.MaMH
and LanThi = 1
and TenKhoa = N'Anh Văn'
and TenMH = N'Văn Phạm'
and Diem = 
(
	select MIN(Diem)
	from DMKHOA k, DMSV s, DMMH m, KETQUA kq
	where LanThi  = 1
	and kq.MaMH = m.MaMH
	and s.MaSV = kq.MaSV
	and k.MaKhoa = m.MaMH
	and TenKhoa = N'Anh Văn'
	and TenMH = N'Văn Phạm'
)
--6.6.  Cho biết  sinh viên  thi  môn cơ sở dữ liệu lần 2 có điểm bằng  điểm  cao  nhất của sinh 
--viên thi môn cơ sở dữ liệu lần 1.
select distinct s.MaSV [Mã Sinh viên], HoSV + ' ' + TenSV [Họ Tên]
from 	DMKHOA k, DMSV s, DMMH m, KETQUA kq
where 
	kq.MaMH = m.MaMH
and kq.MaMH = m.MaMH
and s.MaSV = kq.MaSV
and LanThi = 2
and TenMH = N'Cơ sở dữ liệu'
and Diem = 
(
	select 	MAX(Diem)
	from 	DMKHOA k, DMSV s, DMMH m, KETQUA kq
	where 	LanThi  = 1
	and		kq.MaMH = m.MaMH
	and 	s.MaSV = kq.MaSV
	and 	TenMH = N'Cơ sở dữ liệu'
)
--6.7.  Cho biết sinh viên có điểm thi môn cơ sở dữ liệu lần 2 lớn hơn tất cả điểm thi lần 1 
--môn cơ sở dữ liệu của những sinh viên khác.
select s.MaSV [Mã Sinh viên], HoSV + ' ' + TenSV [Họ Tên]
from DMKHOA k, DMSV s, DMMH m, KETQUA kq
where 
kq.MaMH = m.MaMH
and kq.MaMH = m.MaMH
and s.MaSV = kq.MaSV
and LanThi = 2
and TenMH = N'Cơ sở dữ liệu'
and Diem > all
(
	select Diem
	from DMKHOA k, DMSV s, DMMH m, KETQUA kq
	where LanThi  = 1
	and	kq.MaMH = m.MaMH
	and s.MaSV = kq.MaSV
	and TenMH = N'Cơ sở dữ liệu'
)
--6.8.  Cho biết những sinh viên có học bổng lớn hơn tất cả học bổng của sinh viên thuộc 
--khoa anh văn
select s.MaSV [Mã Sinh viên], HoSV + ' ' + TenSV [Họ Tên]
from DMKHOA k, DMSV s
where 
k.MaKhoa = s.MaKH
and TenKhoa = N'Anh Văn'
and HocBong > all
(
	select HocBong
	from DMKHOA k, DMSV s
	where 
	k.MaKhoa = s.MaKH
	and TenKhoa = N'Anh Văn'
)
--7.1.  Cho biết sinh viên có nơi sinh cùng với Hải.
--B1. Tìm nơi sinh của Hải (câu con này trả về nhiều giá trị vì có thể nhiều người tên 
--Hải)
--B2. Tìm những sinh viên có nơi sinh giống với một trong những nơi sinh ở B1
--Câu lệnh:   
SELECT * FROM DMSV 
WHERE NoiSinh IN 
(
	SELECT NoiSinh
	FROM DMSV
	WHERE TENSV like N'Hải'
)
AND TenSV not like N'Hải'

--7.2.  Cho biết những sinh viên  có  học bổng lớn hơn tất cả học bổng của sinh viên thuộc 
--khoa anh văn.
select distinct s.MaSV [Mã Sinh viên], HoSV + ' ' + TenSV [Họ Tên]
from DMKHOA k, DMSV s
where 
HocBong > all
(
	select HocBong
	from DMKHOA k, DMSV s
	where 
	k.MaKhoa = s.MaKH
	and TenKhoa = N'Anh Văn'
)
--7.3.  Cho biết những sinh viên có học bổng lớn hơn bất kỳ học bổng của sinh viên học 
--khóa anh văn.
select distinct s.MaSV [Mã Sinh viên], HoSV + ' ' + TenSV [Họ Tên]
from DMKHOA k, DMSV s
where 
HocBong > any
(
	select HocBong
	from DMKHOA k, DMSV s
	where 
	k.MaKhoa = s.MaKH
	and TenKhoa = N'Anh Văn'
)
--7.4.  Cho biết sinh viên  có điểm thi môn cơ sở dữ liệu lần 2 lớn hơn tất cả điểm thi lần  1 
--môn cơ sở dữ liệu của những sinh viên khác.
select *
from DMMH m, KETQUA kq
where 
kq.MaMH = m.MaMH
and kq.MaMH = m.MaMH
and LanThi = 2
and TenMH = N'Cơ sở dữ liệu'
and Diem > all
(
	select Max(Diem)
	from DMMH m, KETQUA kq
	where LanThi  = 1
	and kq.MaMH = m.MaMH
	and TenMH = N'Cơ sở dữ liệu'
)
--7.5.  Với mỗi sinh viên cho biết điểm thi cao nhất của môn tương ứng.
SELECT SV.MASV,HOSV+' '+TENSV AS HOTEN, TENMH, DIEM
FROM KETQUA K1,DMSV SV,DMMH MH
WHERE SV.MASV=K1.MASV
AND K1.MAMH=MH.MAMH
AND DIEM>=ALL
(
	SELECT DIEM
	FROM KETQUA K2
	WHERE K1.MASV=K2.MASV
)
--7.6.  Cho biết môn nào có nhiều sinh viên học nhất.
SELECT MH.MaMH,TenMH,COUNT(DISTINCT MaSV) AS SLSV
FROM KETQUA KQ,DMMH MH
WHERE KQ.MaMH=MH.MaMH
GROUP BY MH.MaMH,TenMH
HAVING COUNT(DISTINCT MASV)>=ALL
(
	SELECT COUNT(DISTINCT MaSV)
	FROM KETQUA
	GROUP BY MaMH
)
--7.7.  Cho biết những khoa có đông sinh viên nam học nhất. 
--Trường ĐH Ngoại Ngữ - Tin Học
--Lê Thị Minh Nguyện  19

--7.8.  Cho biết khoa nào có đông sinh viên nhận học bổng nhất và khoa nào khoa nào có ít 
--sinh viên nhận học bổng nhất.
SELECT	TenKhoa [Tên Khoa]
FROM DMKHOA
WHERE	MaKhoa IN
(
	SELECT	MaKH
	FROM	DMSV
	WHERE	HocBong > 0
	GROUP BY MaKH
	HAVING COUNT(*) >= All
	(
		SELECT COUNT(*)
		FROM DMSV
		WHERE	HocBong > 0
		GROUP BY MaKH
	)

UNION
	SELECT	MaKH
	FROM	DMSV
	WHERE	HocBong > 0
	GROUP BY MaKH
	HAVING COUNT(*) <= All
	(
		SELECT COUNT(*)
		FROM DMSV
		WHERE	HocBong > 0
		GROUP BY MaKH
	)
)
--7.9.  Cho biết môn nào có nhiều sinh viên rớt lần 1 nhiều nhất.
SELECT MaMH [Mã Môn Học], TenMH
FROM DMMH
WHERE MaMH IN
(
	SELECT MaMH
	FROM KETQUA
	WHERE Diem < 5
	and LanThi = 1
	GROUP BY MaMH
	HAVING COUNT(distinct MaSV) >= All
	(
		SELECT COUNT(distinct MaSV)
		FROM KETQUA
		WHERE Diem < 5
		and LanThi = 1
		GROUP BY MaMH
	)
)


--7.10.  Cho biết 3 sinh viên có học nhiều môn nhất.
--Câu lệnh: 
SELECT TOP 3 s.MaSV, HoSV, TenSV, COUNT(DISTINCT(MaMH)) as SoMon
FROM DMSV s, KETQUA k
WHERE s.MASV = k.MASV
GROUP BY s.MaSV, HoSV, TenSV
ORDER BY COUNT(DISTINCT(MaMH)) DESC

--8.1  Cho biết sinh viên chưa thi môn cơ sở dữ liệu.
SELECT distinct MaSV, HoSV, TenSV
FROM DMSV 
WHERE MaSV NOT IN 
( 
	SELECT distinct k.MaSV
	FROM DMMH m, KETQUA k
	WHERE TenMH = N'Cơ sở dữ liệu'
)

--8.2.  Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2.
select 	s.MaSV
from 	KETQUA kq, DMSV s
where 	LanThi = 2
and 	kq.MaSV = s.MaSV
and 	kq.MaSV NOT IN
(
	select 	s.MaSV
	from 	KETQUA kq, DMSV s
	where 	LanThi = 1
	and 	kq.MaSV = s.MaSV
)
--8.3.  Cho biết môn nào không có sinh viên khoa anh văn học.
select 	TenMH
from 	DMMH
where MaMH not in
(
	select distinct MaMH
	from 	DMSV s, KETQUA kq, DMKHOA kh
	where 	s.MaKH = kh.MaKhoa
	and 	s.MaSV = kq.MaSV
	and 	TenKhoa = N'Anh Văn' 
)
--8.4.  Cho biết những sinh viên khoa anh văn chưa học môn văn phạm.
select distinct s.MaSV
from 	DMKHOA kh, KETQUA kq, DMSV s
where 	kh.MaKhoa = s.MaKH
and 	s.MaSV = kq.MaSV
and 	TenKhoa = N'Anh Văn'
and 	s.MaSV NOT IN
(
	select distinct s.MaSV
	from 	DMSV s, DMMH m, KETQUA kq, DMKHOA kh
	where 	s.MaSV = kq.MaSV
	and	  	kq.MaMH = m.MaMH
	and   	kh.MaKhoa = s.MaKH
	and 	TenKhoa = N'Anh Văn'
	and 	TenMH = N'Văn Phạm'
)
--8.5.  Cho biết những môn không có sinh viên rớt ở lần 1.
select 	TenMH
from 	DMMH
where 	MaMH NOT IN
(
	select distinct kq.MaMH
	from 			KETQUA kq, DMSV s, DMMH m
	where  			s.MaSV = kq.MaSV
	AND	   			kq.MaMH = m.MaMH
	AND    			Diem < 5
	AND    			LanThi = 1
)

--8.6. Cho biết những khoa không có sinh viên nữ.
SELECT TenKhoa [Tên Khoa]
FROM DMKHOA k
WHERE NOT EXISTS
(
	SELECT *
	FROM  DMSV s
	WHERE k.MaKhoa = s.MaKH
	AND Phai = 1
)
--8.7. Cho biết những sinh viên:
-- - Học khoa anh văn có học bổng hoặc
-- - Chưa bao giờ rớt.
SELECT 	SV.MaSV,HoSV,TenSV,SV.MaKH
FROM 	DMSV SV,DMKHOA K
WHERE 	SV.MaKH = K.MaKhoa
AND 	TenKhoa LIKE N'Anh Văn'
AND 	HocBong > 0
UNION
SELECT 	SV.MaSV,HoSV,TenSV,MaKH
FROM 	DMSV SV ,KETQUA K
WHERE 	SV.MaSV = K.MaSV
AND 	SV.MaSV NOT IN
(
	SELECT MaSV
	FROM KETQUA
	WHERE Diem < 5
)
--8.8. Cho biết những sinh viên:
-- - Không có học bổng hoặc
-- - Bị rớt môn học (sinh viên thi lần 1 bị rớt mà không thi lần 2 và sinh viên thi lần 2 bị
--rớt)
SELECT	MaSV, HoSV+' '+TenSV [Họ Tên SV]
FROM 	DMSV 
WHERE	HocBong = 0
UNION
SELECT 	s.MaSV, HoSV+' '+TenSV [Họ Tên SV]
FROM 	DMSV s, KETQUA kq
WHERE 	s.MaSV = kq.MaSV
AND		s.MaSV IN 
(
	SELECT MaSV
	FROM KETQUA
	WHERE Diem < 5
)
-- 9.1  Cho biết những môn được tất cả các sinh viên theo học. (những môn học mà không
--có sinh viên nào không không học)
SELECT *
FROM DMMH K1
WHERE NOT EXISTS 
(
	SELECT * FROM DMSV S
	WHERE NOT EXISTS
	(	
		SELECT *
		FROM KETQUA K2
		WHERE K2.MaSV = S.MaSV
			AND K2.MaMH = K1.MaMH
	)
)
-- 9.2 Cho biết những sinh viên học những môn giống sinh viên có mã số A02 học
SELECT distinct KQ.MASV,HOSV + ' ' + TENSV [HỌ VÀ TÊN] 
FROM DMSV, KETQUA KQ
WHERE DMSV.MASV = KQ.MASV and  EXISTS 
(
	SELECT distinct MAMH
	FROM KETQUA
	WHERE  MAMH = KQ.MAMH AND MASV = 'A02'
)


SELECT * FROM DMSV
SELECT * FROM DMKHOA
SELECT * FROM KETQUA
SELECT * FROM DMMH

DROP TABLE KETQUA
DROP TABLE DMSV
DROP TABLE DMMH
DROP TABLE DMKHOA

