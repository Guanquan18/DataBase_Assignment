
-- Switch to the new database
USE db_Assignment_my_own;
/*	start with Tables with no foreign key	*/

--1. (Table 5)
create table Condo
(
	CondoID			char(10)		not null,
	CondoName		varchar(50)		not null,
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
	FbkCatID	char(10)		not null,
	FbkCatDesc	varchar(50)		not null,

	constraint PK_FeedbkCat primary key (FbkCatID)
)

--4. (Table 13)
create table ItemCategory
(
	ItemCatID	char(10)		not null,
	ItemCatDesc	varchar(50)		not null,

	constraint PK_ItemCategory primary key (ItemCatID)
)

--5. (Table 19)
create table Staff
(
	StaffID			smallint IDENTITY(1,1) not null,
	StaffName		varchar(50)	not null,
	StaffContactNo	char(8)		not null	unique,
	StaffDateJoined	date		not null	default(getdate()),
	StaffRole		char(1)		not null	check(StaffRole in ('A', 'C', 'T')),

	constraint PK_Staff primary key (StaffID)
)

--6. (Table 23)
create table Vehicle
(
	VehicleNo	char(10)	not null,
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
	AccID		smallint IDENTITY(1,1) not null,
	AccName		varchar(50)		not null,
	AccAddress	varchar(150)	null,
	AccCtcNo	char(8)			null		unique,
	AccEmail	varchar(50)		not null	unique,
	CondoID		char(10)		not null,
	ApprovedBy	smallint		not null,
	
	constraint PK_Account primary key (AccID),
	constraint FK_Account_CondoID foreign key (CondoID) 
		references Condo (CondoID),
	constraint FK_Account_ApprovedBy foreign key (ApprovedBy)
		references Staff (StaffID)
)

--8. (Table 6)

create table CondoMgmt
(
	CondoMgmtID		smallint,
	ContactPerson	varchar(100)	not null,
	CtcPersonMobile	char(8)			not null	unique,

	constraint PK_CondoMgmt primary key (CondoMgmtID),
	constraint FK_CondoMgmt_CondoMgmtID foreign key(CondoMgmtID)
		references Account (AccID)
)


--9. (Table 18)
create table Owner
(
	OwnerID			smallint not null,
	OwnStartDate	date		not null,	
	CheckedBy		smallint	null,

	constraint PK_Owner primary key (OwnerID),
	constraint FK_Owner_OwnerID foreign key (OwnerID)
		references Account (AccID),
	constraint FK_Owner_CheckedBy foreign key (CheckedBy)
		references CondoMgmt (CondoMgmtID),
	
)

--10. (Table 2)
create table Announcement
(
	AnnID			char(10)	not null,
	AnnText			text		not null,
	AnnStartDate	date		not null	default(getdate()),
	AnnEndDate		date		not null,
	CondoMgmID		smallint	not null,

	constraint PK_Annoucement primary key (AnnID),
	constraint FK_Annoucement_CondoMgmID foreign key (CondoMgmID)
		references CondoMgmt (CondoMgmtID),
	constraint CK_Announcement_AnnEndDate check(AnnStartDate<=AnnEndDate), 
)

--11. (Table 9)
create table Facility
(
	FacID	char(10)		not null,
	FacName	varchar(100)	not null,
	Deposit	smallmoney		null,
	CondoID	char(10)		not null,

	constraint PK_Facility primary key (FacID),
	constraint FK_Facility_CondoID foreign key (CondoID)
		references Condo (CondoID)
)



--12. (Table 10)
create table FacTimeSlot
(
	FacID		char(10)		not null,
	TimeSlotSN	tinyint			not null,
	SlotDesc	varchar(100)	not null,

	constraint PK_FacTimeSlot primary key (FacID,TimeSlotSN),
	constraint FK_FacTimeSlot_FacID	foreign key (FacID)
		references Facility (FacID)
)

--13. (Table 4)
create table BookSlot
(
	FacID		char(10)	not null,
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
	BookingID		char(10)	not null,
	BookingDate		date		not null,
	BookingStatus	char(2)		not null	check(BookingStatus in ('PP','CF','CC')),
	AccID			smallint	not null,
	FacID			char(10)	not null,
	TimeSlotSn		tinyint		not null,
	SlotDate		date		not null,

	constraint PK_Booking primary key (BookingID),
	constraint FK_Booking_AccID foreign key (AccID)
		references Account (AccID),
	constraint FK_Booking_FacID_TimeSlotSn_SlotDate foreign key (FacID,TimeSlotSN,SlotDate)
		references BookSlot (FacID,TimeSlotSN,SlotDate)
)

