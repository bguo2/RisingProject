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
	SELECT @userId = Id FROM owners WHERE Id = _Id;
    IF @userId is NULL THEN
		INSERT INTO owners VALUES(_Id, _FirstName, _LastName, _Address, _City, _State, _PostCode, _BankName, _BankRoutingNumber, _BankAccount, _Phone);
    ELSE
		UPDATE owners SET FirstName = _FirstName, LastName = _LastName, Address = _Address, City = _City, State = _State,
			 PostCode = _PostCode, BankName = _BankName, BankRoutingNumber = _BankRoutingNumber, BankAccount = _BankAccount, Phone = _Phone
        WHERE Id = _Id;
    END IF;
END //
DELIMITER ;

