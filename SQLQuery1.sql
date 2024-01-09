create table Account
(
	AccID		smallint		not null,
	AccName		varchar(50)		not null,
	AccAddress	varchar(150)	null,
	AccCtcNo	char(8)			null,
	AccEmail	varchar(50)		null,
	CondoID		char(10)		not null,
	ApprovedBy	char(10)		not null,
	
	constraint PK_Account primary key (AccID),
	constraint FK_Account_CondoID foreign key (CondoID) 
		references Condo (CondoID),
	constraint FK_Account_ApprovedBy foreign key (ApprovedBy)
		references Staff (StaffID)
)

create table Annoucement
(
	AnnID			char(10)	not null,
	AnnText			text		not null,
	AnnStartDate	date		not null	check (AnnStartDate<=getdate()),
	AnnEndDate		date		not null	check (AnnStartDate<=getdate()),
	CondoMgmID		char(10)	not null,

	constraint Annoucement primary key (AnnID),
	constraint FK_Annoucement_CondoMgmID foreign key (CondoMgmID) 
		references CondoMgmt (CondoMgmID),
)

create table Booking
(
	BookingID		char(10)	not null,
	BookingDate		date		not null,
	BookingStatus	varchar(15)	not null	check(BookingStatus in ('Pending','Payment','Confirmed','Cancelled')),
	AccID			smallint	not null,
	FacID			char(10)	not null,
	TimeSlotSN		time		not null,
	SlotDate		date		not null,

	constraint Booking primary key (BookingID),
	constraint FK_Booking_AccID foreign key (AccID) 
		references Account (AccID),
	constraint FK_Booking_FacID foreign key (FacID) 
		references Facility (FacID),
)