--15. (Table 11)
create table Feedback
(
	FbkID		char(10)	not null,
	FbkDesc		text		not null,
	FbkDateTime	datetime	not null	default(getdate()),
	FbkStatus	char(1)		not null	check(FbkStatus in ('S','P','A')),
	ByAccID		smallint	not null,
	FbkCatID	char(10)	not null,
	CondoMgmID	smallint	null,

	constraint PK_Feedback primary key (FbkId),
	constraint FK_Feedback_ByAccID foreign key (ByAccID)
		references Account (AccID),
	constraint FK_Feedback_FbkCatID foreign key (FbkCatId)
		references FeedbkCat (FbkCatID),
	constraint FK_Feedback_CondoMgmID foreign key (CondoMgmID)
		references CondoMgmt (CondoMgmtID),
	constraint CK_Feedback_FbkDateTime check(FbkDateTime <= getdate())

)

--16. (Table 17)
create table Message
(
	MsgID		char(10)	not null,
	Msgtext		text		not null,
	Msgtype		char(1)		not null	check(MsgType in ('C','G','F')),
	PostedBy	smallint	not null,
	ReplyTo		char(10)	null,

	constraint PK_Message primary key (MsgID),
	constraint FK_Message_PostedBy foreign key (PostedBy)
		references Account (AccID),
	constraint FK_Message_ReplyTo foreign key (ReplyTo)
		references Message (MsgID)
)

--17. (Table 14)
create table ItemPhoto
(
	ItemID	char(10)	not null,
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
	SaleOrRent	char(4)			not null	check(SaleOrRent in ('Sale','Rent')),
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
	AccID		smallint	not null,
	MessageID	char(10)	not null,

	constraint PK_Likes primary key (AccID,MessageID),
	constraint FK_Likes_AccID foreign key (AccID)
		references Account (AccID),
	constraint FK_Likes_MessageID foreign key (MessageID)
		references Message (MsgID)
)

--20. (Table 21)

create table  Tenant
(
	TenantID			smallint not null,
	ContactStartDate	date		not null	default(getdate()),
	ContactEndDate 		date		not null,
	VerifiedBy			smallint	null,

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
	UsefulCtcName	varchar(50)		not null,
	UsefulCtcDesc	varchar(150)	null,
	UsefulCtcPhone	char(8)			not null	unique,
	CtcCatId		char(10)		null,

	constraint PK_UsefulContact primary key (UsefulCtcID),
	constraint FK_UsefulContact_CtcCatID foreign key (CtcCatId)
		references ContactCat (CtcCatID)
)

--22. (Table 7)
create table CondoUsefulContact
(
	CondoID		char(10)	not null,
	UsefulCtcID	char(10)	not null,

	constraint PK_CondoUsefulContact primary key (CondoID,UsefulCtcID),
	constraint FK_CondoUsefulContact_CondoID foreign key (CondoID)
		references Condo (CondoID),
	constraint FK_CondoUsefulContact_UsefulCtcID foreign key (UsefulCtcID)
		references UsefulContact (UsefulCtcID),
)

--23. (Table 24)
create table VehicleLabel 
(
	VehLblAppID		char(10)	not null,
	VehLblStatus	char(1)		not null	check(VehLblStatus in ('P','A','R')),
	VehLblNum		char(10)	not null	unique,
	VehicleNo		char(10)	not null,
	AppliedBy		smallint	not null,
	IssuedBy		smallint	null,

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
	VehLblAppID		char(10)	not null,
	TempStartDate	date		not null,
	TempExpiryDate	date		not null,

	constraint PK_TempVehLabel primary key (VehLblAppID),
	constraint FK_TempVehLabel foreign key (VehLblAppID)
		references VehicleLabel (VehLblAppID),
	constraint CK_TempVehLabel_TempExpiryDate check(TempExpiryDate>=TempStartDate),
)

/* Inserting values for tables */
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
		('C015', 'The Interlace', '180 Depot Road, Singapore')
		select * from Condo

--2. ContactCat
	Insert into ContactCat
	values
		('CC001', 'Emergency Services'),
		('CC002', 'Healthcare'),
		('CC003', 'Maintenance'),
		('CC004', 'Community Services'),
		('CC005', 'Amenties'),
		('CC006', 'Others')
	select * from ContactCat;

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
		('FC008', 'Others')
	select * from FeedbkCat;

--4.ItemCategory
	Insert INTO ItemCategory
	values 
		('IC001', 'Homeware'),
		('IC002', 'Fashion'),
		('IC003', 'Furniture'),
		('IC004', 'Electronics'),
		('IC005', 'Sports and Outdoors'),
		('iC006', 'Toys and Games')
	select * from ItemCategory;

