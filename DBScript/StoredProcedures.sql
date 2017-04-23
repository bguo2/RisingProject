use risingapp;

DROP PROCEDURE IF EXISTS `sp_check_user_exist`; 

DELIMITER //

CREATE PROCEDURE `sp_check_user_exist`(IN _Email varchar(256))
    SQL SECURITY INVOKER
BEGIN	
    SELECT Id FROM aspnetusers WHERE Email = _Email;
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

