create database risingapp;


create table owners(
	Id int(11) not null,
    FirstName varchar(50) not null,
    LastName varchar(50) not null,
    Address varchar(200) null,
    City varchar(50) null,
    State varchar(5) null,
    PostCode varchar(10) null,
    BankAccount varchar(50) null,
    Phone varchar(15) null,
    CONSTRAINT pk_owners_Id PRIMARY KEY (Id),
    CONSTRAINT fk_owners_users_id foreign key (Id) references aspnetusers(Id),
    INDEX idx_owner_FirstName(FirstName),
    INDEX idx_owner_LastName(LastName),
    INDEX idx_owner_First_Last(FirstName, LastName)
) ENGINE=INNODB;


create table houses(
	Id int(11) not null auto_increment unique,
	Address varchar(200) not null,
    City varchar(50) not null,
    State varchar(5) not null,
    PostCode varchar(10) not null,
    OwnerId int(11) null,
    CurrentRental decimal(10, 2) default 0,
    ManagementFee decimal(10, 2) default 0,
    IsRentedOut bool default false,
    Status varchar(100) null,
	CONSTRAINT pk_houses_Id PRIMARY KEY (Id),
    INDEX idx_houses_Address(Address),
    INDEX idx_houses_Address_City(Address, City),
    INDEX idx_houses_OwnerId(OwnerId),
    CONSTRAINT fk_houses_owner_id foreign key (OwnerId) references owners(Id)
) ENGINE=INNODB;


create table renters_personal(
	Id int(11) not null,
    FirstName varchar(50) not null,
    LastName varchar(50) not null,
    BirthDate date not null,
    SSN varchar(12) not null,
    DriverLicense varchar(15) null,
    DLState varchar(3) null,
    DLExpiryDate date null,
    HomePhone varchar(15) null,
    WorkPhone varchar(15) null,
    CONSTRAINT pk_renters_personal_Id PRIMARY KEY (Id),
    CONSTRAINT fk_renters_personal_users_id foreign key (Id) references aspnetusers(Id),
    INDEX idx_renters_personal_Id(Id),
    INDEX idx_renters_personal_FirstName_LastName(FirstName, LastName),
    INDEX idx_renters_personal_FirstName(FirstName),
    INDEX idx_renters_personal_LastName(LastName),
    INDEX idx_renters_personal_ssn(SSN)
) ENGINE=INNODB;


create table houses_income(
	Id bigint(20) not null auto_increment unique,
    HouseId int(11) not null,
    RenterId int(11) null,
    PaymentDate date null,
    Amount decimal(10, 2) default 0,
    Notes varchar(100) null,
	CONSTRAINT pk_housesstatus PRIMARY KEY (Id),
    INDEX idx_houses_status_Id (HouseId),
    INDEX idx_houses_status_RenterId(RenterId),
    INDEX idx_houses_status_HouseId_PaymentDate(HouseId, PaymentDate),
    INDEX idx_houses_status_RenterId_PaymentDate(RenterId, PaymentDate),
    INDEX idx_houses_status_houseId_RenterId_PaymentDate(HouseId, RenterId, PaymentDate),
    INDEX idx_houses_status_PaymentDate(PaymentDate),
    CONSTRAINT fk_housesstatus_id foreign key (HouseId) references houses(Id),
    CONSTRAINT fk_housesstatus_renterId foreign key (RenterId) references renters_personal(Id)
) ENGINE=INNODB;


create table renters_applications(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    HouseId int(11) not null,
    Deposit decimal(10, 2) default 0,
    DepositDate date null,
    ApplicationDate date not null,
    IsMainApplicant bool default false,
    StartDate date null,
    MoveInDate date null,
    MoveoutDate date null,
    ApprovalStatus varchar(20) not null,
    ApproveDate date null,
    ReturningTo varchar(50) null,
    ReturingAddress varchar(100) null,
    ReturingCity varchar(50) null,
    ReturningState varchar(3) null,
    ReturningPostCode varchar(10) null,
    Notes varchar(100) null,
    CONSTRAINT pk_renters_applications PRIMARY KEY (Id),
    CONSTRAINT fk_renters_applications_personal_RenterId foreign key (RenterId) references renters_personal(Id),
    CONSTRAINT fk_renters_applications_houses_Id foreign key (HouseId) references houses(Id),
    INDEX idx_renters_applications_HouseId (HouseId),
    INDEX idx_renters_applications_RenterId(RenterId),
    INDEX idx_renters_applications_RenterId_houseId (RenterId, HouseId),
    INDEX idx_renters_applications_ApplicationDate (ApplicationDate),
    INDEX idx_renters_applications_HouseId_ApprovalStatus (HouseId, ApprovalStatus),
    INDEX idx_renters_applications_RenterId_ApprovalStatus (RenterId, ApprovalStatus)
) ENGINE=INNODB;

create table renters_depends(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    Name varchar(60) null,
    RelationShip varchar(20) null,
    CONSTRAINT pk_renters_depends PRIMARY KEY (Id),
    CONSTRAINT fk_renters_depends_personal_id foreign key (RenterId) references renters_personal(Id),
    INDEX idx_renters_depends_RenterId(RenterId)
) ENGINE=INNODB;