--5.Staff
	Insert into staff(StaffName,StaffContactNo,StaffDateJoined,StaffRole)
	values
		('S.Sairam','94556614','2020-01-12','A'),
		('Chang Guan Qaun','91234567','2019-03-21','C'),
		('Keshwindren', '82345678', '2021-06-14', 'T'),
		('Jeremy Sim', '84561289', '2018-08-15', 'A'),
		('Lirone Lim', '83124675', '2018-02-27', 'T'),
		('Kedric Yeo', '87654321', '2022-07-23', 'T'),
		('David Yee', '84327890', '2020-04-24', 'A'),
		('Jerrell Lim', '86543210', '2021-03-21', 'C'),
		('Arthur Wang', '96789012', '2019-08-20', 'T'),
		('Jadan Sancho', '84121090', '2021-06-11', 'A'),
		('Lionel Messi', '97890123', '2020-02-12', 'C'),
		('Cristiano Ronaldo', '83411098', '2021-04-13', 'A'),
		('Pey Zhi Xun', '88911234', '2023-01-24', 'A'),
		('Jovan Tan', '93210987', '2023-01-25', 'C'),
		('Vijay', '89012123', '2023-07-16', 'T');
	select * from Staff;
		


--6.Vehicle
	Insert into Vehicle
	values
	('V001', 'IU12345678', 'OW', 'Toyota', 'RAV4'),
    ('V002', 'IU98765432', 'RT', 'Nissan', 'Rogue'),
    ('V003', 'IU87654321', 'CC', 'Ford', 'Mustang'),
    ('V004', 'IU23456789', 'OT', 'Chevrolet', 'Camaro'),
    ('V005', 'IU34567890', 'CC', 'Nissan', 'Altima'),
    ('V006', 'IU54321987', 'RT', 'BMW', '5 Series'),
    ('V007', 'IU81726354', 'OT', 'Mercedes-Benz', 'GLC'),
    ('V008', 'IU01928374', 'OT', 'Mercedes-Benz', 'E-Class'),
    ('V009', 'IU56789012', 'OW', 'Honda', 'Civic'),
    ('V010', 'IU10203040', 'RT', 'Kia', 'Optima'),
    ('V011', 'IU21324165', 'CC', 'Tesla', 'Model X'),
    ('V012', 'IU34127691', 'OT', 'Lexus', 'ES'),
    ('V013', 'IU90785634', 'OW', 'Mazda', 'Mazda6'),
    ('V014', 'IU09807061', 'RT', 'Volkswagen', 'Tiguan	'),
    ('V015', 'IU40782367', 'OW', 'BMW', 'X3');

	SELECT * from Vehicle

	
