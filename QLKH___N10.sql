create database QLKS__N10
use [QLKS__N10]


-----TẠO BẢNG------

---TẠO BẢNG KHÁCH HÀNG-----

create table KhachHang(
MaKH char(10) not null,
HoTenKH nvarchar(50),
SDTKH char(10),
DiaChiKH nvarchar(50),
GioiTinhKH bit,
NgaySinhKH date,
CMNDKH char(10),
constraint pk_KhachHang primary key (MaKH)
)


--- TẠO BẢNG PHÒNG--

Create table Phong(
MaPhong char(10) not null,
TenPhong nvarchar(50),
LoaiPhong nvarchar(30),
SLGiuong Int,
DonGiaP float,
ThoiDiemP date,
constraint pk_Phong primary key (MaPhong)
)


---TẠO BẢNG DỊCH VỤ

create table DichVu(
MaDV char(10) not null,
TenDV nvarchar(50),
DonGiaDV float,
DVTinh nvarchar(20),
constraint pk_DichVu primary key (MaDV)
)


---TẠO BẢNG NHÂN VIÊN

create table NhanVien(
MaNV char(10) not null,
TenNV nvarchar(50),
ChucVu nvarchar(30),
NgaySinhNV date,
GioiTinh bit,
SDTNV char(10),
DiaChiNV nvarchar(50),
EmailNV varchar(50),
CCCDNV char(10),
constraint pk_NhanVien primary key (MaNV)
)


---TẠO BẢNG THUÊ PHÒNG

create table BangThuePhong (
MaThuePhong char(10) not null,
NgayThueP date,
NgayTraP date,
NgayGiaHan date,
NgayDkThueP date,
SoNgayO int,
GhiChu nvarchar(50),
TinhTrangP nvarchar(20),
MaKH char (10),
MaNV char (10),
constraint pk_ThuePhong primary key (MaThuePhong),
constraint fk_ThuePhong_KhachHang foreign key ([MaKH]) references KhachHang([MaKH]),
constraint fk_ThuePhong_NhanVien foreign key ([MaNV]) references NhanVien([MaNV])
)

---TẠO BẢNG CHI TIẾT THUÊ PHÒNG

create table ChiTietThuePhong(
MaThuePhong char(10) not null,
MaPhong char(10) not null,
SLPhong int,
ThanhTienP float ,
constraint pk_CTTP primary key (MaThuePhong,MaPhong),
constraint fk_CTTP_BangThuePhong foreign key (MaThuePhong) references BangThuePhong(MaThuePhong),
constraint fk_CTTP_MaPhong foreign key (MaPhong) references Phong(MaPhong)
)

---TẠO BẢNG YÊU CẦU DV

create table YeuCauDV(
MaYCDV char(10) not null,
MaKH char(10),
MaNV char(10),
NgayYCDV date,
constraint pk_YeuCauDV primary key (MaYCDV),
constraint fk_YeuCauDV_MaNV foreign key (MaNV) references NhanVien(MaNV),
constraint fk_YeuCauDV_MaKH foreign key (MaKH) references KhachHang(MaKH)
)
---- THÊM THUỘC TÍNH TỔNG CỘNG DỊCH VỤ CHO BẢNG YÊU CẦU DỊCH VỤ
alter table [dbo].[YeuCauDV]
add TCDV float
---TẠO BẢNG CHI TIẾT YÊU CẦU DV

create table ChiTietYeuCauDV(
MaYCDV char(10) not null,
MaDV char(10) not null,
SLDV int,
ChiPhiDV float,
constraint pk_CTYCDV primary key (MaYCDV,MaDV),
constraint fk_CTYCDV_MaYCDV foreign key (MaYCDV) references YeuCauDV(MaYCDV),
constraint fk_CTYCDV_MaDV foreign key (MaDV) references DichVu(MaDV)
)


---TẠO BẢNG HÓA ĐƠN


