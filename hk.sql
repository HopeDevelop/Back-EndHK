CREATE TABLE users (
	username VARCHAR(20) PRIMARY KEY,
	password VARCHAR(32) NOT NULL
);

CREATE TABLE donators (
	username VARCHAR(20) PRIMARY KEY,
	CONSTRAINT donators_username_fk FOREIGN KEY (username) REFERENCES users(username),
	favorites INT NOT NULL DEFAULT 0
);

CREATE TABLE receptors (
	username VARCHAR(20) PRIMARY KEY,
	CONSTRAINT receptors_username_fk FOREIGN KEY (username) REFERENCES users(username),
	cnpj VARCHAR(20) NOT NULL UNIQUE,
	address VARCHAR(100) NOT NULL,
	email VARCHAR(100),
	site VARCHAR(200)
);

CREATE TABLE phone_numbers (
	username VARCHAR(20) NOT NULL,
	CONSTRAINT phone_numbers_username_fk FOREIGN KEY (username) REFERENCES users(username),
	phone_number VARCHAR(20) NOT NULL,
	PRIMARY KEY (username, phone_number)
);

CREATE TABLE favorites (
	donator VARCHAR(20) NOT NULL,
	CONSTRAINT favorites_donator_fk FOREIGN KEY (donator) REFERENCES donators(username),
	receptor VARCHAR(20) NOT NULL,
	CONSTRAINT favorites_receptor_fk FOREIGN KEY (receptor) REFERENCES receptors(cnpj),
	PRIMARY KEY (donator, receptor)
);

DELIMITER \\

-- PARAMS:
-- donator : USERNAME DO USUÁRIO DOADOR
-- receptor : CNPJ DO USUÁRIO RECEPTOR
CREATE PROCEDURE insert_favorite (donator VARCHAR(20), receptor VARCHAR(20)) BEGIN
	SELECT donators.favorites INTO @amount FROM donators WHERE donators.username = donator;

	IF @amount < 10 THEN
		SET @amount = @amount + 1;
		INSERT INTO favorites VALUES (username, receptor);
		UPDATE donators SET donators.favorites = @amount WHERE donators.username = donator;
	END IF;
END;\\

CREATE TRIGGER delete_favorite AFTER DELETE ON favorites
FOR EACH ROW BEGIN
	SELECT donators.favorites INTO @amount FROM donators WHERE donators.username = OLD.donator;
	SET @amount = @amount - 1;
	UPDATE donators SET donators.favorites = @amount WHERE donators.username = OLD.donator;
END;\\

DELIMITER ;