--7.Account
	Insert into Account (AccName, AccAddress, AccCtcNo, AccEmail, CondoID, ApprovedBy)
	values
	-- lAST 10 are CondoMgr
	('John Tan', 'Blk 3, 8 Marina Boulevard, #05-118', '87345678', 'john.tan@gmail.com', 'C001', 1),
	('Steve Smith', 'Blk 4, 8 Marina Boulevard, #06-128', '88654321', 'steve.smith@gmail.com', 'C001', 2),
	('Virat Kohli', 'Blk 2, 8 Marina Boulevard, #04-108', '86781234', 'virat.kohli@gmail.com', 'C001', 2),
	('Dwayne Johnson', 'Blk 3, 8 Marina Boulevard, #05-115', '81218765', 'dwayne.johnson@gmail.com', 'C001', 1),
	('Taylor Swift', 'Blk 6, 8 Marina Boulevard, #03-101', '98765432', 'taylor.swift@gmail.com', 'C001', 1),
	('Lious Teo', 'Blk 5, 8 Marina Boulevard, #06-130', '80321678', 'lious.teo@gmail.com', 'C001', 3),
	('Ethan Lim', 'Blk 2, 8 Marina Boulevard, #07-131', '87654321', 'ethan.lim@gmail.com', 'C001', 4),
	('Selana Gomez', 'Blk 1, 8 Marina Boulevard, #04-110', '83567890', 'selana.gomez@gmail.com', 'C001', 4),
	('Harry Maguire', 'Blk 7, 8 Marina Boulevard, #07-135', '85432123', 'harry.maguire@gmail.com', 'C001', 5),
	('Rachel Tan', 'Blk 1, 1 King Albert Park, #05-118', '82358765', 'rachel.tan@gmail.com', 'C002', 6),
	('Alan Walker', 'Blk 1, 1 King Albert Park, #05-120', '87651234', 'alan.walker@gmail.com', 'C002', 6),
	('Annabelle Chua', 'Blk 2, 1 King Albert Park, #06-128', '84561234', 'annabelle.chua@gmail.com', 'C002', 7),
	('Sophia', 'Blk 2, 1 King Albert Park, #06-138', '86782341', 'sophia@gmail.com', 'C002', 7),
	('Chairmaine', 'Blk 3, 1 King Albert Park, #04-115', '87891234', 'chairmaine@gmail.com', 'C002', 8),
	('Bryan Lim', 'Blk 4, 1 King Albert Park, #03-108', '87892234', 'bryan.lim@gmail.com', 'C002', 8),
	('Enzo Tan', 'Blk 4, 1 King Albert Park, #03-105', '81234567', 'enzo.tan@gmail.com', 'C002', 10),
	('Fu Zheng Yi', 'Blk 5, 1 King Albert Park, #07-135', '82345678', 'fu.zhengyi@gmail.com', 'C002', 10),
	('Kevin De Bruyne', 'Blk 5, 1 King Albert Park, #07-138', '83456789', 'kevin.debruyne@gmail.com', 'C002', 9),
	('Tom Holland', 'Blk 1, 1 Lorong 20 Geylang, #05-118', '84567890', 'tom.holland@gmail.com', 'C003', 11),
	('Bruno Mars', 'Blk 1, 50 - 76 Punggol Walk, #05-120', '87890123', 'bruno.mars@gmail.com', 'C004', 5),
	('Fandi Ahmed', 'Blk 2, 7 Bishan Street 15, #05-118', '88901234', 'fandi.ahmed@gmail.com', 'C005', 6),
	('Iqball', 'Blk 3, 8 Kitchener Link, #06-133', '82134567', 'iqball@gmail.com', 'C006', 12),
	('Elysaa', 'Blk 7, 116-122 Serangoon Aveneue 3, #02-100', '83245678', 'elysaa@gmail.com', 'C007', 9),
	('Keefe Chua', 'Blk 5, 21 McCallum Street, #05-120', '81224567', 'keefe.chua@gmail.com', 'C008', 8),
    ('Eugene', 'Blk 5, Hougnag Avenue 6, #05-118', '83456889', 'eugene@gmail.com', 'C009', 13),
    ('Marcus', 'Blk 2, 28 Beach Road, #06-128', '85678902', 'marcus@gmail.com', 'C010', 15),
    ('Marcellus', 'Blk 3, 11-23 Sengkang Eaat Avenue, #03-103', '86789112', 'marcellus@gmail.com', 'C011', 7),
    ('Melson', 'Blk 9A, 9A - 23D Bartley Road, #04-110', '87891123', 'melson@gmail.com', 'C012', 10),
    ('Nicholas', 'Blk 4, 2 - 6B Simon Lane, #02-100', '88901254', 'nicholas@gmail.com', 'C013', 12),
    ('Luis', 'Blk 2, 5 Anthony Road, #03-115', '89812345', 'luis@gmail.com', 'C014', 11),
    ('Edric', 'Blk 5, 180 Depot Road, #06-130', '81023356', 'edric@gmail.com', 'C015', 8),
	('HorizonBloom', 'King Albert Park 1', '87624321', 'horizonbloom@example.com','C001',9),
	('SunRiseTech', 'Raffles Quay 45', '91234597', 'sunrise.tech@example.com','C002',3),
	('ClearView Innovations', 'Bukit Timah Road 22', '82345671', 'clearview.innov@example.com','C003',2),
	('StarLink Co.', 'Clarke Quay 78', '98165432', 'starlink@example.com','C004',12),
	('SkyGrove Enterprises', 'Marina Bay Sands 15', '87154321', 'skygrove.ent@example.com','C005',13),
	('SeaScape Solutions', 'East Coast Road 50', '82456789', 'seascape.sol@example.com','C006',11),
	('FreshHarbor Ventures', 'Jurong West Street 18', '89012345', 'fresh.harbor@example.com','C007',5),
	('BlueWave Industries', 'Yishun Avenue 2', '89654321', 'bluewave.ind@example.com','C008',8),
	('PurePulse Technologies', 'Serangoon Central 31', '91234567', 'purepulse.tech@example.com','C009',9),
	('EchoView Industries', 'Chinatown Point 40', '98865432', 'echoview@example.com','C010',6);
	SELECT * FROM Account;

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
	(41, 'Paul Walker', '98876543');
	Select * from CondoMgmt;

--9.Owner
	Insert Into Owner (OwnerID, OwnStartDate, CheckedBy)
	Values
	(2, '2022-01-01', 32),
	(4, '2022-02-15', 32),
	(6, '2022-03-10', 33),
	(8, '2022-04-22', null),
	(10, '2022-05-05', 35),
	(12, '2022-06-18', 36),
	(14, '2022-07-02', 36),
	(16, '2022-08-14', 36),
	(18, '2022-09-28', null),
	(20, '2022-10-11', 38),
	(22, '2022-11-24', 39),
	(24, '2022-12-07', 39),
	(26, '2023-01-20', 40),
	(28, '2023-02-03', 41),
	(30, '2023-03-17', null);
	Select * from Owner;

