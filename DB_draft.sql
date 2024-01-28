CREATE DATABASE MyCondo;
--1. (Table 5)
create table Condo
(
	CondoID	char(10)		not null,
	CondoName	varchar(50)	not null,
	CondoAddress	varchar(150)	not null unique,

	constraint PK_Condo primary key (CondoID),
)

--2. (Table 8)
create table ContactCat
(
	CtcCatID	char(10)		not null,
	CtcCatDesc	varchar(200)	not null,

	constraint PK_ContactCat primary key (CtcCatID)
)

--3. (Table 12)
create table FeedbkCat
(
	FbkCatID	char(10)			not null,
	FbkCatDesc	varchar(50)		not null,

	constraint PK_FeedbkCat primary key (FbkCatID)
)

--4. (Table 13)
create table ItemCategory
(
	ItemCatID	char(10)			not null,
	ItemCatDesc	varchar(50)		not null,

	constraint PK_ItemCategory primary key (ItemCatID)
)

--5. (Table 19)
create table Staff
(
	StaffID			char(10) 	not null,
	StaffName		varchar(50)	not null,
	StaffContactNo		char(8)		not null	unique,
	StaffDateJoined		date		not null	default(getdate()),
	StaffRole		char(1)		not null	check(StaffRole in ('A', 'C', 'T')),

	constraint PK_Staff primary key (StaffID)
)

 

--6. (Table 23)
create table Vehicle
(
	VehicleNo	char(10)		not null,
	IUNo		varchar(30)	not null	unique,
	Ownership	char(2)		not null	check(Ownership in('OW','RT','CC','OT')),
	Make		varchar(20)	not null,
	Model		varchar(20)	not null,

	constraint PK_Vehicle primary key (VehicleNo)
)

/*	Tables with no foreign key Ends Here	*/

--7. (Table 1)
create table Account
(
	AccID		smallint IDENTITY(1,1) 	not null,
	AccName	varchar(50)		not null,
	AccAddress	varchar(150)		null,
	AccCtcNo	char(8)			null	unique,
	AccEmail	varchar(50)		not null	unique,
	CondoID	char(10)			not null,
	ApprovedBy	char(10)			not null,
	
	constraint PK_Account primary key (AccID),
	constraint FK_Account_CondoID foreign key (CondoID) 
		references Condo (CondoID),
	constraint FK_Account_ApprovedBy foreign key (ApprovedBy)
		references Staff (StaffID)
)

--8. (Table 6)

create table CondoMgmt
(
	CondoMgmtID		smallint 		not null,
	ContactPerson		varchar(100)	not null,
	CtcPersonMobile	char(8)		not null	unique,

	constraint PK_CondoMgmt primary key (CondoMgmtID),
	constraint FK_CondoMgmt_CondoMgmtID foreign key(CondoMgmtID)
		references Account (AccID)
)


--9. (Table 18)
create table Owner
(
	OwnerID		smallint 		not null,
	OwnStartDate		date		not null,	
	CheckedBy		smallint		null,

	constraint PK_Owner primary key (OwnerID),
	constraint FK_Owner_OwnerID foreign key (OwnerID)
		references Account (AccID),
	constraint FK_Owner_CheckedBy foreign key (CheckedBy)
		references CondoMgmt (CondoMgmtID),
	
)

 
--10. (Table 2)
create table Announcement
(
	AnnID			char(10)		not null,
	AnnText			text		not null,
	AnnStartDate		date		not null	default(getdate()),
	AnnEndDate		date		not null,
	CondoMgmID		smallint		not null,

	constraint PK_Annoucement primary key (AnnID),
	constraint FK_Annoucement_CondoMgmID foreign key (CondoMgmID)
		references CondoMgmt (CondoMgmtID),
	constraint CK_Announcement_AnnEndDate check(AnnStartDate<=AnnEndDate), 
)

--11. (Table 9)
create table Facility
(
	FacID		char(10)		not null,
	FacName	varchar(100)	not null,
	Deposit		smallmoney	null,
	CondoID	char(10)		not null,

	constraint PK_Facility primary key (FacID),
	constraint FK_Facility_CondoID foreign key (CondoID)
		references Condo (CondoID)
)



--12. (Table 10)
create table FacTimeSlot
(
	FacID		char(10)		not null,
	TimeSlotSN	tinyint		not null,
	SlotDesc	varchar(100)	not null,

	constraint PK_FacTimeSlot primary key (FacID,TimeSlotSN),
	constraint FK_FacTimeSlot_FacID	foreign key (FacID)
		references Facility (FacID)
)

--13. (Table 4)
create table BookSlot
(
	FacID		char(10)		not null,
	TimeSlotSN	tinyint		not null,
	SlotDate	date		not null,
	SlotStatus	char(1)		not null	check(SlotStatus in ('A','B','M')),

	constraint PK_BookSlot primary key (FacID,TimeSlotSN,SlotDate),
	constraint FK_BookSlot_FacID_TimeSlotSN foreign key (FacID,TimeSlotSN)
		references FacTimeSlot (FacID,TimeSlotSN)

)
 
--14. (Table 3)
create table Booking
(
	BookingID		char(10)		not null,
	BookingDate		date		not null,
	BookingStatus		char(2)		not null	check(BookingStatus in ('PP','CF','CC')),
	AccID			smallint		not null,
	FacID			char(10)		not null,
	TimeSlotSn		tinyint		not null,
	SlotDate		date		not null,

	constraint PK_Booking primary key (BookingID),
	constraint FK_Booking_AccID foreign key (AccID)
		references Account (AccID),
	constraint FK_Booking_FacID_TimeSlotSn_SlotDate foreign key (FacID,TimeSlotSN,SlotDate)
		references BookSlot (FacID,TimeSlotSN,SlotDate),
	constraint Ck_Booking_BookingDate_SlotDate check(BookingDate<=SlotDate),
	constraint CK_Booking_FacID_TimeSlotSn_SlotDate UNIQUE (FacID,TimeSlotSN,SlotDate)
	)

--15. (Table 11)
create table Feedback
(
	FbkID		char(10)		not null,
	FbkDesc	text		not null,
	FbkDateTime	datetime	not null	default(getdate()),
	FbkStatus	char(1)		not null	check(FbkStatus in ('S','P','A')),
	ByAccID	smallint		not null,
	FbkCatID	char(10)		not null,
	CondoMgmID	smallint		null,

	constraint PK_Feedback primary key (FbkID),
	constraint FK_Feedback_ByAccID foreign key (ByAccID)
		references Account (AccID),
	constraint FK_Feedback_FbkCatID foreign key (FbkCatID)
		references FeedbkCat (FbkCatID),
	constraint FK_Feedback_CondoMgmID foreign key (CondoMgmID)
		references CondoMgmt (CondoMgmtID),
	constraint CK_Feedback_FbkDateTime check(FbkDateTime <= getdate())

)

--16. (Table 17)
create table Message
(
	MsgID		char(10)		not null,
	Msgtext		text		not null,
	Msgtype		char(1)		not null	check(MsgType in ('C','G','F')),
	PostedBy	smallint		not null,
	ReplyTo		char(10)		null,

	constraint PK_Message primary key (MsgID),
	constraint FK_Message_PostedBy foreign key (PostedBy)
		references Account (AccID),
	constraint FK_Message_ReplyTo foreign key (ReplyTo)
		references Message (MsgID)
)

 
--17. (Table 14)
create table ItemPhoto
(
	ItemID	char(10)		not null,
	Photo	varchar(20)	not null,
	
	constraint PK_ItemPhoto primary key (ItemID,Photo),
	constraint FK_ItemPhoto_ItemID foreign key (ItemID)
		references Message (MsgID)
)