create table renters_autos(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    Make varchar(30) null,
    Model varchar(20) null,
    Year varchar(5) null,
    LicenseNo varchar(20) not null,
    State varchar(3) null,
    Color varchar(10) null,
    CONSTRAINT pk_renters_autos PRIMARY KEY (Id),
    CONSTRAINT fk_renters_autos_personal_id foreign key (RenterId) references renters_personal(Id),
    INDEX idx_renters_autos_RenterId(RenterId)
) ENGINE=INNODB;

create table renters_Other(
	Id int(11) not null,
    RenterId int(11) not null,
	PetsNumber int default 0,
    PetsType varchar(20) null,
    EmergencyContact varchar(60) not null,
    RelationShip varchar(30) null,
    Phone varchar(15) null,
    LiquidFilledFurnitureType varchar(30),
    Bankruptcy varchar(200) null,
    Felony varchar(200) null,
    AskedToMoveOut varchar(200) null,
    CONSTRAINT pk_renters_autos PRIMARY KEY (Id),
    CONSTRAINT fk_renters_Other_id foreign key (RenterId) references renters_personal(Id),
    INDEX renters_Other_RenterId(RenterId)
) ENGINE=INNODB;


create table renters_residence_history(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    Address varchar(100) null,
    City varchar(30) null,
    State varchar(3) null,
    PostCode varchar(10) not null,
    FromDate date null,
    ToDate varchar(12) default null,
    Lanlord varchar(30) null,
    LanlordPhone varchar(15) null,
    OwnCurrentProperty bool default false,
    ReasonForLeavingCurrent varchar(200) null,
    IsCurrent bool default false,
    CONSTRAINT pk_renters_residence_history PRIMARY KEY (Id),
    CONSTRAINT fk_renters_residence_history_id foreign key (RenterId) references renters_personal(Id),
    INDEX idx_renters_residence_history_RenterId(RenterId)
) ENGINE=INNODB;

create table renters_employment_history(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    Employer varchar(60) null,
    Address varchar(150) null,
	FromDate date null,
    ToDate varchar(12) null,
    Supervisor varchar(30) null,
    SupervisorPhone varchar(15) null,
    Income decimal(10,2) default 0,
    IncomeType varchar(10) null,
    OtherIncome varchar(60) null,
    CONSTRAINT pk_renters_employment_history PRIMARY KEY (Id),
    CONSTRAINT fk_renters_employment_history_id foreign key (RenterId) references renters_personal(Id),
    INDEX idx_renters_employment_history_RenterId(RenterId)
) ENGINE=INNODB;

create table renters_creditor(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    Name varchar(60) not null,
    AccountNumber varchar(50) not null,
    MonthlyPayment decimal(10, 2) default 0,
    BalanceDue decimal(10, 2) default 0,
    CONSTRAINT pk_renters_creditor PRIMARY KEY (Id),
    CONSTRAINT fk_renters_creditor_RenterId foreign key (RenterId) references renters_personal(Id),
    INDEX idx_renters_creditor_RenterId(RenterId),
    INDEX idx_renters_creditor_RenterId_AccountNumber(RenterId, AccountNumber)
) ENGINE=INNODB;

create table renters_creditor_bank(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    Name varchar(60) not null,
    AccountNumber varchar(50) not null,
    AccountType varchar(20) null,
    AccountBalance decimal(10, 2) default 0,
    CONSTRAINT pk_renters_creditor_bank PRIMARY KEY (Id),
	CONSTRAINT fk_renters_creditor_bank_RenterId foreign key (RenterId) references renters_personal(Id),
    INDEX idx_renters_creditor_bank_RenterId(RenterId),
    INDEX idx_renters_creditor_bank_RenterId_AccountNumber(RenterId, AccountNumber)
) ENGINE=INNODB;

create table renters_references(
	Id int(11) not null auto_increment unique,
    RenterId int(11) not null,
    Name varchar(30) not null,
    Address varchar(100) null,
    Phone varchar(15) not null,
    AcquaintanceLength int default 0,
    Occupation varchar(30) null,    
    CONSTRAINT pk_renters_references PRIMARY KEY (Id),
    CONSTRAINT fk_renters_references_RenterId foreign key (RenterId) references renters_personal(Id),
    INDEX idx_renters_references_RenterId(RenterId),
    INDEX idx_renters_references_RenterId_Name(RenterId, Name)
) ENGINE=INNODB;


create table renters_relatives(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    Name varchar(30) not null,
    Address varchar(100) null,
    Phone varchar(15) not null,
    RelationShip varchar(30) null,
    CONSTRAINT pk_renters_relatives PRIMARY KEY (Id),
    CONSTRAINT fk_renters_relatives_RenterId foreign key (RenterId) references renters_personal(Id),
    INDEX idx_renters_relatives_RenterId(RenterId)
) ENGINE=INNODB;

create table renters_photocopies(
	Id bigint(20) not null auto_increment unique,
    RenterId int(11) not null,
    Description varchar(50) null,
    Path varchar(400) null,
    CONSTRAINT pk_renters_photocopies PRIMARY KEY (Id),
    CONSTRAINT fk_renters_photocopies_RenterId foreign key (RenterId) references renters_personal(Id),
	INDEX idx_renters_photocopies_RenterId(RenterId)
) ENGINE=INNODB;


