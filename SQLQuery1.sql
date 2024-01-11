
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
	StaffID			smallint	not null,
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
	make		varchar(20)	not null,
	Model		varchar(20)	not null,

	constraint PK_Vehicle primary key (VehicleNo)
)

/*	Tables with no foreign key Ends Here	*/

--7. (Table 1)
create table Account
(
	AccID		smallint		not null,
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
	CondoMgmtID		smallint		not null,
	ContactPerson	varchar(100)	not null,
	CtcPersonMobile	char(8)			not null	unique,

	constraint PK_CondoMgmt primary key (CondoMgmtID),
	constraint FK_CondoMgmt_CondoMgmtID foreign key(CondoMgmtID)
		references Account (AccID)
)

--9. (Table 18)
create table Owner
(
	OwnerID			smallint	not null,
	OwnStartDate	date		not null,	
	CheckedBy		smallint	null,

	constraint PK_Owner primary key (OwnerID),
	constraint FK_Owner_OwnerID foreign key (OwnerID)
		references Account (AccID),
	constraint FK_Owner_CheckedBy foreign key (CheckedBy)
		references Account (AccID),
	
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
		references Account (AccID),
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

--12. (Table 3)
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
	constraint FK_Booking_FacID foreign key (FacID)
		references Facility (FacID)
)

--13. (Table 10)
create table FacTimeSlot
(
	FacID		char(10)		not null,
	TimeSlotSN	tinyint			not null,
	SlotDesc	varchar(100)	not null,

	constraint PK_FacTimeSlot primary key (FacID,TimeSlotSN),
	constraint FK_FacTimeSlot_FacID	foreign key (FacID)
		references Facility (FacID)
)

--14. (Table 4)
create table BookSlot
(
	FacID		char(10)	not null,
	TimeSlotSN	tinyint		not null,
	SlotDate	datetime	not null,
	SlotStatus	char(1)		not null	check(SlotStatus in ('A','B','M')),

	constraint PK_BookSlot primary key (FacID,TimeSlotSN),
	constraint FK_BookSlot_FacID_TimeSlotSN foreign key (FacID,TimeSlotSN)
		references FacTimeSlot (FacID,TimeSlotSN)

)

--15. (Table 11)
create table Feedback
(
	FbkID		char(10)	not null,
	FbkDesc		text		not null,
	FbkDateTime	datetime	not null	default(getdate())	check(FbkDateTime <= getdate()),
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
		references Account (AccID),

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
	
	constraint PK_ItemPhoto primary key (ItemID),
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

--20. (Table )
create table  Tenent
(
	TenentID			smallint	not null,
	ContactStartDate	date		not null	default(getdate()),
	ContactEndDate 		date		not null,
	VerifiedBy			smallint	null,

	constraint PK_Tenent primary key (TenentID),
	constraint FK_Tenent_TenentID foreign key (TenentID)
		references Account(AccID),
	constraint FK_Tenent_VerifiedBy foreign key (VerifiedBy)
		references Account (AccID),
	constraint CK_Tenent_ContactEndDate check(ContactStartDate <= ContactEndDate),
)

--21. (Table )
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

--22. (Table )
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

--23. (Table )
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
		references Account (AccID),
)

--24. (Table )
create table TempVehLabel
(
	VehLblAppID		char(10)	not null,
	TempStartDate	date		not null,
	TempExpiryDate	date		not null,

	constraint PK_TempVehLabel primary key (VehLblAppID),
	constraint FK_TempVehLabel foreign key (VehLblAppID)
		references Vehicle (VehicleNo),
	constraint CK_TempVehLabel_TempExpiryDate check(TempExpiryDate>=TempStartDate),
)


/*
1.	Condo
2.	ContactCat
3.	FeedbkCat
4.	ItemCategory
5.	Staff
6.	Vehicle

7.	Account
8.	CondoMgmt
9.	Owner
10.	Annoucement
11.	Facility
12. Booking
13. FacTimeSlot
14.	BookSlot
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

*/
---------------STOP HERE-----------------------------------------------------