--18. (Table 15)
create table ItemRelated
(
	ItemId		char(10)		not null,
	ItemDesc	varchar(150)	not null,
	ItemPrice	smallmoney		not null,
	ItemStatus	char(10)		not null	check(ItemStatus in ('Available','Sold')),
	SaleOrRent	char(4)		not null	check(SaleOrRent in ('Sale','Rent')),
	ItemCatId	char(10)		null,

	constraint PK_ItemRelated primary key (ItemID),
	constraint FK_ItemRelated_ItemID foreign key (ItemID)
		references Message (MsgID),
	constraint FK_ItemRelated_ItemCatID foreign key (ItemCatID)
		references ItemCategory (ItemCatId),
)

--19. (Table 16)
create table Likes
(
	AccID		smallint		not null,
	MessageID	char(10)		not null,

	constraint PK_Likes primary key (AccID,MessageID),
	constraint FK_Likes_AccID foreign key (AccID)
		references Account (AccID),
	constraint FK_Likes_MessageID foreign key (MessageID)
		references Message (MsgID)
)

--20. (Table 21)

create table  Tenant
(
	TenantID		smallint 		not null,
	ContactStartDate	date		not null	default(getdate()),
	ContactEndDate 	date		not null,
	VerifiedBy		smallint		null,

	constraint PK_Tenant primary key (TenantID),
	constraint FK_Tenant_TenantID foreign key (TenantID)
		references Account(AccID),
	constraint FK_Tenant_VerifiedBy foreign key (VerifiedBy)
		references CondoMgmt (CondoMgmtID),
	constraint CK_Tenant_ContactEndDate check(ContactStartDate <= ContactEndDate),
)

 
--21. (Table 22)
create table UsefulContact
(
	UsefulCtcID		char(10)		not null,
	UsefulCtcName		varchar(50)	not null,
	UsefulCtcDesc		varchar(150)	null,
	UsefulCtcPhone		char(8)		not null	unique,
	CtcCatId		char(10)		null,

	constraint PK_UsefulContact primary key (UsefulCtcID),
	constraint FK_UsefulContact_CtcCatID foreign key (CtcCatId)
		references ContactCat (CtcCatID)
)

--22. (Table 7)
create table CondoUsefulContact
(
	CondoID		char(10)		not null,
	UsefulCtcID		char(10)		not null,

	constraint PK_CondoUsefulContact primary key (CondoID,UsefulCtcID),
	constraint FK_CondoUsefulContact_CondoID foreign key (CondoID)
		references Condo (CondoID),
	constraint FK_CondoUsefulContact_UsefulCtcID foreign key (UsefulCtcID)
		references UsefulContact (UsefulCtcID),
)

--23. (Table 24)
create table VehicleLabel 
(
	VehLblAppID		char(10)		not null,
	VehLblStatus		char(1)		not null	check(VehLblStatus in ('P','A','R')),
	VehLblNum		char(10)		not null	unique,
	VehicleNo		char(10)		not null    unique,
	AppliedBy		smallint		not null,
	IssuedBy		smallint		null,

	constraint PK_VehicleLabel primary key (VehLblAppID),
	constraint FK_VehicleLabel foreign key (VehicleNo)
		references Vehicle (VehicleNo),
	constraint FK_AppliedBy foreign key (AppliedBy)
		references Account (AccID),
	constraint FK_IssuedBy foreign key (IssuedBy)
		references CondoMgmt (CondomgmtID),
)

--24. (Table 20)
create table TempVehLabel
(
	VehLblAppID		char(10)		not null,
	TempStartDate		date		not null,
	TempExpiryDate		date		not null,

	constraint PK_TempVehLabel primary key (VehLblAppID),
	constraint FK_TempVehLabel foreign key (VehLblAppID)
		references VehicleLabel (VehLblAppID),
	constraint CK_TempVehLabel_TempExpiryDate check(TempExpiryDate>=TempStartDate),
)

-- 1. Condo
Insert into Condo 
values 
	('C001', 'Marina Bay Residence','8 Marina Boulevard, Singapore'),
	('C002', 'King Albert Park', '1 King Albert Park, Singapore'),
	('C003', '1 Canberra','1 Lorong 20 Geylang, Singapore'),
	('C004', 'A Treasure Trove','50 - 76 Punggol Walk, Singapore'),
	('C005', 'Sky Habitat', '7 Bishan Street 15, Singapore'),
	('C006', 'City Square Residences', '8 Kitchener Link, Singapore'),
	('C007', 'Amaranda Garden','116-122 Serangoon Aveneue 3, Sinagpore'),
	('C008', 'The Clift', '21 McCallum Street, Singapore'),
	('C009', 'One Shenton', 'Hougnag Avenue 6, Singapore'),
	('C010', 'South Beach Residences', '28 Beach Road, Singapore'),
	('C011', 'Austville Residences','11-23 Sengkang Eaat Avenue, Singapore'),
	('C012', 'Bartley Grove Apartments',' 9A - 23D Bartley Road, Singapore'),
	('C013', 'Bliss @ Kovan','2 - 6B Simon Lane, Singapore'),
	('C014', 'Orchard Scotts Residences', '5 Anthony Road, Singapore'),
	('C015', 'The Interlace', '180 Depot Road, Singapore');
--2. ContactCat
Insert into ContactCat
values
	('CC001', 'Healthcare'),
	('CC002', 'Food and Beverage'),
	('CC003', 'Groceries'),
	('CC004', 'Petrol Stations'),
	('CC005', 'Electrical and Plumbing Services'),
('CC006', 'Beauty'),
	('CC007', 'Others');

--3.FeedbkCat
Insert into FeedbkCat
values
	('FC001', 'Cleanliness'),
	('FC002', 'Security'),
	('FC003', 'Plumbing'),
	('FC004', 'Building Defects'),
	('FC005', 'Parking'),
	('FC006', 'Noise Complaints'),
	('FC007', 'Amenities'),
	('FC008', 'Others');
--4.ItemCategory
Insert INTO ItemCategory
values 
	('IC001', 'Homeware'),
	('IC002', 'Fashion'),
	('IC003', 'Furniture'),
	('IC004', 'Electronics'),
	('IC005', 'Sports and Outdoors'),
	('IC006', 'Toys and Games'),
	('IC007', 'Books'),
	('IC008', 'Others');
 
--5.Staff
INSERT INTO Staff (StaffID, StaffName, StaffContactNo, StaffDateJoined, StaffRole)
VALUES
	('S001', 'S.Sairam', '94556614', '2020-01-12', 'A'),
	('S002', 'Chang Guan Qaun', '91234567', '2019-03-21', 'C'),
	('S003', 'Keshwindren', '82345678', '2021-06-14', 'T'),
	('S004', 'Jeremy Sim', '84561289', '2018-08-15', 'A'),
	('S005', 'Lirone Lim', '83124675', '2018-02-27', 'T'),
	('S006', 'Kedric Yeo', '87654321', '2022-07-23', 'T'),
	('S007', 'David Yee', '84327890', '2020-04-24', 'A'),
	('S008', 'Jerrell Lim', '86543210', '2021-03-21', 'C'),
	('S009', 'Arthur Wang', '96789012', '2019-08-20', 'T'),
	('S010', 'Jadan Sancho', '84121090', '2021-06-11', 'A'),
	('S011', 'Lionel Messi', '97890123', '2020-02-12', 'C'),
	('S012', 'Cristiano Ronaldo', '83411098', '2021-04-13', 'A'),
	('S013', 'Pey Zhi Xun', '88911234', '2023-01-24', 'A'),
	('S014', 'Jovan Tan', '93210987', '2023-01-25', 'C'),
	('S015', 'Vijay', '89012123', '2023-07-16', 'T');