CREATE TABLE HoaDon (
MaHoaDon CHAR(10) NOT NULL,
ChietKhau float,
TCHD float,
SoTienTTHD float,
NgayTTHD date,
MaKH CHAR(10),
MaNV char(10),
CONSTRAINT pk_HoaDon PRIMARY KEY (MaHoaDon),
CONSTRAINT fk_HoaDon_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
constraint fk_HoaDon_MaNV foreign key (MaNV) references NhanVien(MaNV)
);

---- thêm thuộc tính tình trạng phòng trong hóa đơn 
alter table [dbo].[HoaDon]
add TrangThaiTra nvarchar(30)


-- Bảng ChiTietHoaDon Thuê phòng

CREATE TABLE ChiTietHoaDonTP (
MaHoaDon CHAR(10) NOT NULL,
MaThuePhong CHAR(10), 
CONSTRAINT pk_ChiTietHoaDonTP PRIMARY KEY (MaHoaDon,MaThuePhong),
CONSTRAINT fk_ChiTietHoaDonTP_HoaDon FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
CONSTRAINT fk_ChiTietHoaDonTP_ThuePhong FOREIGN KEY (MaThuePhong) REFERENCES BangThuePhong(MaThuePhong)
);

-- Bảng ChiTietHoaDon Thuê phòng

CREATE TABLE ChiTietHoaDonYCDV (
MaHoaDon CHAR(10) NOT NULL,
MaYCDV CHAR(10),
CONSTRAINT pk_ChiTietHoaDonYCDV PRIMARY KEY (MaHoaDon,MaYCDV),
CONSTRAINT fk_ChiTietHoaDonYCDV_HoaDon FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
CONSTRAINT fk_ChiTietHoaDonYCDV_YeuCauDV FOREIGN KEY (MaYCDV) REFERENCES YeuCauDV(MaYCDV)
);


---KIỂM TRA KHÁCH HÀNG TRÊN 18 HAY KHÔNG---

alter table [dbo].[KhachHang]
add constraint chk_TUOIKH check ((year(getdate()) - year([NgaySinhKH])) > 18)


---KIỂM TRA NHÂN VIÊN TRÊN 18 HAY KHÔNG---

alter table [dbo].[NhanVien]
add constraint chk_TUOINV check ((year(getdate()) - year([NgaySinhNV])) > 18)



---KIỂM TRA ĐƠN VỊ TÍNH TRONG BẢNG DỊCH VỤ GỒM ('kg', 'suất','giờ','chai')

alter table [dbo].[DichVu]
add constraint chk_DVT check ([DVTinh] in ('kg', N'suất', N'giờ', 'chai'))

---KIỂM TRA NGÀY GIA HẠN PHỈA LỚN HƠN NGÀY TRẢ

alter table [dbo].[BangThuePhong]
add constraint chk_NGHann check ([NgayGiaHan] > [NgayTraP] OR [NgayGiaHan] IS NULL) 



---KIỂM TRA NGÀY TRẢ PHẢI LỚN HƠN NGÀY THUÊ

alter table [dbo].[BangThuePhong]
add constraint chk_NTra check ([NgayTraP] > [NgayThueP])


---KIỂM TRA SỐ LƯỢNG ĐƠN GIÁ > 0

alter table [dbo].[DichVu]
add constraint chk_DGDV check ([DonGiaDV] > 0)

--KIỂM TRA SỐ LƯỢNG PHẢI > 0

alter table [dbo].[ChiTietYeuCauDV]
add constraint chk_SLDV check ( [SLDV] > 0)

---KIỂM TRA NGÀY ĐĂNG KÝ THUÊ PHÒNG PHIAT >= NGÀY THUÊ PHÒNG

alter table [dbo].[BangThuePhong]
add constraint chk_NgayDKThueP check ([NgayDkThueP] <= [NgayThueP])



----NHẬP DỮ LIỆU----

----KHÁCH HÀNG---

