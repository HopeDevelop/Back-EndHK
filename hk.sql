CREATE TABLE flags (
	name VARCHAR(30) PRIMARY KEY
);

INSERT INTO flags VALUES
('Alimento'),
('Roupa'),
('Medicamento'),
('Em espécie'),
('Animais'),
('Crianças'),
('Idosos'),
('Hospitais'),
('Vacinação'),
('Dependência Química'),
('Sem-teto'),
('Serviços'),
('Desastres'),
('Imigração'),
('Violência doméstica');

CREATE TABLE users (
	username VARCHAR(20) PRIMARY KEY,
	password VARCHAR(32) NOT NULL
);

CREATE TABLE admins (
	username VARCHAR(20) PRIMARY KEY,
	CONSTRAINT admins_username_fk FOREIGN KEY (username) REFERENCES users(username)
);

CREATE TABLE donators (
	username VARCHAR(20) PRIMARY KEY,
	CONSTRAINT donators_username_fk FOREIGN KEY (username) REFERENCES users(username),
	favorites INT NOT NULL DEFAULT 0
);

CREATE TABLE receptors (
	username VARCHAR(20) PRIMARY KEY,
	CONSTRAINT receptors_username_fk FOREIGN KEY (username) REFERENCES users(username),
	name VARCHAR(100) NOT NULL,
	cnpj VARCHAR(20) NOT NULL UNIQUE,
	address VARCHAR(100) NOT NULL,
	email VARCHAR(100),
	site VARCHAR(2000)
);

CREATE TABLE receptor_flags (
	cnpj VARCHAR(20) NOT NULL,
	CONSTRAINT receptor_flags_cnpj_fk FOREIGN KEY (cnpj) REFERENCES receptors(cnpj),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT receptor_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (cnpj, flag)
);

CREATE TABLE donations (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	cnpj VARCHAR(20) NOT NULL,
	CONSTRAINT donations_cnpj_fk FOREIGN KEY (cnpj) REFERENCES receptors(cnpj),
	title VARCHAR(50) NOT NULL,
	description TEXT NOT NULL,
	link VARCHAR(2000)
);

CREATE TABLE donation_flags (
	id INT NOT NULL,
	CONSTRAINT donation_flags_id_fk FOREIGN KEY (id) REFERENCES donations(id),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT donation_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (id, flag)
);

CREATE TABLE events (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	cnpj VARCHAR(20) NOT NULL,
	CONSTRAINT events_cnpj_fk FOREIGN KEY (cnpj) REFERENCES receptors(cnpj),
	location VARCHAR(50) NOT NULL,
	address VARCHAR(100) NOT NULL,
	edate DATE NOT NULL,
	etime TIME NOT NULL
);

CREATE TABLE event_flags (
	id INT NOT NULL,
	CONSTRAINT event_flags_id_fk FOREIGN KEY (id) REFERENCES events(id),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT event_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (id, flag)
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

CREATE TABLE receptor_requests (
	username VARCHAR(20) PRIMARY KEY,
	CONSTRAINT receptors_username_fk FOREIGN KEY (username) REFERENCES users(username),
	name VARCHAR(100) NOT NULL,
	cnpj VARCHAR(20) NOT NULL UNIQUE,
	address VARCHAR(100) NOT NULL,
	email VARCHAR(100),
	site VARCHAR(2000)
);

CREATE TABLE receptor_requests_flags (
	cnpj VARCHAR(20) NOT NULL,
	CONSTRAINT receptor_flags_cnpj_fk FOREIGN KEY (cnpj) REFERENCES receptors(cnpj),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT receptor_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (cnpj, flag)
);

CREATE TABLE donation_requests (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	cnpj VARCHAR(20) NOT NULL,
	CONSTRAINT donations_cnpj_fk FOREIGN KEY (cnpj) REFERENCES receptors(cnpj),
	title VARCHAR(50) NOT NULL,
	description TEXT NOT NULL,
	link VARCHAR(2000)
);

CREATE TABLE donation_requests_flags (
	id INT NOT NULL,
	CONSTRAINT donation_flags_id_fk FOREIGN KEY (id) REFERENCES donations(id),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT donation_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (id, flag)
);

CREATE TABLE event_requests (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	cnpj VARCHAR(20) NOT NULL,
	CONSTRAINT events_cnpj_fk FOREIGN KEY (cnpj) REFERENCES receptors(cnpj),
	location VARCHAR(50) NOT NULL,
	address VARCHAR(100) NOT NULL,
	edate DATE NOT NULL,
	etime TIME NOT NULL
);

CREATE TABLE event_requests_flags (
	id INT NOT NULL,
	CONSTRAINT event_flags_id_fk FOREIGN KEY (id) REFERENCES events(id),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT event_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (id, flag)
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