--6.Vehicle
Insert into Vehicle
values
('V00001', 'IU12345678', 'OW', 'Toyota', 'RAV4'),
	('V00002', 'IU98765432', 'RT', 'Nissan', 'Rogue'),
	('V00003', 'IU87654321', 'CC', 'Ford', 'Mustang'),
	('V00004', 'IU23456789', 'OT', 'Chevrolet', 'Camaro'),
	('V00005', 'IU34567890', 'CC', 'Nissan', 'Altima'),
	('V00006', 'IU54321987', 'RT', 'BMW', '5 Series'),
	('V00007', 'IU81726354', 'OT', 'Mercedes-Benz', 'GLC'),
	('V00008', 'IU01928374', 'OT', 'Mercedes-Benz', 'E-Class'),
	('V00009', 'IU56789012', 'OW', 'Honda', 'Civic'),
	('V00010', 'IU10203040', 'RT', 'Kia', 'Optima'),
	('V00011', 'IU21324165', 'CC', 'Tesla', 'Model X'),
	('V00012', 'IU34127691', 'OT', 'Lexus', 'ES'),
	('V00013', 'IU90785634', 'OW', 'Mazda', 'Mazda6'),
	('V00014', 'IU09807061', 'RT', 'Volkswagen', 'Tiguan'),
	('V00015', 'IU40782367', 'OW', 'BMW', 'X3'),
	('V00016', 'IU99729173', 'OW', 'Porsche', '911 Carrera'),
	('V00017', 'IU55828173', 'OW', 'Renault', 'Captur'),
	('V00018', 'IU72790012', 'RT', 'Honda', 'City');
 
--7.Account
Insert into Account (AccName, AccAddress, AccCtcNo, AccEmail, CondoID, ApprovedBy)
values
-- First Condo 9 accounts (Owner --> 2,4,6,8) (Tenant ---> 1,3,5,7,9)
--Condo 1--
('John Tan', 'Blk 3, 8 Marina Boulevard, #05-118', '87345678', 'john.tan@gmail.com', 'C001', 'S010'),
('Steve Smith', 'Blk 4, 8 Marina Boulevard, #06-128', '88654321', 'steve.smith@gmail.com', 'C001', 'S002'),
('Virat Kohli', 'Blk 2, 8 Marina Boulevard, #04-108', '86781234', 'virat.kohli@gmail.com', 'C001', 'S011'),
('Dwayne Johnson', 'Blk 3, 8 Marina Boulevard, #05-115', '81218765', 'dwayne.johnson@gmail.com', 'C001', 'S011'),
('Taylor Swift', 'Blk 6, 8 Marina Boulevard, #03-101', '98765432', 'taylor.swift@gmail.com', 'C001', 'S009'),
('Lious Teo', 'Blk 5, 8 Marina Boulevard, #06-130', '80321678', 'lious.teo@gmail.com', 'C001', 'S008'),
('Ethan Lim', 'Blk 2, 8 Marina Boulevard, #07-131', '87654321', 'ethan.lim@gmail.com', 'C001', 'S007'),
('Selana Gomez', 'Blk 1, 8 Marina Boulevard, #04-110', '83567890', 'selana.gomez@gmail.com', 'C001', 'S006'),
('Harry Maguire', 'Blk 7, 8 Marina Boulevard, #07-135', '85432123', 'harry.maguire@gmail.com', 'C001','S005'),

-- Next Condo 9 accounts (Owner --> 10,12,14,16,18) (Tenant ---> 11,13,15,17)
--Condo 2--
('Rachel Tan', 'Blk 1, 1 King Albert Park, #05-118', '82358765', 'rachel.tan@gmail.com', 'C002', 'S001'),
('Alan Walker', 'Blk 1, 1 King Albert Park, #05-120', '87651234', 'alan.walker@gmail.com', 'C002', 'S009'),
('Annabelle Chua', 'Blk 2, 1 King Albert Park, #06-128', '84561234', 'annabelle.chua@gmail.com', 'C002', 'S007'),
('Sophia', 'Blk 2, 1 King Albert Park, #06-138', '86782341', 'sophia@gmail.com', 'C002', 'S003'),
('Chairmaine', 'Blk 3, 1 King Albert Park, #04-115', '87891234', 'chairmaine@gmail.com', 'C002', 'S002'),
('Bryan Lim', 'Blk 4, 1 King Albert Park, #03-108', '87892234', 'bryan.lim@gmail.com', 'C002', 'S004'),
('Enzo Tan', 'Blk 4, 1 King Albert Park, #03-105', '81234567', 'enzo.tan@gmail.com', 'C002', 'S015'),
('Fu Zheng Yi', 'Blk 5, 1 King Albert Park, #07-135', '82345678', 'fu.zhengyi@gmail.com', 'C002', 'S005'),
('Kevin De Bruyne', 'Blk 5, 1 King Albert Park, #07-138', '83456789', 'kevin.debruyne@gmail.com', 'C002', 'S002'),

-- Next 13 accounts (Owner --> 20,22,24,26,28,30) (Tenant ---> 19,21,23,25,27,29,31)
--Condo 3-15--
('Tom Holland', 'Blk 1, 1 Lorong 20 Geylang, #05-118', '84567890', 'tom.holland@gmail.com', 'C003', 'S006'),
('Bruno Mars', 'Blk 1, 50 - 76 Punggol Walk, #05-120', '87890123', 'bruno.mars@gmail.com', 'C004', 'S009'),
('Fandi Ahmed', 'Blk 2, 7 Bishan Street 15, #05-118', '88901234', 'fandi.ahmed@gmail.com', 'C005', 'S012'),
('Iqball', 'Blk 3, 8 Kitchener Link, #06-133', '82134567', 'iqball@gmail.com', 'C006', 'S013'),
('Elysaa', 'Blk 7, 116-122 Serangoon Aveneue 3, #02-100', '83245678', 'elysaa@gmail.com', 'C007', 'S015'),
('Keefe Chua', 'Blk 5, 21 McCallum Street, #05-120', '81224567', 'keefe.chua@gmail.com', 'C008', 'S015'),
('Eugene', 'Blk 5, Hougnag Avenue 6, #05-118', '83456889', 'eugene@gmail.com', 'C009', 'S006'),
('Marcus', 'Blk 2, 28 Beach Road, #06-128', '85678902', 'marcus@gmail.com', 'C010', 'S007'),
('Marcellus', 'Blk 3, 11-23 Sengkang Eaat Avenue, #03-103', '86789112', 'marcellus@gmail.com', 'C011', 'S009'),
('Melson', 'Blk 9A, 9A - 23D Bartley Road, #04-110', '87891123', 'melson@gmail.com', 'C012', 'S002'),
('Nicholas', 'Blk 4, 2 - 6B Simon Lane, #02-100', '88901254', 'nicholas@gmail.com', 'C013', 'S003'),
('Luis', 'Blk 2, 5 Anthony Road, #03-115', '89812345', 'luis@gmail.com', 'C014', 'S010'),
('Edric', 'Blk 5, 180 Depot Road, #06-130', '81023356', 'edric@gmail.com', 'C015', 'S008'),