insert into [dbo].[KhachHang] values
('KH1',N'Nguyễn Văn Qua','0905123456',N'193 Nguyễn Lương Bằng','1','2002/11/22','0483112135'),
('KH2',N'Đỗ Hữu Hòa','0905997111',N'194 Nguyễn Lương Bằng','1','2002/06/16','0483112111'),
('KH3',N'Nguyễn  Thị Khánh Hân','0905123456',N'193 Lê Duẩn','0','2003/08/16','0593112135'),
('KH4',N'Nguyễn Văn Vũ','0905300177',N'166 Nguyễn Văn Linh','1','1999/02/23','0493004222'),
('KH5',N'Trần Thị Thu Thảo','0383031857',N'193 Nguyễn Lương Bằng','0','2004/07/09','0483112155')

---NHÂN VIÊN---

insert into [dbo].[NhanVien] values
('NV1',N'Võ Thị An',N'Lễ Tân','2002/06/21','1','0363109964',N'33 Âu Cơ','thu02@gmail.com','0493002010'),
('NV2',N'Trần Văn Nga',N'Kế Toán','2000/11/20','0','0905123456',N'66 Âu Cơ','nga00@gmail.com','0493221100'),
('NV3',N'Nguyễn Minh Ngân',N'Phục Vụ','1996/06/21','0','0933402325',N'169 Tôn Đức Thắng','ngan96@gmail.com','0596225364'),
('NV4',N'Doãn Hải My',N'Lễ Tân','2001/02/01','1','0905364895',N'22 Âu Cơ','my01@gmail.com','0493002001'),
('NV5',N'Ngô Văn Hải',N'Bảo Vệ ','1992/06/03','1','0363109964',N'162 Âu Cơ','hai92@gmail.com','0223002010')


----DỊCH VỤ----
insert into [dbo].[DichVu] values
('DV1',N'giặt ủi',20000,'kg'),
('DV2',N'bơi lội',35000,N'giờ'),
('DV3',N'thức ăn',100000,N'suất'),
('DV4',N'thức uống',50000,'chai'),
('DV5',N'thuê xe',55000,N'giờ')
insert into [dbo].[DichVu] values
('DV6',N'massage',30000,N'giờ')


---PHÒNG----
insert into [dbo].[Phong] values
('MP1',N'P206',N'VIP',2,400000,'2023/12/20'),
('MP2',N'P101',N'BT',1,200000,'2024/01/20'),
('MP3',N'P302',N'VIP',2,400000,''),
('MP4',N'P208',N'BT',1,200000,''),
('MP5',N'P103',N'VIP',2,400000,'2023/12/25'),
('MP6',N'P202',N'BT',1,200000,'2024/02/14'),
('MP7',N'P201',N'VIP',2,400000,'')
insert into [dbo].[Phong] values
('MP8',N'P220',N'VIP',2,400000,'2023/12/20')


---BẢNG THUE PHÒNG---
insert into [dbo].[BangThuePhong] ( [MaThuePhong],[NgayThueP],[NgayTraP],[NgayGiaHan],[NgayDkThueP],[TinhTrangP],[MaKH],[MaNV]) values
('MTP1','2023/12/03','2023/12/05',Null,'2023/12/03',N'Chưa trả','KH1','NV1')
insert into [dbo].[BangThuePhong] ( [MaThuePhong],[NgayThueP],[NgayTraP],[NgayGiaHan],[NgayDkThueP],[TinhTrangP],[MaKH],[MaNV]) values
('MTP2','2023/12/03','2023/12/04','2023/12/05','2023/12/01',N'Chưa trả','KH2','NV1'),
('MTP4','2023/12/06','2023/12/10','2023/12/15','2023/12/05',N'Chưa trả','KH5','NV1'),
('MTP6','2023/12/05','2023/12/30',Null,'2023/12/03',N'Chưa trả','KH3','NV3')