--10.Announcement
	Insert into Announcement (AnnID, AnnText, AnnStartDate, AnnEndDate, CondoMgmID)
	VALUES
	('A001', 'Important maintenance notice.', '2023-09-10', '2023-09-30', 32),
	('A002', 'Upcoming Chinese New Year Celebration on Saturday.', '2024-02-05', '2024-02-06', 32),
	('A003', 'New security measures implemented.', '2024-02-10', '2024-03-01', 32),
	('A004', 'Reminder: Monthly condo meeting on Friday.', '2024-02-15', '2024-02-15', 33),
	('A005', 'Pool area maintenance scheduled for next week.', '2023-12-20', '2024-12-25', 33),
	('A006', 'Changes to parking policy effective immediately.', '2023-11-25', '2024-12-10', 34),
	('A007', 'Celebrating our community achievements.', '2024-01-10', '2024-01-15', 34),
	('A008', 'Emergency contact numbers updated.', '2023-11-05', '2024-11-10', 35),
	('A009', 'Notice: Water supply disruption on Monday.', '2024-02-10', '2024-02-20', 36),
	('A010', 'Renovation work in progress. Apologies for inconvenience.', '2024-03-15', '2024-04-01', 37),
	('A011', 'Fire drill scheduled for this month.', '2024-01-20', '2024-01-21', 38),
	('A012', 'New fitness classes available. Join us!', '2024-02-25', '2024-04-10', 38),
	('A013', 'Reminder: Pay your monthly dues by end of the week.', '2024-03-28', '2024-03-31', 39),
	('A014', 'Community garden project meeting next Saturday.', '2024-03-30', '2024-04-01', 40),
	('A015', 'Update: Elevator maintenance on Tuesday.', '2024-02-05', '2024-02-06', 41);
	Select * from Announcement;

--11.Facility
	INSERT INTO Facility (FacID, FacName, Deposit, CondoID)
	VALUES
	-- F represents Facilty , C represents Condo, so F1C1, means facility 1 in condo 1. 6 facailty for Condo 1,2 rest condo only got 2 facility 
	('F1C1', 'Swimming Pool', NULL, 'C001'),
	('F2C1', 'Gym', 10.00, 'C001'),
	('F3C1', 'BBQ Pit Area', 30.00, 'C001'),
	('F4C1', 'Tennis Court', 10.00, 'C001'),
	('F5C1', 'Function Room', 50.00, 'C001'),
	('F6C1', 'Children Playground', NULL, 'C001'),
	('F1C2', 'Swimming Pool', NULL, 'C001'),
	('F2C2', 'Gym', 12.00, 'C002'),
	('F3C2', 'BBQ Pit Area', 35.00, 'C002'),
	('F4C2', 'Tennis Court', 11.00, 'C002'),
	('F5C2', 'Function Room', 50.00, 'C002'),
	('F6C2', 'Children Playground', NULL, 'C002'),
	('F1C3', 'Swimming Pool', NULL, 'C003'),
	('F2C3', 'Gym', 9.00, 'C003'),
	('F3C3', 'BBQ Pit Area', 30.00, 'C003'),
	('F4C3', 'Tennis Court', 10.00, 'C003'),
	('F5C3', 'Function Room', 50.00, 'C003'),
	('F6C3', 'Children Playground', NULL, 'C003'),
	('F1C4', 'Swimming Pool', NULL, 'C004'),
	('F4C4', 'Tennis Court', 13.00, 'C004'),
	('F2C5', 'Gym', NULL, 'C005'),
	('F3C5', 'BBQ Pit Area', 30.00, 'C005'),
	('F1C6', 'Swimming Pool', NULL, 'C006'),
	('F4C6', 'Tennis Court', NULL, 'C006'),
	('F2C7', 'Gym', NULL, 'C007'),
	('F3C7', 'BBQ Pit Area', 30.00, 'C007'),
	('F5C8', 'Function Room', 50.00, 'C008'),
	('F6C8', 'Children Playground', NULL, 'C008'),
	('F5C9', 'Function Room', 50.00, 'C009'),
	('F6C9', 'Children Playground', NULL, 'C009');