--CondoMgmt --> (32,33,34,35,36,37,38,39,40,41)
--Condo1 --> 32
--Condo2 --> 33
--Condo3 --> 34
--Condo4 --> 35
--Condo5 --> 36
--Condo6 --> 37
--Condo7 --> 38
--Condo8 --> 39
--Condo9 --> 40
--Condo10 --> 41
--Condo11 --> 42
--Condo12 --> 43
--Condo13 --> 44
--Condo14 --> 45
--Condo15 --> 46

('HorizonBloom', 'King Albert Park 1', '87624321', 'horizonbloom@gmail.com','C001','S008'),
('SunRiseTech', 'Raffles Quay 45', '91234597', 'sunrise.tech@gmail.com','C002','S009'),
('ClearView Innovations', 'Bukit Timah Road 22', '82345671', 'clearview.innov@gmail.com','C003','S004'),
('StarLink Co.', 'Clarke Quay 78', '98165432', 'starlink@gmail.com','C004','S015'),
('SkyGrove Enterprises', 'Marina Bay Sands 15', '87154321', 'skygrove.ent@gmail.com','C005','S011'),
('SeaScape Solutions', 'East Coast Road 50', '82456789', 'seascape.sol@gmail.com','C006','S008'),
('FreshHarbor Ventures', 'Jurong West Street 18', '89012345', 'fresh.harbor@gmail.com','C007','S010'),
('BlueWave Industries', 'Yishun Avenue 2', '89654321', 'bluewave.ind@gmail.com','C008','S001'),
('PurePulse Technologies', 'Serangoon Central 31', '91234567', 'purepulse.tech@gmail.com','C009','S005'),
('EchoView Industries', 'Chinatown Point 40', '98865432', 'echoview@gmail.com','C010','S003'),
('Edifice', 'Central Clark Quay', '97981327', 'Edifice@gmail.com','C011','S009'),
('Siemens', '1020 Robbins Road', '98000111', 'siemens@gmail.com','C012','S006'),
('Brightview', '5 Shenton Way', '81118765', 'Brightview@gmail.com','C013','S007'),
('Milliot & Co', ' 63 Chulia Street', '99990000', 'milliotco@gmail.com','C014','S010'),
('Wellington', '21 Collyer Quay', '98980667', 'Wellington@gmail.com','C015','S009');
--8.CondoMgmt
INSERT INTO CondoMgmt (CondoMgmtID, ContactPerson, CtcPersonMobile)
VALUES
(32, 'Esther Natalie', '98765432'),
	(33, 'Brandon', '87654321'),
	(34, 'Dhanesh', '86543210'),
	(35, 'Mark', '85432109'),
	(36, 'Sky', '84321098'),
	(37, 'Tom Cruise', '83210987'),
	(38, 'Fu Zheng Yi', '82109876'),
	(39, 'Elon Mask', '81098765'),
	(40, 'Logan Paul', '89987654'),
	(41, 'Paul Walker', '98876543'),
	(42, 'Samuel', '88881111'),
	(43, 'Anirudh', '97974532'),
	(44, 'Andy', '98176543'),
	(45, 'Jackson', '91876543'),
	(46, 'Sowmyah', '93876543');
--9.Owner
Insert Into Owner (OwnerID, OwnStartDate, CheckedBy)
Values
	-- Even AccId are Owenrs
	-- Condo 1 (ONLY APPROVED  by CondoMgmt 32)
	(2, '1999-12-23', 32),
	(4, '2003-07-30', 32),
	(6, '2011-11-11', 32),
	(8, '2013-03-14', null),
	-- Condo 2 (ONLY APPROVED  by CondoMgmt 33)
	(10, '2020-01-29', 33),
	(12, '2011-11-11', 33),
	(14, '2020-04-21', 33),
	(16, '2011-11-22', 33),
	(18, '2021-11-30', null),
	-- Condo 3-15 (rest odd number CondoMgmt)
	(20, '2020-02-16', 35),
	(22, '2015-06-05', 37),
	(24, '2019-05-09', 39),
	(26, '2018-04-23', 41),
	(28, '2005-10-17', 43),
	(30, '1997-12-09', 45);

--10.Announcement
Insert into Announcement (AnnID, AnnText, AnnStartDate, AnnEndDate, CondoMgmID)
VALUES
('A001', 'Important maintenance notice.', '2023-10-10', '2023-10-30', 32),
('A002', 'Upcoming Chinese New Year Celebration on Saturday.', '2023-10-05', '2023-10-06', 32),
('A003', 'New security measures implemented.', '2024-02-10', '2024-03-01', 32),
('A004', 'Reminder: Monthly condo meeting on Friday.', '2024-02-15', '2024-02-25', 33),
('A005', 'Pool area maintenance scheduled for next week.', '2023-12-20', '2023-12-25', 33),
('A006', 'Changes to parking policy effective immediately.', '2023-12-25', '2023-12-30', 34),
('A007', 'Celebrating our community achievements.', '2024-01-10', '2024-01-15', 34),
('A008', 'Emergency contact numbers updated.', '2024-01-05', '2024-01-10', 35),
('A009', 'Notice: Water supply disruption on Monday.', '2023-11-10', '2023-11-20', 36),
('A010', 'Renovation work in progress. Apologies for inconvenience.', '2023-11-15', '2023-12-01', 37),
('A011', 'Fire drill scheduled for this month.', '2024-01-20', '2024-01-21', 38),
('A012', 'New fitness classes available. Join us!', '2024-02-25', '2024-04-10', 38),
('A013', 'Reminder: Pay your monthly dues by end of the week.', '2024-03-28', '2024-03-31', 39),
('A014', 'Community garden project meeting next Saturday.', '2024-03-30', '2024-04-01', 40),
('A015', 'Update: Elevator maintenance on Tuesday.', '2024-02-05', '2024-02-06', 41);
 
--11.Facility
INSERT INTO Facility (FacID, FacName, Deposit, CondoID)
VALUES
-- F represents Facilty , C represents Condo, so F1C1, means facility 1 in condo 1. 6 facailty for Condo 1,2 rest condo only got 2 facility 

-- Condo 1--
('F1C1', 'Swimming Pool', NULL, 'C001'),
('F2C1', 'Gym', 10.00, 'C001'),
('F3C1', 'BBQ Pit Area', 30.00, 'C001'),
('F4C1', 'Tennis Court', 10.00, 'C001'),
('F5C1', 'Function Room', 50.00, 'C001'),
('F6C1', 'Children Playground', NULL, 'C001'),

-- Condo 2--
('F1C2', 'Swimming Pool', NULL, 'C002'),
('F2C2', 'Gym', 12.00, 'C002'),
('F3C2', 'BBQ Pit Area', 35.00, 'C002'),
('F4C2', 'Tennis Court', 11.00, 'C002'),
('F5C2', 'Function Room', 50.00, 'C002'),
('F6C2', 'Children Playground', NULL, 'C002'),

-- Condo 3--
('F1C3', 'Swimming Pool', NULL, 'C003'),
('F2C3', 'Gym', 9.00, 'C003'),
('F3C3', 'BBQ Pit Area', 30.00, 'C003'),
('F4C3', 'Tennis Court', 10.00, 'C003'),
('F5C3', 'Function Room', 50.00, 'C003'),
('F6C3', 'Children Playground', NULL, 'C003'),

--Condo 4--
('F1C4', 'Swimming Pool', NULL, 'C004'),
('F2C4', 'Tennis Court', 13.00, 'C004'),