delete from [dbo].[BangThuePhong]
delete from [dbo].[ChiTietThuePhong]
delete from [dbo].[ChiTietHoaDonTP]
---BẢNG CHI TIẾT THUÊ PHÒNG
insert into [dbo].[ChiTietThuePhong] ([MaThuePhong],[MaPhong],[SLPhong]) values 
('MTP1','MP1',1),
('MTP1','MP4',1),
('MTP2','MP5',1),
('MTP1','MP3',1),
('MTP4','MP2',1),
('MTP4','MP6',1),
('MTP6','MP7',1)
select * from [dbo].[Phong]


---BẢNG YÊU CẦU DV---
insert into [dbo].[YeuCauDV] ([MaYCDV],[MaKH],[NgayYCDV]) values
('YC1','KH1','2023/12/04'),
('YC2','KH2','2023/12/05'),
('YC3','KH3','2023/12/11'),
('YC4','KH5','2023/12/9')

delete from[dbo].[YeuCauDV] 
delete from  [dbo].[ChiTietYeuCauDV]
delete from [dbo].[ChiTietHoaDonYCDV]
---BẢNG CHI TIẾT YÊU CẦU DỊCH VỤ
insert into [dbo].[ChiTietYeuCauDV] ([MaYCDV],[MaDV],[SLDV]) values 
('YC1','DV1',3),
('YC1','DV2',3),
('YC1','DV3',3),
('YC2','DV2',2),
('YC3','DV1',4),
('YC3','DV5',4),
('YC3','DV3',4),
('YC4','DV2',1)

---BẢNG HÓA ĐƠN---
insert into [dbo].[HoaDon] ([MaHoaDon],[MaKH],[MaNV],[NgayTTHD]) values
('HD1','KH1','NV1','2023/12/05'),
('HD2','KH2','NV3','2023/12/05'),
('HD3','KH5','NV4','2024/01/15')
insert into [dbo].[HoaDon] ([MaHoaDon],[MaKH],[MaNV],[NgayTTHD]) values
('HD4','KH3','NV1','2023/12/30')
---BẢNG CHI TIẾT HÓA ĐƠN THUÊ PHÒNG---
insert into [dbo].[ChiTietHoaDonTP] ([MaHoaDon],[MaThuePhong]) values
('HD1','MTP1'),
('HD2','MTP2'),
('HD3','MTP4')

insert into [dbo].[ChiTietHoaDonTP] ([MaHoaDon],[MaThuePhong]) values
('HD4','MTP6')

---BẢNG CHI TIẾT HÓA ĐƠN YÊU CẦU DỊCH VỤ ---
insert into [dbo].[ChiTietHoaDonYCDV] ([MaHoaDon],[MaYCDV]) values
('HD1','YC1'),
('HD1','YC2'),
('HD2','YC3'),
('HD3','YC4')

select * from [dbo].[BangThuePhong]
select * from [dbo].[ChiTietThuePhong]
select * from [dbo].[YeuCauDV]
select * from [dbo].[ChiTietYeuCauDV]
select * from [dbo].[HoaDon]
select * from [dbo].[ChiTietHoaDonYCDV]
select * from [dbo].[ChiTietHoaDonTP]




					-------CÁC CÂU LỆNH UPDATE TÍNH CÁC BẢNG--------

					-------UPDATE BẢNG THUÊ PHÒNG--------

-------tính số ngày ở---

UPDATE [dbo].[BangThuePhong]
SET [SoNgayO] = CASE
    WHEN [NgayGiaHan] IS NULL THEN DATEDIFF(day, [NgayThueP], [NgayTraP])
    ELSE DATEDIFF(day, [NgayThueP], [NgayTraP]) - DATEDIFF(day, [NgayGiaHan], [NgayTraP])
    END
	
---tính thành tiền phòng
UPDATE [dbo].[ChiTietThuePhong]
SET [ThanhTienP] = [SoNgayO] * [SLPhong] * c.[DonGiaP]
FROM  [dbo].[BangThuePhong] a, [dbo].[ChiTietThuePhong] b, [dbo].[Phong] c
Where b.MaPhong=c.MaPhong and b.MaThuePhong=a.MaThuePhong


