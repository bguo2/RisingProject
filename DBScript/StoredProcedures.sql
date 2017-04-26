use risingapp;

DROP PROCEDURE IF EXISTS `sp_check_user_exist`; 

DELIMITER //

CREATE PROCEDURE `sp_check_user_exist`(IN _Email varchar(256))
    SQL SECURITY INVOKER
BEGIN	
    SELECT Id FROM aspnetusers WHERE Email = _Email;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_assign_role`; 
DELIMITER //
CREATE PROCEDURE `sp_assign_role`(IN _Email varchar(256), IN _RoleName varchar(20))
BEGIN
	SET @userId = (SELECT Id FROM aspnetusers WHERE Email = _Email);
	SET @roleId = (SELECT Id FROM aspnetroles WHERE Name = _RoleName);
    IF (@userID is not NULL) AND (@roleId is not NULL) THEN
		INSERT INTO aspnetuserroles VALUES(@userId, @roleId);
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_create_owner`; 

DELIMITER //

CREATE PROCEDURE `sp_create_owner`(IN _Id int(11), IN _FirstName varchar(50), IN _LastName varchar(50), IN _Address varchar(200),
	IN _City varchar(50), IN _State varchar(5), IN _PostCode varchar(10), IN _BankName varchar(50), IN _BankRoutingNumber varchar(15),
	IN _BankAccount varchar(20), IN _Phone varchar(15))
    SQL SECURITY INVOKER
BEGIN
	SET @userId = (SELECT Id FROM owners WHERE Id = _Id);
    IF @userId is NULL THEN
		INSERT INTO owners VALUES(_Id, _FirstName, _LastName, _Address, _City, _State, _PostCode, _BankName, _BankRoutingNumber, _BankAccount, _Phone);
		SET @roleId = (SELECT Id FROM aspnetroles WHERE Name = 'Owner');
        INSERT INTO aspnetuserroles VALUES(@userId, @roleId);
    ELSE
		UPDATE owners SET FirstName = _FirstName, LastName = _LastName, Address = _Address, City = _City, State = _State,
			 PostCode = _PostCode, BankName = _BankName, BankRoutingNumber = _BankRoutingNumber, BankAccount = _BankAccount, Phone = _Phone
        WHERE Id = _Id;
    END IF;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `sp_create_house`; 

DELIMITER //

CREATE PROCEDURE `sp_create_house`(IN _Id int(11), IN _Address varchar(200), IN _City varchar(50), IN _State varchar(5), IN _PostCode varchar(10), 
	IN _OwnerId int(11), IN _CurrentRental decimal(10, 2), IN _ManagementFee decimal(10, 2), IN _IsRentedOut bool, IN _Notes varchar(100), OUT _HouseId int(11))
    SQL SECURITY INVOKER
BEGIN
	SET @update = true;
	IF _ID < 1 THEN		
		SET @update = false;
        SET @houseId = (SELECT Id FROM houses WHERE Address = _Address AND City = _City LIMIT 1);
        IF @houseId is NULL THEN
			INSERT INTO houses(Address, City, State, PostCode, OwnerId, CurrentRental, ManagementFee, IsRentedOut, Notes) 
            VALUES(_Address, _City, _State, _PostCode, _OwnerId, _CurrentRental, _ManagementFee, _IsRentedOut, _Notes);
            SET _HouseId = (SELECT Id FROM houses WHERE Address = _Address AND City = _City LIMIT 1);
		ELSE
			SET _Id = @houseId;
			SET @update = true;
        END IF;
    END IF;
    IF @update THEN
		UPDATE houses SET Address = _Address, City = _City, State = _State, PostCode = _PostCode,
			  OwnerId = _OwnerId, CurrentRental = _CurrentRental, ManagementFee = _ManagementFee, IsRentedOut = _IsRentedOut, Notes = _Notes
        WHERE Id = _Id;
        SET _HouseId = _Id;
    END IF;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `sp_get_houses_in_city`; 

DELIMITER //

CREATE PROCEDURE `sp_get_houses_in_city`(IN _City varchar(50), IN _State varchar(5), IN _IsRentedOut bool)
    SQL SECURITY INVOKER
BEGIN
	SELECT Id, Address, City, State, PostCode, CurrentRental FROM houses WHERE City = _City AND State = _State AND IsRentedOut = _IsRentedOut;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `sp_create_renter_personal_info`; 

DELIMITER //

CREATE PROCEDURE `sp_create_renter_personal_info`(IN _Id int(11), IN _FirstName varchar(50), IN _LastName varchar(50),
    IN _BirthDate date, IN _SSN varchar(12), IN _DriverLicense varchar(15), IN _DLState varchar(3), IN _DLExpiryDate date,
    IN _HomePhone varchar(15), IN _WorkPhone varchar(15))
    SQL SECURITY INVOKER