--Condo 5--
('F1C5', 'Gym', NULL, 'C005'),
('F2C5', 'BBQ Pit Area', 30.00, 'C005'),

--Condo 6--
('F1C6', 'Swimming Pool', NULL, 'C006'),
('F2C6', 'Tennis Court', NULL, 'C006'),

--Condo 7--
('F1C7', 'Gym', NULL, 'C007'),
('F2C7', 'BBQ Pit Area', 30.00, 'C007'),

--Condo 8--
('F1C8', 'Function Room', 50.00, 'C008'),
('F2C8', 'Children Playground', NULL, 'C008'),

--Condo 9--
('F1C9', 'Function Room', 50.00, 'C009'),
('F2C9', 'Children Playground', NULL, 'C009');
 
--12. FacTimeSlot
INSERT INTO FacTimeSlot (FacID, TimeSlotSN, SlotDesc)
VALUES
-- Time slots for facilities in Condo C001
('F1C1', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C1', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C1', 3, 'Evening Slot: 6 PM to 12 AM'),

('F2C1', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C1', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C1', 3, 'Evening Slot: 6 PM to 12 AM'),

('F3C1', 1, 'Morning Slot: 6 AM to 12 PM'),
('F3C1', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F3C1', 3, 'Evening Slot: 6 PM to 12 AM'),

('F4C1', 1, 'Morning Slot: 6 AM to 12 PM'),
('F4C1', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F4C1', 3, 'Evening Slot: 6 PM to 12 AM'),

('F5C1', 1, 'Morning Slot: 6 AM to 12 PM'),
('F5C1', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F5C1', 3, 'Evening Slot: 6 PM to 12 AM'),

('F6C1', 1, 'Morning Slot: 6 AM to 12 PM'),
('F6C1', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F6C1', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C002
('F1C2', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C2', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C2', 3, 'Evening Slot: 6 PM to 12 AM'),

('F2C2', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C2', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C2', 3, 'Evening Slot: 6 PM to 12 AM'),

('F3C2', 1, 'Morning Slot: 6 AM to 12 PM'),
('F3C2', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F3C2', 3, 'Evening Slot: 6 PM to 12 AM'),

('F4C2', 1, 'Morning Slot: 6 AM to 12 PM'),
('F4C2', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F4C2', 3, 'Evening Slot: 6 PM to 12 AM'),

('F5C2', 1, 'Morning Slot: 6 AM to 12 PM'),
('F5C2', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F5C2', 3, 'Evening Slot: 6 PM to 12 AM'),

('F6C2', 1, 'Morning Slot: 6 AM to 12 PM'),
('F6C2', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F6C2', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C003
('F1C3', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C3', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C3', 3, 'Evening Slot: 6 PM to 12 AM'),

('F2C3', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C3', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C3', 3, 'Evening Slot: 6 PM to 12 AM'),

('F3C3', 1, 'Morning Slot: 6 AM to 12 PM'),
('F3C3', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F3C3', 3, 'Evening Slot: 6 PM to 12 AM'),

('F4C3', 1, 'Morning Slot: 6 AM to 12 PM'),
('F4C3', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F4C3', 3, 'Evening Slot: 6 PM to 12 AM'),

('F5C3', 1, 'Morning Slot: 6 AM to 12 PM'),
('F5C3', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F5C3', 3, 'Evening Slot: 6 PM to 12 AM'),

('F6C3', 1, 'Morning Slot: 6 AM to 12 PM'),
('F6C3', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F6C3', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C004
('F1C4', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C4', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C4', 3, 'Evening Slot: 6 PM to 12 AM'),
('F2C4', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C4', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C4', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C005
('F1C5', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C5', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C5', 3, 'Evening Slot: 6 PM to 12 AM'),
('F2C5', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C5', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C5', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C006
('F1C6', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C6', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C6', 3, 'Evening Slot: 6 PM to 12 AM'),
('F2C6', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C6', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C6', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C007
('F1C7', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C7', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C7', 3, 'Evening Slot: 6 PM to 12 AM'),
('F2C7', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C7', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C7', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C008
('F1C8', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C8', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C8', 3, 'Evening Slot: 6 PM to 12 AM'),
('F2C8', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C8', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C8', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C009
('F1C9', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C9', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C9', 3, 'Evening Slot: 6 PM to 12 AM'),
('F2C9', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C9', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C9', 3, 'Evening Slot: 6 PM to 12 AM');
 
--13.BookSlot
INSERT INTO BookSlot(FacID, TimeSlotSN, SlotDate, SlotStatus)
VALUES
-- Time slots for facilities in Condo C001
('F1C1', 1, '2023-09-20', 'A'),
('F1C1', 2, '2023-09-20', 'M'),
('F1C1', 3, '2023-09-20', 'B'),

('F2C1', 1, '2023-10-19', 'A'),
('F2C1', 2, '2023-10-19', 'A'),
('F2C1', 3, '2023-10-19', 'A'),

('F3C1', 1, '2023-11-18', 'B'),
('F3C1', 2, '2023-11-18', 'A'),
('F3C1', 3, '2023-11-18', 'B'),

('F4C1', 1, '2023-09-17', 'A'),
('F4C1', 2, '2023-09-17', 'B'),
('F4C1', 3, '2023-09-17', 'A'),

('F5C1', 1, '2023-10-16', 'A'),
('F5C1', 2, '2023-10-16', 'B'),
('F5C1', 3, '2023-10-16', 'A'),

('F6C1', 1, '2023-11-15', 'A'),
('F6C1', 2, '2023-11-15', 'A'),
('F6C1', 3, '2023-11-15', 'A'),

('F6C1', 3, '2024-02-15', 'A'),

-- Time slots for facilities in Condo C002
('F1C2', 1, '2023-09-20', 'B'),
('F1C2', 2, '2023-09-20', 'A'),
('F1C2', 3, '2023-09-20', 'B'),

('F2C2', 1, '2023-12-19', 'B'),
('F2C2', 2, '2023-12-19', 'A'),
('F2C2', 3, '2023-12-19', 'A'),

('F3C2', 1, '2024-01-18', 'A'),
('F3C2', 2, '2024-01-18', 'A'),
('F3C2', 3, '2024-01-18', 'B'),

('F4C2', 1, '2023-09-17', 'B'),
('F4C2', 2, '2023-09-17', 'M'),
('F4C2', 3, '2023-09-17', 'A'),

('F5C2', 1, '2023-12-16', 'A'),
('F5C2', 2, '2023-12-16', 'B'),
('F5C2', 3, '2023-12-16', 'B'),
('F5C2', 1, '2024-02-16', 'A'),

('F6C2', 1, '2024-01-15', 'A'),
('F6C2', 2, '2024-01-15', 'A'),
('F6C2', 3, '2024-01-15', 'A'),
('F6C2', 1, '2024-02-15', 'A'),
('F6C2', 2, '2024-02-15', 'A'),
('F6C2', 3, '2024-02-15', 'A'),

-- Time slots for facilities in Condo C003
('F1C3', 1, '2023-09-20', 'A'),
('F1C3', 2, '2023-09-20', 'A'),
('F1C3', 3, '2023-09-20', 'A'),
('F2C3', 1, '2023-09-19', 'B'),
('F2C3', 2, '2023-09-19', 'B'),
('F2C3', 3, '2023-09-19', 'A'),
('F3C3', 1, '2023-09-18', 'A'),
('F3C3', 2, '2023-09-18', 'B'),
('F3C3', 3, '2023-09-18', 'B'),
('F4C3', 1, '2023-09-17', 'A'),
('F4C3', 2, '2023-09-17', 'B'),
('F4C3', 3, '2023-09-17', 'B'),
('F5C3', 1, '2023-09-16', 'M'),
('F5C3', 2, '2023-09-16', 'A'),
('F5C3', 3, '2023-09-16', 'B'),
('F6C3', 1, '2023-09-15', 'A'),
('F6C3', 2, '2023-09-15', 'A'),
('F6C3', 3, '2023-09-15', 'A'),

-- Time slots for facilities in Condo C004
('F1C4', 1, '2023-09-20', 'A'),
('F1C4', 2, '2023-09-20', 'B'),
('F1C4', 3, '2023-09-20', 'M'),
('F2C4', 1, '2023-09-19', 'A'),
('F2C4', 2, '2023-09-19', 'B'),
('F2C4', 3, '2023-09-19', 'A'),

-- Time slots for facilities in Condo C005
('F1C5', 1, '2023-09-20', 'M'),
('F1C5', 2, '2023-09-20', 'B'),
('F1C5', 3, '2023-09-20', 'A'),
('F2C5', 1, '2023-09-19', 'B'),
('F2C5', 2, '2023-09-19', 'A'),
('F2C5', 3, '2023-09-19', 'B'),

-- Time slots for facilities in Condo C006
('F1C6', 1, '2023-09-20', 'B'),
('F1C6', 2, '2023-09-20', 'A'),
('F1C6', 3, '2023-09-20', 'M'),
('F2C6', 1, '2023-09-19', 'A'),
('F2C6', 2, '2023-09-19', 'B'),
('F2C6', 3, '2023-09-19', 'A'),

-- Time slots for facilities in Condo C007
('F1C7', 1, '2023-09-20', 'A'),
('F1C7', 2, '2023-09-20', 'M'),
('F1C7', 3, '2023-09-20', 'A'),
('F2C7', 1, '2023-09-19', 'A'),
('F2C7', 2, '2023-09-19', 'B'),
('F2C7', 3, '2023-09-19', 'A'),

-- Time slots for facilities in Condo C008
('F1C8', 1, '2023-09-20', 'A'),
('F1C8', 2, '2023-09-20', 'B'),
('F1C8', 3, '2023-09-20', 'B'),
('F2C8', 1, '2023-09-19', 'B'),
('F2C8', 2, '2023-09-19', 'B'),
('F2C8', 3, '2023-09-19', 'M'),

-- Time slots for facilities in Condo C009
('F1C9', 1, '2023-09-20', 'B'),
('F1C9', 2, '2023-09-20', 'A'),
('F1C9', 3, '2023-09-20', 'B'),
('F2C9', 1, '2023-09-19', 'A'),
('F2C9', 2, '2023-09-19', 'B'),
('F2C9', 3, '2023-09-19', 'M');
 
--14.Booking
INSERT INTO Booking (BookingID, BookingDate, BookingStatus, AccID, FacID, TimeSlotSn, SlotDate)
VALUES
-- Account(1-9 in Condo 1 booked for facility that are available in condo 1)
-- Swimming pool booked mostly one day before booking
('B1C001', '2023-09-18', 'PP', 1, 'F1C1', 1, '2023-09-20'),
('B3C001', '2023-09-19', 'CF', 5, 'F1C1', 3, '2023-09-20'),
--Gym mostly booked one day before booking.
('B4C001', '2023-10-17', 'PP', 1, 'F2C1', 1, '2023-10-19'),
('B5C001', '2023-10-18', 'CC', 2, 'F2C1', 2, '2023-10-19'),
('B6C001', '2023-10-16', 'PP', 4, 'F2C1', 3, '2023-10-19'),
--BBQ Pit Area booked 1 week ago before booking
('B7C001', '2023-11-11', 'CF', 7, 'F3C1', 1, '2023-11-18'),
('B8C001', '2023-11-10', 'PP', 9, 'F3C1', 2, '2023-11-18'),
('B9C001', '2023-11-09', 'CF', 1, 'F3C1', 3, '2023-11-18'),
--Tennis Court mostly booked two day before booking.
('B10C001', '2023-09-15', 'PP', 2, 'F4C1', 1, '2023-09-17'),
('B11C001', '2023-09-16', 'CF', 8, 'F4C1', 2, '2023-09-17'),
('B12C001', '2023-09-14', 'CC', 6, 'F4C1', 3, '2023-09-17'),
--Function room mostly booked one month before booking.
('B13C001', '2023-09-11', 'PP', 4, 'F5C1', 1, '2023-10-16'),
('B14C001', '2023-09-15', 'CF', 3, 'F5C1', 2, '2023-10-16'),
('B15C001', '2023-09-10', 'PP', 5, 'F5C1', 3, '2023-10-16'),

-- Account(10-18 in Condo 2 booked for facility that are available in condo 2)
-- Swimming pool booked mostly one day before booking
('B1C002', '2023-09-18', 'CF', 11, 'F1C2', 1, '2023-09-20'),
('B2C002', '2023-09-19', 'PP', 13, 'F1C2', 2, '2023-09-20'),
('B3C002', '2023-09-17', 'CF', 15, 'F1C2', 3, '2023-09-20'),
--Gym mostly booked one day before booking.
('B4C002', '2023-12-18', 'CF', 11, 'F2C2', 1, '2023-12-19'),
('B5C002', '2023-12-16', 'PP', 12, 'F2C2', 2, '2023-12-19'),
('B6C002', '2023-12-17', 'CC', 14, 'F2C2', 3, '2023-12-19'),
--BBQ Pit Area booked 1 week ago before booking
('B7C002', '2024-01-07', 'CF', 17, 'F3C2', 1, '2024-01-18'),
('B8C002', '2024-01-10', 'CC', 15, 'F3C2', 2, '2024-01-18'),
('B9C002', '2023-12-31', 'CF', 11, 'F3C2', 3, '2024-01-18'),
--Tennis Court mostly booked two day before booking.
('B10C002', '2023-07-13', 'PP', 12, 'F4C2', 1, '2023-09-17'),
('B12C002', '2023-07-13', 'PP', 16, 'F4C2', 3, '2023-09-17'),
--Function room mostly booked one month before booking.
('B13C002', '2023-11-22', 'CF', 14, 'F5C2', 1, '2023-12-16'),
('B14C002', '2023-11-15', 'CF', 13, 'F5C2', 2, '2023-12-16'),
('B15C002', '2023-11-17', 'CF', 15, 'F5C2', 3, '2023-12-16');
-- Account(10-18 in Condo 2 booked for facility that are available in condo 2)
 
--15. Feedback
INSERT INTO Feedback (FbkID, FbkDesc, FbkDateTime, FbkStatus, ByAccID, FbkCatID, CondoMgmID)
VALUES
('FBK001', 'The hallway on the 3rd floor is not properly cleaned.', '2024-01-015 10:00:00', 'S', 5, 'FC001', Null),
('FBK002', 'The security gate is malfunctioning frequently.', '2024-01-13 15:30:00', 'A', 12, 'FC002', 33),
('FBK003', 'Leaky faucet in the community gym restroom.', '2024-01-13 09:00:00', 'S', 7, 'FC003', NULL),
('FBK004', 'Cracks observed on the sidewall of building B.', '2024-01-12 14:20:00', 'P', 15, 'FC004', 33),
('FBK005', 'Parking lot line markings are faded and need repainting.', '2024-1-10 13:00:00', 'S', 20, 'FC005', NULL),
('FBK006', 'Loud music from apartment 5B during late-night hours.', '2024-01-09 22:00:00', 'A', 9, 'FC006', 32),
('FBK007', 'Broken equipment in the fitness center.', '2024-01-09 16:45:00', 'S', 18, 'FC007', Null),
('FBK008', 'Littering around the community playground.', '2024-01-08 11:30:00', 'A', 22, 'FC001', 37),
('FBK009', 'Elevator doors closing too quickly, posing a safety hazard.', '2024-01-08 17:15:00', 'S', 25, 'FC008', Null),
('FBK010', 'Inadequate lighting in the rear parking area.', '2024-01-05 20:50:00', 'P', 30, 'FC005', 45),
('FBK011', 'The hallway in the lobby is not cleaned','2024-01-03','S',24,'FC001',null),
('FBK012', 'There is water leaking from the pipe on the ceiling at the lobby','2024-01-03','P',22,'FC002',37),
('FBK013', 'There were teenager shouting at the basketball court while at 10pm','2024-01-01','A',20,'FC006',35),
('FBK014', 'People banging to the walls at 2am','2023-12-30','S',7,'FC006',null),
('FBK015', 'The lift has a awful smell of faeces','2023-12-29','A',2,'FC001',32),
('FBK016', 'There are faeces in the lift','2023-12-29','A',2,'FC001',32),
('FBK017', 'There are people playing loud music on the rooftop at 11pm','2023-12-27','P',1,'FC006',32),
('FBK018', 'The lift handles are not sanitised properly','2023-12-25','A',4,'FC001',32),
('FBK019', 'The parking lots are very dirty','2023-12-25','A',6,'FC001',32),
('FBK020', 'The floor of the hallway is not cleaned properly. The floor is very slippery','2023-12-20','A',13,'FC001',33);

--16. Message
INSERT INTO Message (MsgID, Msgtext, Msgtype, PostedBy, ReplyTo)
VALUES
--Question01--
('MSG00001', 'Looking for a jogging partner in our community. Anyone interested?', 'F', 5, NULL), 
--Question02--
('MSG00002', 'Hosting a garage sale this Saturday at Block 3. Lots of kids’ items and books!', 'G', 12,NULL ),
--Reply03--
('MSG00003', 'Sure i will take part in the project', 'C', 15, 'MSG00005'), 

('MSG00004', 'Lost dog spotted near the community park. Seems friendly. Please check if it’s yours.', 'C', 7, NULL), 
--Question03--
('MSG00005', 'Interested in starting a community garden project. Who wants to join?', 'C', 16, NULL),
--Reply02--
('MSG00006', 'What time is the event', 'G', 15, 'MSG00002'), 
--Reply01--
('MSG00007', 'Im free from 4-6, lets link up!', 'F', 2,'MSG00001' ), 

('MSG00008', 'Reminder: Don’t forget to vote in the condo board elections this Friday.', 'C', 9, NULL), 
--Question04--
('MSG00009', 'Looking for a tennis partner. I’m an intermediate player hoping to play on weekends.', 'F', 18, NULL),

('MSG00010', 'For sale: Vintage record player in great condition. Message if interested.', 'G', 25, null),
--Question05--
('MSG00011', 'Selling an unopened Tom Ford Oud EDP for men', 'G', 8, null), 
--Reply05--
('MSG00012', 'How long did you have it?', 'G', 2, 'MSG00011'),

('MSG00013', 'Letting go of a prevloved Nintendo switch console', 'G', 17, NULL),
('MSG00014', '15 inch MacBook Pro 2013 up for sale', 'G', 25, NULL),
--Question06--
('MSG00015', 'Selling an unused Dyson AirWrap', 'G', 11, NULL),
--Reply06--
('MSG00016', 'Is the warranty still valid?', 'G', 14,'MSG00015' ),
('MSG00017', 'Preloved Iphone 3gs', 'G', 28, NULL),
('MSG00018', 'Cute pearl necklace for sale', 'G', 30, NULL),
--Reply04--
('MSG00019', 'Have you booked the tennis court?', 'F', 16, 'MSG00009');
 
--17. ItemPhoto
INSERT INTO ItemPhoto (ItemID, Photo)
VALUES
--	Photos for Message 1
('MSG00001', 'Photo 1'),
('MSG00001', 'Photo 2'),
('MSG00001', 'Photo 3'),
--	Photos for Message 2
('MSG00002', 'Photo 1'),
('MSG00002', 'Photo 2'),
('MSG00002', 'Photo 3'),

--	Photos for Message 4
('MSG00004', 'Photo 1'),
('MSG00004', 'Photo 2'),
('MSG00004', 'Photo 3'),
--	Photos for Message 5
('MSG00005', 'Photo 1'),
('MSG00005', 'Photo 2'),
('MSG00005', 'Photo 3'),
--	Photos for Message 6
('MSG00006', 'Photo 1'),
('MSG00006', 'Photo 2'),
('MSG00006', 'Photo 3'),
--	Photos for Message 8
('MSG00008', 'Photo 1'),
('MSG00008', 'Photo 2'),
('MSG00008', 'Photo 3'),
--	Photos for Message 9
('MSG00009', 'Photo 1'),
('MSG00009', 'Photo 2'),
('MSG00009', 'Photo 3'),
--	Photos for Message 10
('MSG00010', 'Photo 1'),
('MSG00010', 'Photo 2'),
('MSG00010', 'Photo 3'),
-- Photos for Message 11 - 19
('MSG00011', 'Photo 1'),
('MSG00012', 'Photo 1'),
('MSG00013', 'Photo 1'),
('MSG00014', 'Photo 1'),
('MSG00015', 'Photo 1'),
('MSG00016', 'Photo 1'),
('MSG00017', 'Photo 1'),
('MSG00018', 'Photo 1');
--18. ItemRelated
INSERT INTO ItemRelated (ItemID, ItemDesc, ItemPrice, ItemStatus,SaleOrRent, ItemCatID)
VALUES
('MSG00002', 'Peppa Pig picture book', '$5', 'Available', 'Sale', 'IC007'),
('MSG00006', 'Gently used Rustica coffee table', '$30', 'Available', 'Sale', 'IC003'),
('MSG00010', 'Edison record player from 1976', '$120.53', 'Available', 'Sale', 'IC008'),
('MSG00011', 'Tom Ford Oud EDP: Got it as a christmas gift, never used, 100ml', '$70', 'Available', 'Sale', 'IC002'),
('MSG00012', 'Ralph Lauren Half Zipper: Used about 7 times', '$15', 'Available', 'Sale', 'IC002'),
('MSG00013', 'Nintendo switch: Had it for about 7 years, time to let go', '$10', 'Sold', 'Sale', 'IC006'),
('MSG00014', 'Macbook Pro 2013: 256SSD, 16GB RAM', '$700', 'Available', 'Sale', 'IC004'),
('MSG00015', 'Dyson Airwrap: Got it from my ex, never used', '$700', 'Available', 'Sale', 'IC004'),
('MSG00016', 'Biology STPM: Overused', '$3', 'Sold', 'Sale', 'IC007'),
('MSG00017', 'Iphone 3gs: Doesnt power on, good as a decorative piece', '$60', 'Available', 'Sale', 'IC004'),
('MSG00018', 'Pearl necklace: About 5mm in length', '$5', 'Sold', 'Sale', 'IC002');
 
--19. Likes
INSERT INTO Likes (AccID, MessageID)
VALUES
(1, 'MSG00001'),
(4, 'MSG00002'),
(7, 'MSG00002'),
(9, 'MSG00003'),
(11, 'MSG00006'),
(14, 'MSG00006'),
(20, 'MSG00007'),
(25, 'MSG00007'),
(23, 'MSG00008'),
(28, 'MSG00009'),
(29, 'MSG00009'),
(30, 'MSG00010'),
(31, 'MSG00010');

--20. Tenant
INSERT INTO Tenant (TenantID, ContactStartDate, ContactEndDate, VerifiedBy)
VALUES
--Tenant ID Condo 1(Odd numbers of Account ID ---> (1,3,5,7,9) Aprroved by ONLY CondoMgmt 32
(1, '2023-1-10', '2027-3-10', 32),
(3, '2023-2-10', '2027-2-10', 32),
(5, '2023-3-10', '2027-1-10', 32),
(7, '2023-4-10', '2026-12-10', null),
(9, '2023-5-10', '2026-11-10', 32),
--Tenant ID Condo 2(Odd numbers of Account ID ---> (11,13,15,17) Aprroved by ONLY CondoMgmt 33
(11, '2023-6-10', '2026-10-10', 33),
(13, '2023-7-10', '2026-9-10', 33),
(15, '2023-8-10', '2026-8-10', null),
(17, '2023-9-10', '2026-7-10', 33),
(19, '2023-10-10', '2026-6-10', null),
--Aprroved by ONLY even numbers of  CondoMgmt 
(21, '2023-11-10', '2026-5-10', 34),
(23, '2023-12-10', '2026-4-10', 36),
(25, '2024-1-10', '2026-3-10', 40),
(27, '2024-2-10', '2026-2-10', 42),
(29, '2023-3-10', '2026-1-10', 44),
(31, '2023-4-10', '2026-1-10', 46);
--21. UsefulContact
INSERT INTO UsefulContact (UsefulCtcID, UsefulCtcName, UsefulCtcDesc, UsefulCtcPhone, CtcCatId)
VALUES
('UC0001',	'Silver Cross Family Clinic',	'Walk-in Clinic',	'12345678', 'CC001'),
('UC0002',	'Shen & Co Cafe',		'Cafe',			'23456789', 'CC002'),
('UC0003',	'Koryo Mart',			'Korean Grocery Store',	'34567890', 'CC003'),
('UC0004',	'Shell',			'Petrol Station',		'45678901', 'CC004'),
('UC0005',	'SK Electrical',		'Electrical Installation Service',	'56789012', 'CC005'),
('UC0006',	'Tinhill Salon',		'Salon',			'67890123', 'CC006'),
('UC0007',	'Boon Hong',			'Clinic',			'78901234', 'CC001'),
('UC0008',	'Al-Azhar',			'Indian Muslim Restaurant',	'89012345', 'CC002'),
('UC0009',	'Giant Supermarket',		'Supermarket',		'90123456', 'CC003'),
('UC0010', 	'People Dental Surgery',	'Dental',			'01234567', 'CC001'),
('UC0011', 	'G1 Hair & Nail Studio',	'Hairdresser',		'24680246', 'CC006'),
('UC0012', 	'Twinkle Childcare',		'Day Care Center',		'35791357', 'CC007'),
('UC0013', 	'Toh Yi Family Clinic',	'Medical Clinic',		'46802468', 'CC001'),
('UC0014', 	'iO Italian Osteria',	'Italian Restaurant',	'57913579', 'CC002'),
('UC0015', 	'Sol Mart',			'Korean Grocery Store',	'68024680', 'CC003'),
('UC0016', 	'Caltex',			'Petrol Station',		'79135791', 'CC004'),
('UC0017', 	'Family Plumber',		'Plumber',			'80246802', 'CC005'),
('UC0018', 	'Le Zen Spa',			'Massage Spa',		'02468024', 'CC006'),
('UC0019', 	'Cold Storage',		'Supermarket',		'12344321', 'CC003'),
('UC0020', 	'Better Days Cafe',		'Cafe',			'56788765', 'CC002');

 
--22. CondoUseFulContact
INSERT INTO CondoUsefulContact (CondoId, UsefulCtcID)
VALUES
('C001', 'UC0001'),
('C002', 'UC0002'),
('C003', 'UC0003'),
('C004', 'UC0004'),
('C005', 'UC0005'),
('C006', 'UC0006'),
('C007', 'UC0007'),
('C008', 'UC0008'),
('C009', 'UC0009'),
('C010', 'UC0010'),
('C011', 'UC0011'),
('C012', 'UC0012'),
('C013', 'UC0013'),
('C014', 'UC0014'),
('C015', 'UC0015'),
('C001', 'UC0016'),
('C002', 'UC0017'),
('C003', 'UC0018'),
('C004', 'UC0019'),
('C005', 'UC0020');

--23. VehicleLabel
INSERT INTO VehicleLabel (VehLblAppID, VehLblStatus, VehLblNum, VehicleNo, AppliedBy, IssuedBy)
VALUES
('VL00001', 'A', 'VN00001', 'V00001', 15, 33),
('VL00002', 'A', 'VN00002', 'V00002', 15, 33),	
('VL00003', 'P', 'VN00003', 'V00003', 11, NULL),	
('VL00004', 'A', 'VN00004', 'V00004', 9, 32),
('VL00005', 'A', 'VN00005', 'V00005', 2, 32),	
('VL00006', 'A', 'VN00006', 'V00006', 7, 32),	
('VL00007', 'P', 'VN00007', 'V00007', 8, null),	
('VL00008', 'R', 'VN00008', 'V00008', 22, 37),	
('VL00009', 'P', 'VN00009', 'V00009', 17, null),	
('VL00010', 'A', 'VN00010', 'V00010', 21, 36),	
('VL00011', 'P', 'VN00011', 'V00011', 12, null),	
('VL00012', 'A', 'VN00012', 'V00012', 23, 38),	
('VL00013', 'P', 'VN00013', 'V00013', 27, NULL),	
('VL00014', 'A', 'VN00014', 'V00014', 18, 33),	
('VL00015', 'P', 'VN00015', 'V00015', 12, NULL),	
('VL00016', 'A', 'VN00016', 'V00016', 5, 32),
('VL00017', 'A', 'VN00017', 'V00017', 6, 32),
('VL00018', 'A', 'VN00018', 'V00018', 9, 32);

--24. TempVehLabel
INSERT INTO TempVehLabel (VehLblAppID, TempStartDate, TempExpiryDate)
VALUES
('VL00001', '2024-01-20', '2024-01-25'),
('VL00002', '2024-02-01', '2024-02-10'),
('VL00003', '2024-03-15', '2024-03-25'),
('VL00004', '2024-04-10', '2024-04-18'),
('VL00005', '2024-05-05', '2024-05-15'); 


SELECT * FROM Account;
SELECT * FROM Announcement;
SELECT * FROM Booking;
SELECT * FROM BookSlot;
SELECT * FROM Condo;
SELECT * FROM CondoMgmt;
SELECT * FROM CondoUsefulContact;
SELECT * FROM ContactCat;
SELECT * FROM Facility;
SELECT * FROM FacTimeSlot;
SELECT * FROM Feedback;
SELECT * FROM FeedbkCat;
SELECT * FROM ItemCategory;
SELECT * FROM Message;
SELECT * FROM ItemPhoto;
SELECT * FROM ItemRelated;
SELECT * FROM Likes;
SELECT * FROM Owner;
SELECT * FROM Staff;
SELECT * FROM TempVehLabel;
SELECT * FROM Tenant;
SELECT * FROM UsefulContact;
SELECT * FROM Vehicle;
SELECT * FROM VehicleLabel;