---- thêm thuộc tính Tổng cộng thuê phòng trong bảng thuê phòng
alter table [dbo].[BangThuePhong]
add TCTP float

-------- tính TONG CONG THUE PHONG TRONG BẢNG THUE PHÒNG
update [dbo].[BangThuePhong]
set [TCTP] = TC 
from [dbo].[BangThuePhong] a, (select [MaThuePhong], Sum([ThanhTienP]) as TC
												from [dbo].[ChiTietThuePhong]
												group by [MaThuePhong]) b
where a.[MaThuePhong] = b.[MaThuePhong]


insert into [dbo].[BangThuePhong] ( [MaThuePhong],[NgayThueP],[NgayTraP],[NgayGiaHan],[NgayDkThueP],[TinhTrangP],[MaKH],[MaNV]) values
('MTP8','2023/12/03','2023/12/05',Null,'2023/12/03',N'Chưa trả','KH1','NV1')

insert into [dbo].[ChiTietThuePhong] ([MaThuePhong],[MaPhong],[SLPhong]) values 
('MTP8','MP4',1)
delete from [dbo].[ChiTietThuePhong] where [MaThuePhong] = 'MTP8'

				-----UPDATE BẢNG YÊU CẦU DỊCH VỤ-----

---cập nhật chi phí dịch vụ---

UPDATE [dbo].[ChiTietYeuCauDV]
SET [ChiPhiDV] =  [SLDV] * dv.[DonGiaDV]
FROM [dbo].[ChiTietYeuCauDV] yc
JOIN [dbo].[DichVu]  dv ON yc.[MaDV] = dv.MaDV

SELECT * FROM [dbo].[YeuCauDV]
SELECT * FROM [dbo].[ChiTietYeuCauDV]


-------- tính TONG CONG DỊCH VỤ TRONG BẢNG YEU CẦU DỊCH VỤ
update [dbo].[YeuCauDV]
set [TCDV] = CP 
from  [dbo].[YeuCauDV] a, (select [MaYCDV], Sum([ChiPhiDV]) as CP
												from [dbo].[ChiTietYeuCauDV]
												group by [MaYCDV]) b
where a.[MaYCDV] = b.[MaYCDV]


					---- UPDATE BẢNG HÓA ĐƠN -------

-----upadate tổng cộng hóa đơn
--BƯỚC 1 :
select yc.MaKH , ([TCTP] + [TCDV] ) as tongcongHD
from [dbo].[HoaDon] hd, [dbo].[KhachHang] kh, [dbo].[BangThuePhong] tp,[dbo].[YeuCauDV] yc
where hd.MaKH = kh.MaKH and kh.MaKH = yc.[MaKH] and tp.MaKH = kh.MaKH 

----BƯỚC 2(CUÔI): 
UPDATE [dbo].[HoaDon] SET [TCHD] = tongcongHD
FROM [dbo].[HoaDon] a , (select yc.MaKH , ([TCTP] + [TCDV] ) as tongcongHD
                        from [dbo].[HoaDon] hd, [dbo].[KhachHang] kh, [dbo].[BangThuePhong] tp,[dbo].[YeuCauDV] yc
                          where hd.MaKH = kh.MaKH and kh.MaKH = yc.[MaKH] and tp.MaKH = kh.MaKH) b
where a.MaKH = b.MaKH

----- update CHIẾT KHẨU 
UPDATE [dbo].[HoaDon] SET [ChietKhau] = CASE WHEN [TCHD] >= 10000000 THEN 0.1  
                                          WHEN  [TCHD] >= 8000000 THEN  0.05
										    WHEN  [TCHD] >= 3000000 THEN 0.03
											else   0.00
										  END
---- cập nhật lại số tiền TTHD
UPDATE [dbo].[HoaDon] SET [SoTienTTHD] = ([TCHD] - ([TCHD] * [ChietKhau]))

