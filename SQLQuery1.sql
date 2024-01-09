--Table 5
create table Condo
(
	CondoID			char(10)	not null,
	CondoName		varchar(10)	not null,
	CondoAddress	text		not null,

	constraint PK_Condo primary key (CondoID),
)

--Table 6
create table CondoMgmt
(
	CondoMgmtID		char(10)		not null,
	ContactPerson	varchar(100)	not null,
	CtcPersonMobile	char(8)			not null,

	constraint PK_CondoMgmt primary key (CondoMgmtID),
)

--Table 8
create table ContactCat
(
	CtcCatID	char(10)		not null,
	CtcCatDesc	varchar(150)	not null,

	constraint PK_ContactCat primary key (CtcCatID)
)

--Table 12
create table FeedbkCat
(
	FbkCatID	char(10)		not null,
	FbkCatDesc	varchar(150)	not null,

	constraint PK_FeedbkCat primary key (FbkCatID)
)

--Table 13
create table ItemCategory
(
	ItemCatID	char(10)		not null,
	ItemCatDesc	varchar(150)	not null,

	constraint PK_ItemCategory primary key (ItemCatID)
)

--Table 18
create table Owner
(
	OwnerID			smallint	not null,
	OwnStartDate	date		not null,

	constraint PK_Owner primary key (OwnerID)
)

--Table 19
create table Staff
(
	StaffID			smallint	not null,
	StaffName		varchar(50)	not null,
	StaffContactNo	char(8)		not null,
	StaffDateJoined	date		not null default(getdate()),
	StaffRole		varchar(50)	not null check(StaffRole in ('Admin', 'Customer Service', 'Tech Support')),

	constraint PK_Staff primary key (StaffID)
)

--Table 23
create table Vehicle
(
	VehicleNo	char(10)	not null,
	IUNo		varchar(30)	not null,
	Ownership	varchar(20)	not null,
	make		varchar(20)	not null,
	Model		varchar(20)	not null,

	constraint PK_Vehicle primary key (VehicleNo)
)

--Table 1
create table Account
(
	AccID		smallint		not null,
	AccName		varchar(50)		not null,
	AccAddress	varchar(150)	null,
	AccCtcNo	char(8)			null,
	AccEmail	varchar(50)		not null,
	CondoID		char(10)		not null,
	ApprovedBy	smallint		not null,
	
	constraint PK_Account primary key (AccID),
	constraint FK_Account_CondoID foreign key (CondoID) 
		references Condo (CondoID),
	constraint FK_Account_ApprovedBy foreign key (ApprovedBy)
		references Staff (StaffID)
)

--Table 2
create table Announcement
(
	AnnID			char(10)	not null,
	AnnText			text		not null,
	AnnStartDate	date		not null default(getdate()),
	AnnEndDate		date		not null,
	CondoMgmID		char(10)	not null,

	constraint PK_Annoucement primary key (AnnID),
	constraint FK_Annoucement_CondoMgmID foreign key (CondoMgmID)
		references CondoMgmt (CondoMgmtID)
)

--Table 9
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

--Table 3
create table Booking
(
	BookingID		char(10)	not null,
	BookingDate		date		not null,
	BookingStatus	varchar(15)	not null check(BookingStatus in ('Pending','Payment','Confirmed','Cancelled')),
	AccID			smallint	not null,
	FacID			char(10)	not null,
	TimeSlotSn		time		not null,
	SlotDate		date		not null,

	constraint PK_Booking primary key (BookingID),
	constraint FK_Booking_AccID foreign key (AccID)
		references Account (AccID)
)

--Table 10
create table FacTimeSlot
(
	FacID		char(10)		not null,
	TimeSlotSN	tinyint			not null,
	SlotDesc	varchar(150)	not null,

	constraint PK_FacTimeSlot primary key (FacID,TimeSlotSN),
	constraint FK_FacTimeSlot_FacID	foreign key (FacID)
		references Facility (FacID)
)

--Table 4
create table BookSlot
(
	FacID		char(10)	not null,
	TimeSlotSN	tinyint		not null,
	SlotDate	datetime	not null,
	SlotStatus	varchar(15)	not null check(SlotStatus in ('Available''Booked','Manintenance')),

	constraint PK_BookSlot primary key (FacID,TimeSlotSN),
	constraint FK_BookSlot_FacID foreign key (FacID)
		references facility (FacID),
	constraint FK_BookSlot_TimeSlotSN foreign key (TimeSlotSN)
		references FacTimeSlot (TimeSlotSN)
)

--Table 11
create table Feedback
(
	FbkID		char(10)	not null,
	FbkDesc		text		not null,
	FbkDateTime	datetime	not null,
	FbkStatus	varchar(20)	not null check(FbkStatus in ('Sent','In Progress','Attended')),
	ByAccID		smallint	not null,
	FbkCatID	char(10)	not null,
	CondoMgmID	char(10)	null,

	constraint PK_Feedback primary key (FbkId),
	constraint FK_Feedback_ByAccID foreign key (ByAccID)
		references Account (AccID),
	constraint FK_Feedback_FbkCatID foreign key (FbkCatId)
		references FeedbkCat (FbkCatID)
)

--Table 17
create table Message
(
	MsgId		char(10)	not null,
	Msgtext		text		not null,
	Msgtype		varchar(20)	not null,
	PostedBy	smallint	not null,
	ReplyTo		char(10)	not null,
)

--Table 14
create table ItemPhoto
(
	ItemID	char(10)	not null,
	Photo	varchar(15)	not null,
	
	constraint PK_ItemPhoto primary key (ItemID),
	constraint FK_ItemPhot_ItemID foreign key (ItemID),
		references Message (MsgID)
)

--Table 15
create table ItemRelated
(
	ItemId		char(10)		not null,
	ItemDesc	varchar(150)	not null,
	ItemPrice	float			not null,
	ItemStatus	varchar(20)		not null check(ItemStatus in ('Available','Sold')),
	SaleOrRent	varchar(10)		not null check(SaleOrRent in ('Sale','Rent')),
	ItemCatId	char(10)		null,

	constraint PK_ItemRelated primary key (ItemID),
	constraint FK_ItemRelated_ItemID foreign key (ItemID)
		references Message (ItemID),
	constraint FK_ItemRelated_ItemCatID foreign key (ItemCatID)
		references ItemCategory (ItemCatId),
)

--Table 16
create table Likes
(
	AccID		smallint	not null,
	MessageID	char(10)	not null,

	constraint PK_Likes primary key (AccID,MessageID),
	constriant FK_Likes_AccID foreign key (AccID)
		references Account (AccID)
	constraint FK_Likes_MessageID foreign key (MessageID)
		references Message (MessageID)
)


/*
1.	Condo
2.	CondoMgmt
3.	ContactCat
4.	FeedbkCat
5.	ItemCategory
6.	Owner
7.	Staff
8.	Vehicle

9.	Account
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
20.	
21.	
22.	
23.	
24.	

*/

---------------STOP HERE-----------------------------------------------------