BEGIN
	SET @userId = (SELECT Id FROM renters_personal WHERE Id = _Id);
    IF @userId is NULL THEN
		INSERT INTO renters_personal VALUES(_Id, _FirstName, _LastName, _BirthDate, _SSN, _DriverLicense, _DLState, _DLExpiryDate, _HomePhone, _WorkPhone);
    ELSE
		UPDATE renters_personal SET FirstName = _FirstName, LastName = _LastName, BirthDate = _BirthDate, 
			SSN = _SSN, DriverLicense = _DriverLicense, DLState = _DLState, DLExpiryDate = _DLExpiryDate, HomePhone = _HomePhone, WorkPhone = _WorkPhone
        WHERE Id = _Id;
    END IF;
END //
DELIMITER ;

/*renter apply*/
DROP PROCEDURE IF EXISTS `sp_renter_apply`; 
DELIMITER //
CREATE PROCEDURE `sp_renter_apply`(IN _Id bigint(20), IN _RenterId int(11), IN _HouseId int(11), IN _ApplicationDate date, 
	IN _IsMainApplicant bool, IN _StartDate date, IN _Status int, IN _ReturningTo varchar(50),
    IN _ReturingAddress varchar(100), IN _ReturingCity varchar(50), IN _ReturningState varchar(3), IN _ReturningPostCode varchar(10))
    SQL SECURITY INVOKER
BEGIN
	SET @applicationId = NULL;
    /*check if the application exists or not*/
	IF _Id < 0 THEN
		SET @applicationId = (SELECT Id FROM renters_applications 
			WHERE RenterId = _RenterId AND HouseId = _HouseId AND Status < 3 
            AND ApplicationDate > DATE_SUB(CURDATE(), INTERVAL 15 DAY));
    END IF;
	
    IF @applicationId is NULL THEN
		INSERT INTO renters_applications (RenterId, HouseId, ApplicationDate, IsMainApplicant, StartDate, ApprovalStatus, 
			ReturningTo, ReturingAddress, ReturingCity, ReturningState, ReturningPostCode)
        VALUES(_RenterId, _HouseId, _ApplicationDate, _IsMainApplicant, _StartDate, 'Applying', 
			_ReturningTo, _ReturingAddress, _ReturingCity, _ReturningState, _ReturningPostCode);
    ELSE
		SET _Id = @applicationId;
		/*applicant withdraw the application*/
		if _ApprovalStatus = 'Withdrawn' THEN
			UPDATE renters_applications SET RenterId = _RenterId, HouseId = _HouseId, IsMainApplicant = _IsMainApplicant, 
				StartDate = _StartDate, ApprovalStatus = _ApprovalStatus, ReturningTo = _ReturningTo, 
				ReturingAddress = _ReturingAddress, ReturingCity = _ReturingCity, ReturningState = _ReturningState, ReturningPostCode = _ReturningPostCode
			WHERE applicationId = _Id;
        ELSE
			UPDATE renters_applications SET RenterId = _RenterId, HouseId = _HouseId, IsMainApplicant = _IsMainApplicant, 
				StartDate = _StartDate, ReturningTo = _ReturningTo, 
				ReturingAddress = _ReturingAddress, ReturingCity = _ReturingCity, ReturningState = _ReturningState, ReturningPostCode = _ReturningPostCode
			WHERE applicationId = _Id;
        END IF;
    END IF;
END //
DELIMITER ;

/*get application status*/
DROP PROCEDURE IF EXISTS `sp_get_application`; 
DELIMITER //
CREATE PROCEDURE `sp_get_application`(IN _RenterId int(11))
    SQL SECURITY INVOKER
BEGIN
	SET @applicationId = (SELECT Id FROM renters_applications WHERE Id = _Id);
    
END //
DELIMITER ;

/*Admin update application*/
DROP PROCEDURE IF EXISTS `sp_update_application_status`; 
DELIMITER //
CREATE PROCEDURE `sp_update_application_status`(IN _Id bigint(20), IN _RenterId int(11), IN _HouseId int(11), IN _Deposit decimal(10,2), IN _DepositDate date, 
	IN _StartDate date, IN _MoveInDate date, IN _MoveoutDate date, IN _ApprovalStatus varchar(20))
    SQL SECURITY INVOKER
BEGIN
	SET @applicationId = (SELECT Id FROM renters_applications WHERE Id = _Id);
    
END //
DELIMITER ;