-- Cập nhật trạng thái trả của phòng khi có thành tiền trong hóa đơn
UPDATE HoaDon
SET [TrangThaiTra] = 
    CASE 
        WHEN [SoTienTTHD] IS NOT NULL THEN N'Đã trả'
        ELSE [TrangThaiTra]  -- Giữ nguyên trạng thái phòng nếu không thỏa mãn điều kiện
    END;

		-------------------CÁC CÂU LỆNH TRIGGER-------------

----taọ trigger số ngày ở trong bảng thuê phòng

create trigger Trig_BangThuePhongg on [dbo].[BangThuePhong] after insert, update as
begin 
	UPDATE [dbo].[BangThuePhong]
SET [SoNgayO] = CASE
    WHEN [NgayGiaHan] IS NULL THEN DATEDIFF(day, [NgayThueP], [NgayTraP])
    ELSE DATEDIFF(day, [NgayThueP], [NgayTraP]) - DATEDIFF(day, [NgayGiaHan], [NgayTraP])
    END


end

----taọ trigger Thành tiền phòng trong chi tiết thuê phòng

create trigger Trig_CTTP on [dbo].[ChiTietThuePhong] after insert, update as
begin 
	UPDATE [dbo].[ChiTietThuePhong]
SET [ThanhTienP] = [SoNgayO] * [SLPhong] * c.[DonGiaP]
FROM  [dbo].[BangThuePhong] a, [dbo].[ChiTietThuePhong] b, [dbo].[Phong] c
Where b.MaPhong=c.MaPhong and b.MaThuePhong=a.MaThuePhong
------
	update [dbo].[BangThuePhong]
set [TCTP] = TC 
from [dbo].[BangThuePhong] a, (select [MaThuePhong], Sum([ThanhTienP]) as TC
												from [dbo].[ChiTietThuePhong]
												group by [MaThuePhong]) b
where a.[MaThuePhong] = b.[MaThuePhong]
end




----taọ trigger Chi phí dịch vụ trong chi tiết yêu cầu dịch vụ

create trigger Trig_CTDV on [dbo].[ChiTietYeuCauDV] after insert, update as
begin 
	UPDATE [dbo].[ChiTietYeuCauDV]
SET [ChiPhiDV] =  [SLDV] * dv.[DonGiaDV]
FROM [dbo].[ChiTietYeuCauDV] yc
JOIN [dbo].[DichVu]  dv ON yc.[MaDV] = dv.MaDV

update [dbo].[YeuCauDV]
set [TCDV] = CP 
from  [dbo].[YeuCauDV] a, (select [MaYCDV], Sum([ChiPhiDV]) as CP
												from [dbo].[ChiTietYeuCauDV]
												group by [MaYCDV]) b
where a.[MaYCDV] = b.[MaYCDV]
end


---- THÊM THUỘC TÍNH TUỔI VÀO NHÂN VIÊN
alter table [dbo].[NhanVien]
add  tuoi int
---- TẠO TRIGGER CẬP NHẬT TUỔI CHO NHÂN VIÊN 
create trigger Trig_Tuoi on [dbo].[NhanVien] after insert, update as 
begin 
	update [dbo].[NhanVien] set  [tuoi] = DATEDIFF(YYYY,[NgaySinhNV],GETDATE())
end


----taọ trigger  trong bảng hóa đơn


create trigger Trig_HoaDon on [dbo].[HoaDon] after insert, update as
begin 
UPDATE [dbo].[HoaDon] SET [TCHD] = tongcongHD
FROM [dbo].[HoaDon] a , (select yc.MaKH , ([TCTP] + [TCDV] ) as tongcongHD
                        from [dbo].[HoaDon] hd, [dbo].[KhachHang] kh, [dbo].[BangThuePhong] tp,[dbo].[YeuCauDV] yc
                          where hd.MaKH = kh.MaKH and kh.MaKH = yc.[MaKH] and tp.MaKH = kh.MaKH) b