SELECT * From Facility;

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
('F4C4', 1, 'Morning Slot: 6 AM to 12 PM'),
('F4C4', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F4C4', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C005
('F2C5', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C5', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C5', 3, 'Evening Slot: 6 PM to 12 AM'),
('F3C5', 1, 'Morning Slot: 6 AM to 12 PM'),
('F3C5', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F3C5', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C006
('F1C6', 1, 'Morning Slot: 6 AM to 12 PM'),
('F1C6', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F1C6', 3, 'Evening Slot: 6 PM to 12 AM'),
('F4C6', 1, 'Morning Slot: 6 AM to 12 PM'),
('F4C6', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F4C6', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C007
('F2C7', 1, 'Morning Slot: 6 AM to 12 PM'),
('F2C7', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F2C7', 3, 'Evening Slot: 6 PM to 12 AM'),
('F3C7', 1, 'Morning Slot: 6 AM to 12 PM'),
('F3C7', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F3C7', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C008
('F5C8', 1, 'Morning Slot: 6 AM to 12 PM'),
('F5C8', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F5C8', 3, 'Evening Slot: 6 PM to 12 AM'),
('F6C8', 1, 'Morning Slot: 6 AM to 12 PM'),
('F6C8', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F6C8', 3, 'Evening Slot: 6 PM to 12 AM'),

-- Time slots for facilities in Condo C009
('F5C9', 1, 'Morning Slot: 6 AM to 12 PM'),
('F5C9', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F5C9', 3, 'Evening Slot: 6 PM to 12 AM'),
('F6C9', 1, 'Morning Slot: 6 AM to 12 PM'),
('F6C9', 2, 'Afternoon Slot: 12 PM to 6 PM'),
('F6C9', 3, 'Evening Slot: 6 PM to 12 AM');
Select * from FacTimeSlot

--13.BookSlot
INSERT INTO BookSlot(FacID, TimeSlotSN, SlotDate, SlotStatus)
VALUES
-- Time slots for facilities in Condo C001
('F1C1', 1, '2023-09-20', 'A'),
('F1C1', 2, '2023-09-20', 'M'),
('F1C1', 3, '2023-09-20', 'B'),
('F2C1', 1, '2023-09-19', 'A'),
('F2C1', 2, '2023-09-19', 'A'),
('F2C1', 3, '2023-09-19', 'A'),
('F3C1', 1, '2023-09-18', 'B'),
('F3C1', 2, '2023-09-18', 'M'),
('F3C1', 3, '2023-09-18', 'B'),
('F4C1', 1, '2023-09-17', 'A'),
('F4C1', 2, '2023-09-17', 'B'),
('F4C1', 3, '2023-09-17', 'A'),
('F5C1', 1, '2023-09-16', 'A'),
('F5C1', 2, '2023-09-16', 'B'),
('F5C1', 3, '2023-09-16', 'M'),
('F6C1', 1, '2023-09-15', 'B'),
('F6C1', 2, '2023-09-15', 'A'),
('F6C1', 3, '2023-09-15', 'B'),

-- Time slots for facilities in Condo C002
('F1C2', 1, '2023-09-20', 'B'),
('F1C2', 2, '2023-09-20', 'A'),
('F1C2', 3, '2023-09-20', 'B'),
('F2C2', 1, '2023-09-19', 'B'),
('F2C2', 2, '2023-09-19', 'A'),
('F2C2', 3, '2023-09-19', 'M'),
('F3C2', 1, '2023-09-18', 'A'),
('F3C2', 2, '2023-09-18', 'M'),
('F3C2', 3, '2023-09-18', 'B'),
('F4C2', 1, '2023-09-17', 'B'),
('F4C2', 2, '2023-09-17', 'M'),
('F4C2', 3, '2023-09-17', 'A'),
('F5C2', 1, '2023-09-16', 'A'),
('F5C2', 2, '2023-09-16', 'B'),
('F5C2', 3, '2023-09-16', 'B'),
('F6C2', 1, '2023-09-15', 'A'),
('F6C2', 2, '2023-09-15', 'A'),
('F6C2', 3, '2023-09-15', 'A'),

-- Time slots for facilities in Condo C003
('F1C3', 1, '2023-09-20', 'A'),
('F1C3', 2, '2023-09-20', 'A'),
('F1C3', 3, '2023-09-20', 'A'),
('F2C3', 1, '2023-09-19', 'B'),
('F2C3', 2, '2023-09-19', 'B'),
('F2C3', 3, '2023-09-19', 'M'),
('F3C3', 1, '2023-09-18', 'A'),
('F3C3', 2, '2023-09-18', 'B'),
('F3C3', 3, '2023-09-18', 'B'),
('F4C3', 1, '2023-09-17', 'A'),
('F4C3', 2, '2023-09-17', 'M'),
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
('F1C4', 3, '2023-09-20', 'B'),
('F4C4', 1, '2023-09-19', 'A'),
('F4C4', 2, '2023-09-19', 'B'),
('F4C4', 3, '2023-09-19', 'A'),

-- Time slots for facilities in Condo C005
('F2C5', 1, '2023-09-20', 'M'),
('F2C5', 2, '2023-09-20', 'B'),
('F2C5', 3, '2023-09-20', 'A'),
('F3C5', 1, '2023-09-19', 'B'),
('F3C5', 2, '2023-09-19', 'A'),
('F3C5', 3, '2023-09-19', 'B'),

-- Time slots for facilities in Condo C006
('F1C6', 1, '2023-09-20', 'B'),
('F1C6', 2, '2023-09-20', 'A'),
('F1C6', 3, '2023-09-20', 'M'),
('F4C6', 1, '2023-09-19', 'A'),
('F4C6', 2, '2023-09-19', 'B'),
('F4C6', 3, '2023-09-19', 'A'),

-- Time slots for facilities in Condo C007
('F2C7', 1, '2023-09-20', 'A'),
('F2C7', 2, '2023-09-20', 'M'),
('F2C7', 3, '2023-09-20', 'A'),
('F3C7', 1, '2023-09-19', 'A'),
('F3C7', 2, '2023-09-19', 'B'),
('F3C7', 3, '2023-09-19', 'M'),

-- Time slots for facilities in Condo C008
('F5C8', 1, '2023-09-20', 'A'),
('F5C8', 2, '2023-09-20', 'B'),
('F5C8', 3, '2023-09-20', 'B'),
('F6C8', 1, '2023-09-19', 'B'),
('F6C8', 2, '2023-09-19', 'B'),
('F6C8', 3, '2023-09-19', 'A'),

-- Time slots for facilities in Condo C009
('F5C9', 1, '2023-09-20', 'B'),
('F5C9', 2, '2023-09-20', 'A'),
('F5C9', 3, '2023-09-20', 'B'),
('F6C9', 1, '2023-09-19', 'M'),
('F6C9', 2, '2023-09-19', 'B'),
('F6C9', 3, '2023-09-19', 'M')
select * from BookSlot

--14.Booking
INSERT INTO Booking (BookingID, BookingDate, BookingStatus, AccID, FacID, TimeSlotSn, SlotDate)
VALUES
-- Account(1-9 in Condo 1 booked for facilty that are available in condo 1)
('B1C001', '2023-10-12', 'PP', 1, 'F1C1', 1, '2023-09-20'),
('B2C001', '2023-10-13', 'CC', 3, 'F1C1', 2, '2023-09-20'),
('B3C001', '2023-10-14', 'CF', 5, 'F1C1', 3, '2023-09-20'),
('B4C001', '2024-01-15', 'PP', 1, 'F2C1', 1, '2023-09-19'),
('B5C001', '2024-01-16', 'CF', 2, 'F2C1', 2, '2023-09-19'),
('B6C001', '2024-01-16', 'CF', 4, 'F2C1', 3, '2023-09-19'),
('B7C001', '2024-02-18', 'PP', 7, 'F3C1', 1, '2023-09-18'),
('B8C001', '2024-02-19', 'CF', 9, 'F3C1', 2, '2023-09-18'),
('B9C001', '2024-02-20', 'CC', 1, 'F3C1', 3, '2023-09-18'),
('B10C001', '2023-10-12', 'PP', 2, 'F4C1', 1, '2023-09-17'),
('B11C001', '2023-10-13', 'CF', 8, 'F4C1', 2, '2023-09-17'),
('B12C001', '2023-10-13', 'CF', 6, 'F4C1', 3, '2023-09-17'),
('B13C001', '2024-02-15', 'PP', 4, 'F5C1', 1, '2023-09-16'),
('B14C001', '2024-02-15', 'CF', 3, 'F5C1', 2, '2023-09-16'),
('B15C001', '2024-02-17', 'CC', 5, 'F5C1', 3, '2023-09-16'),
-- Account(10-18 in Condo 2 booked for facilty that are available in condo 2)
('B1C002', '2023-10-12', 'PP', 11, 'F1C2', 1, '2023-09-20'),
('B2C002', '2023-10-13', 'CC', 13, 'F1C2', 2, '2023-09-20'),
('B3C002', '2023-10-14', 'CF', 15, 'F1C2', 3, '2023-09-20'),
('B4C002', '2024-01-15', 'PP', 11, 'F2C2', 1, '2023-09-19'),
('B5C002', '2024-01-16', 'CF', 12, 'F2C2', 2, '2023-09-19'),
('B6C002', '2024-01-16', 'CF', 14, 'F2C2', 3, '2023-09-19'),
('B7C002', '2024-02-18', 'PP', 17, 'F3C2', 1, '2023-09-18'),
('B8C002', '2024-02-19', 'CF', 15, 'F3C2', 2, '2023-09-18'),
('B9C002', '2024-02-20', 'CC', 11, 'F3C2', 3, '2023-09-18'),
('B10C002', '2023-10-12', 'PP', 12, 'F4C2', 1, '2023-09-17'),
('B11C002', '2023-10-13', 'CF', 18, 'F4C2', 2, '2023-09-17'),
('B12C002', '2023-10-13', 'CF', 16, 'F4C2', 3, '2023-09-17'),
('B13C002', '2024-02-15', 'PP', 14, 'F5C2', 1, '2023-09-16'),
('B14C002', '2024-02-15', 'CF', 13, 'F5C2', 2, '2023-09-16'),
('B15C002', '2024-02-17', 'CC', 15, 'F5C2', 3, '2023-09-16');
Select * from Booking;

--15. Feedback
INSERT INTO Feedback (FbkID, FbkDesc, FbkDateTime, FbkStatus, ByAccID, FbkCatID, CondoMgmID)
VALUES
('FBK001', 'The hallway on the 3rd floor is not properly cleaned.', '2023-03-01 10:00:00', 'S', 5, 'FC001', 32),
('FBK002', 'The security gate is malfunctioning frequently.', '2023-03-02 15:30:00', 'P', 12, 'FC002', 32),
('FBK003', 'Leaky faucet in the community gym restroom.', '2023-03-03 09:00:00', 'S', 7, 'FC003', NULL),
('FBK004', 'Cracks observed on the sidewall of building B.', '2023-03-04 14:20:00', 'P', 15, 'FC004', 33),
('FBK005', 'Parking lot line markings are faded and need repainting.', '2023-03-05 13:00:00', 'S', 20, 'FC005', NULL),
('FBK006', 'Loud music from apartment 5B during late-night hours.', '2023-03-06 22:00:00', 'P', 9, 'FC006', 34),
('FBK007', 'Broken equipment in the fitness center.', '2023-03-07 16:45:00', 'S', 18, 'FC007', 35),
('FBK008', 'Littering around the community playground.', '2023-03-08 11:30:00', 'P', 22, 'FC001', NULL),
('FBK009', 'Elevator doors closing too quickly, posing a safety hazard.', '2023-03-09 17:15:00', 'S', 25, 'FC008', 36),
('FBK010', 'Inadequate lighting in the rear parking area.', '2023-03-10 20:50:00', 'P', 30, 'FC005', 37);
Select * from Feedback

--16. Message
INSERT INTO Message (MsgID, Msgtext, Msgtype, PostedBy, ReplyTo)
VALUES
('MSG00001', 'Looking for a jogging partner in our community. Anyone interested?', 'F', 5, NULL), 
('MSG00002', 'Hosting a garage sale this Saturday at Block 3. Lots of kids’ items and books!', 'G', 12, NULL),
('MSG00003', 'Can anyone recommend a reliable handyman for some minor repairs?', 'C', 15, NULL), 
('MSG00004', 'Lost dog spotted near the community park. Seems friendly. Please check if it’s yours.', 'C', 7, 'MSG00002'), 
('MSG00005', 'Interested in starting a community garden project. Who wants to join?', 'C', 22, NULL),
('MSG00006', 'Selling a gently used coffee table. DM for pictures and details.', 'G', 30, NULL), 
('MSG00007', 'Anyone up for a weekly board game night at the clubhouse?', 'F', 2, NULL), 
('MSG00008', 'Reminder: Don’t forget to vote in the condo board elections this Friday.', 'C', 9, NULL), 
('MSG00009', 'Looking for a tennis partner. I’m an intermediate player hoping to play on weekends.', 'F', 18, NULL),
('MSG00010', 'For sale: Vintage record player in great condition. Message if interested.', 'G', 25, NULL); 
Select * from Message

/* Tables without foreign key 
1.	Condo
2.	ContactCat
3.	FeedbkCat
4.	ItemCategory
5.	Staff
6.	Vehicle

Table with foreign key
7.	Account
8.	CondoMgmt
9.	Owner
10.	Annoucement
11.	Facility
12. FacTimeSlot
13. BookSlot
14.	Booking
15. Feedback
16.	Message
17.	ItemPhoto
18.	ItemRelated
19.	Likes
20.	Tenent
21.	UsefulContact
22.	CondoUsefulContact
23.	VehicleLabel
24.	TempVehLabel

Notes:  Last 10 of account is condomgmt
		Even numbers (from 1 to 31) in account is owner

*/
---------------STOP HERE-----------------------------------------