where a.MaKH = b.MaKH

UPDATE [dbo].[HoaDon] SET [ChietKhau] = CASE WHEN [TCHD] >= 10000000 THEN 0.1  
                                          WHEN  [TCHD] >= 8000000 THEN  0.05
										    WHEN  [TCHD] >= 3000000 THEN 0.03
											else   0.00
										  END

UPDATE [dbo].[HoaDon] SET [SoTienTTHD] = ([TCHD] - ([TCHD] * [ChietKhau]))

UPDATE HoaDon
SET [TrangThaiTra] = 
    CASE 
        WHEN [SoTienTTHD] IS NOT NULL THEN N'Đã trả'
        ELSE [TrangThaiTra]  -- Giữ nguyên trạng thái phòng nếu không thỏa mãn điều kiện
    END;
end


insert into [dbo].[BangThuePhong] ( [MaThuePhong],[NgayThueP],[NgayTraP],[NgayGiaHan],[NgayDkThueP],[TinhTrangP],[MaKH],[MaNV]) values
('MTP3','2023/10/11','2023/10/15','2023/10/16','2023/10/10',N'Chưa trả','KH4','NV2')

insert into [dbo].[ChiTietThuePhong] ([MaThuePhong],[MaPhong],[SLPhong]) values 
('MTP3','MP2',1),
('MTP3','MP3',1)
 
 insert into [dbo].[YeuCauDV] ([MaYCDV],[MaKH],[NgayYCDV]) values
('YC5','KH4','2023/10/16')

insert into [dbo].[ChiTietYeuCauDV] ([MaYCDV],[MaDV],[SLDV]) values 
('YC5','DV1',2), 
('YC5','DV3',4)

insert into [dbo].[HoaDon] ([MaHoaDon],[MaKH],[MaNV],[NgayTTHD]) values
('HD5','KH3','NV2','2023/10/16')


/*insert into [dbo].[YeuCauDV] ([MaYCDV],[SoToDV],[MaDV],[MaKH],[NgayYCDV],[SLDV]) values
('YC8','ST5','DV3','KH4','2023/11/30',4),
('YC9','ST6','DV3','KH5','2024/01/20',2)
insert into [dbo].[HoaDon] ([MaHD],[MaKH],[MaThuePhong],[MaYCDV],[MaNV],[NgayTTHD]) values
('HD2','KH4','MTP8','YC8','NV3','2023/12/03'),
('HD3','KH5','MTP9','YC9','NV4','2024/01/25')*/


SELECT * FROM [dbo].[BangThuePhong]
SELECT * FROM [dbo].[ChiTietThuePhong]
select * from [dbo].[HoaDon]
select * from [dbo].[ChiTietHoaDonTP]
SELECT * FROM [dbo].[YeuCauDV]
SELECT * FROM [dbo].[ChiTietYeuCauDV]

select * from [dbo].[ChiTietHoaDonYCDV]
SELECT * FROM [dbo].[Phong]
SELECT * FROM [dbo].[NhanVien]


			--------TẠO 10 CÂU LỆNH TRUY VẤN ------------

 ---câu 1: Lấy danh sách các phòng đang trống------
SELECT [dbo].[Phong].*
FROM [dbo].[Phong]
LEFT JOIN [dbo].[ChiTietThuePhong] tp ON [dbo].[Phong].[MaPhong] = tp.[MaPhong]
WHERE tp.[MaPhong] IS NULL;
----câu 2 : Lấy thông tin khách hàng đang thuê phòng-------
SELECT [dbo].[KhachHang].* FROM [dbo].[KhachHang]
INNER JOIN [dbo].[BangThuePhong] ON [dbo].[KhachHang].[MaKH] = [dbo].[BangThuePhong].[MaKH];

----câu 3 : Lấy danh sách các dịch vụ đã sử dụng bởi một khách hàng cụ thể-----
	SELECT MaKH,MaDV 
	FROM [dbo].[YeuCauDV]
	INNER JOIN [dbo].[ChiTietYeuCauDV] ON YeuCauDV.MaYCDV = ChiTietYeuCauDV.MaYCDV
	WHERE [dbo].[YeuCauDV].[MaKH] = 'KH3';

	SELECT * FROM [dbo].[DichVu]
	SELECT * FROM[dbo].[YeuCauDV]

----câu 4: ĐẾM DỊCH VỤ MÀ KHÁCH HÀNG ĐÃ SỬ DỤNG-------
SELECT [dbo].[YeuCauDV].MaYCDV ,COUNT(*) AS SoLuotSuDung 
FROM  [dbo].[YeuCauDV]
INNER JOIN  [dbo].[ChiTietYeuCauDV] ON [dbo].[YeuCauDV].MaYCDV = [dbo].[ChiTietYeuCauDV].[MaYCDV]
INNER JOIN [dbo].[DichVu] ON [dbo].[DichVu].MaDV = ChiTietYeuCauDV.MaDV
GROUP BY [dbo].[YeuCauDV].MaYCDV 
ORDER BY SoLuotSuDung DESC;

----câu 5 : Lấy danh sách các PHÒNG  đang thuê phòng và thông tin phòng tương ứng---------------
SELECT  [dbo].[Phong].*
FROM  [dbo].[Phong]
INNER JOIN [dbo].[ChiTietThuePhong] ON [dbo].[Phong].MaPhong =[dbo].[ChiTietThuePhong].MaPhong

----cau 6 : Lấy danh sách các dịch vụ chưa được sử dụng------------------------
 SELECT [dbo].[DichVu].*
FROM [dbo].[DichVu]
LEFT JOIN [dbo].[ChiTietYeuCauDV] dv ON DichVu.MaDV =DV.MaDV
WHERE dv.[MaDV] IS NULL;

----câu 7 : Lấy danh sách các phòng chưa được thuê bởi khách hàng
SELECT [dbo].[Phong].*
FROM [dbo].[Phong]
LEFT JOIN [dbo].[ChiTietThuePhong] tp ON [dbo].[Phong].[MaPhong] = tp.[MaPhong]
WHERE   tp.[MaPhong] IS NULL;

----câu 8: Cho biết phếu thuê phòng có tổng giá trị lớn nhất trong tháng 12/3023 gồm các thông tin: Mã thuê phòng, ngày thuê, tên khách hàng, địa chỉ, tổng giá trị của phiếu thuê phòng
SELECT TOP 1 b.MaKH,a.[MaThuePhong] , [NgayThueP],[HoTenKH] , [DiaChiKH],[TCTP]
FROM  [dbo].[BangThuePhong] a,[dbo].[KhachHang]  b, [dbo].[ChiTietThuePhong] c
WHERE c.MaThuePhong=a.MaThuePhong and a.MaKH=b.MaKH AND MONTH([NgayThueP]) = 12 AND YEAR([NgayThueP]) = 2023
ORDER BY [TCTP] DESC

----câu 9: lấy danh sách các phòng vip chưa thuê -----------------
-- Lấy danh sách các phòng VIP chưa được thuê
SELECT [dbo].[Phong].*
FROM [dbo].[Phong]
LEFT JOIN [dbo].[ChiTietThuePhong] tp ON [dbo].[Phong].[MaPhong] = tp.[MaPhong]
WHERE [dbo].[Phong].[LoaiPhong] = 'VIP' AND tp.[MaPhong] IS NULL;

----câu 10 : lấy ra danh sách các dịch vụ được sử dụng------------
SELECT DichVu.MaDV,[dbo].[DichVu].[TenDV]
FROM  [dbo].[DichVu]
INNER JOIN [dbo].[ChiTietYeuCauDV]  ON [dbo].[DichVu].[MaDV] = ChiTietYeuCauDV.MaDV
GROUP BY DichVu.MaDV,[dbo].[DichVu].[TenDV]


































