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

CREATE TABLE admins (
	username VARCHAR(20) PRIMARY KEY,
	password VARCHAR(32) NOT NULL
);

CREATE TABLE donators (
	username VARCHAR(20) PRIMARY KEY,
	password VARCHAR(32) NOT NULL,
	favorites INT NOT NULL DEFAULT 0
);

CREATE TABLE receptors (
	username VARCHAR(20) PRIMARY KEY,
	password VARCHAR(32) NOT NULL,
	name VARCHAR(100) NOT NULL,
	cnpj VARCHAR(20) NOT NULL UNIQUE,
	address VARCHAR(100) NOT NULL,
	email VARCHAR(100),
	site VARCHAR(2000),
	description TEXT
);

CREATE TABLE receptor_flags (
	username VARCHAR(20) NOT NULL,
	CONSTRAINT receptor_flags_username_fk FOREIGN KEY (username) REFERENCES receptors(username),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT receptor_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (username, flag)
);

CREATE TABLE donations (
	username VARCHAR(20) NOT NULL,
	CONSTRAINT donations_username_fk FOREIGN KEY (username) REFERENCES receptors(username),
	title VARCHAR(50) NOT NULL,
	description TEXT NOT NULL,
	link VARCHAR(2000),
	PRIMARY KEY (username, title)
);

CREATE TABLE donation_flags (
	username VARCHAR(20) NOT NULL,
	title VARCHAR(50) NOT NULL,
	CONSTRAINT donations_pk FOREIGN KEY (username, title) REFERENCES donations(username, title),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT donation_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (username, title, flag)
);

CREATE TABLE events (
	username VARCHAR(20) NOT NULL,
	CONSTRAINT events_username_fk FOREIGN KEY (username) REFERENCES receptors(username),
	title VARCHAR(50) NOT NULL,
	description TEXT,
	location VARCHAR(50) NOT NULL,
	address VARCHAR(100) NOT NULL,
	bdate DATE NOT NULL,
	btime TIME NOT NULL,
	edate DATE NOT NULL,
	etime TIME NOT NULL,
	PRIMARY KEY (username, title)
);

CREATE TABLE event_flags (
	username VARCHAR(20) NOT NULL,
	title VARCHAR(50) NOT NULL,
	CONSTRAINT event_pk FOREIGN KEY (username, title) REFERENCES events(username, title),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT event_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (username, title, flag)
);

CREATE TABLE phone_numbers (
	username VARCHAR(20) NOT NULL,
	CONSTRAINT phone_numbers_username_fk FOREIGN KEY (username) REFERENCES receptors(username),
	phone_number VARCHAR(20) NOT NULL,
	PRIMARY KEY (username, phone_number)
);

CREATE TABLE favorites (
	donator VARCHAR(20) NOT NULL,
	CONSTRAINT favorites_donator_fk FOREIGN KEY (donator) REFERENCES donators(username),
	receptor VARCHAR(20) NOT NULL,
	CONSTRAINT favorites_receptor_fk FOREIGN KEY (receptor) REFERENCES receptors(username),
	PRIMARY KEY (donator, receptor)
);

CREATE TABLE receptor_requests (
	username VARCHAR(20) PRIMARY KEY,
	password VARCHAR(32) NOT NULL,
	name VARCHAR(100) NOT NULL,
	cnpj VARCHAR(20) NOT NULL UNIQUE,
	address VARCHAR(100) NOT NULL,
	email VARCHAR(100),
	site VARCHAR(2000),
	description TEXT
);

CREATE TABLE receptor_requests_flags (
	username VARCHAR(20) NOT NULL,
	CONSTRAINT receptor_requests_flags_username_fk FOREIGN KEY (username) REFERENCES receptor_requests(username),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT receptor_requests_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (username, flag)
);

CREATE TABLE donation_requests (
	username VARCHAR(20) NOT NULL,
	CONSTRAINT donations_requests_username_fk FOREIGN KEY (username) REFERENCES receptors(username),
	title VARCHAR(50) NOT NULL,
	description TEXT NOT NULL,
	link VARCHAR(2000),
	PRIMARY KEY (username, title)
);

CREATE TABLE donation_requests_flags (
	username VARCHAR(20) NOT NULL,
	title VARCHAR(50) NOT NULL,
	CONSTRAINT donation_requests_pk FOREIGN KEY (username, title) REFERENCES donation_requests(username, title),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT donation_requests_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (username, title, flag)
);

CREATE TABLE event_requests (
	username VARCHAR(20) NOT NULL,
	CONSTRAINT events_requests_username_fk FOREIGN KEY (username) REFERENCES receptors(username),
	title VARCHAR(50) NOT NULL,
	location VARCHAR(50) NOT NULL,
	address VARCHAR(100) NOT NULL,
	edate DATE NOT NULL,
	etime TIME NOT NULL,
	PRIMARY KEY (username, title)
);

CREATE TABLE event_requests_flags (
	username VARCHAR(20) NOT NULL,
	title VARCHAR(50) NOT NULL,
	CONSTRAINT event_requests_pk FOREIGN KEY (username, title) REFERENCES event_requests(username, title),
	flag VARCHAR(30) NOT NULL,
	CONSTRAINT event_requests_flags_flag_fk FOREIGN KEY (flag) REFERENCES flags(name),
	PRIMARY KEY (username, title, flag)
);



CREATE OR REPLACE FUNCTION new_donator (un VARCHAR(20), pw VARCHAR(32)) RETURNS BOOLEAN AS $$
BEGIN
	INSERT INTO donators(username, password) VALUES (un, pw);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION new_receptor (
	un VARCHAR(20), pw VARCHAR(32), pname VARCHAR(100), pcnpj VARCHAR(20),
	paddress VARCHAR(100), pemail VARCHAR(100), psite VARCHAR(2000), pdescription TEXT
) RETURNS BOOLEAN AS $$
 BEGIN
	INSERT INTO donators(username, password, name, cnpj, address, email, site, description)
	VALUES (un, pw, pname, pcnpj, paddress, pemail, psite, pdescription);

	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION remove_receptor_request (un VARCHAR(20)) RETURNS BOOLEAN AS $$
BEGIN
	DELETE FROM receptor_requests_flags WHERE username = un;
	DELETE FROM receptor_requests WHERE username = un;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION accept_receptor_request (un VARCHAR(20)) RETURNS BOOLEAN AS $$
BEGIN
	INSERT INTO receptors
	SELECT * FROM receptor_requests WHERE username = un;

	INSERT INTO receptor_flags
	SELECT * FROM receptor_requests_flags WHERE username = un;

	PERFORM remove_receptor_request(un);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION remove_donation_request (un VARCHAR(20), tt VARCHAR(50)) RETURNS BOOLEAN AS $$
BEGIN
	DELETE FROM donation_requests_flags WHERE username = un AND title = tt;
	DELETE FROM donation_requests WHERE username = un AND title = tt;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION accept_donation_request (un VARCHAR(20), tt VARCHAR(50)) RETURNS BOOLEAN AS $$
BEGIN
	INSERT INTO donations
	SELECT * FROM donation_requests WHERE username = un AND title = tt;

	INSERT INTO donation_flags
	SELECT * FROM donation_requests_flags WHERE username = un AND title == tt;

	PERFORM remove_donation_request(un, tt);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION remove_event_request (un VARCHAR(20), tt VARCHAR(50)) RETURNS BOOLEAN AS $$
BEGIN
	DELETE FROM event_requests_flags WHERE username = un AND title = tt;
	DELETE FROM event_requests WHERE username = un AND title = tt;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION accept_event_request (un VARCHAR(20), TT VARCHAR(50)) RETURNS BOOLEAN AS $$
BEGIN
	INSERT INTO events
	SELECT * FROM event_requests WHERE username = un AND title = tt;

	INSERT INTO event_flags
	SELECT * FROM event_requests_flags WHERE username = un AND title = tt;

	PERFORM remove_event_request(un, tt);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



-- PARAMS:
-- donator : USERNAME DO USUÁRIO DOADOR
-- receptor : USERNAME DO USUÁRIO RECEPTOR
CREATE OR REPLACE FUNCTION insert_favorite (donator VARCHAR(20), receptor VARCHAR(20))
RETURNS BOOLEAN AS $$
DECLARE
	amount INTEGER;
BEGIN
	SELECT donators.favorites INTO amount FROM donators WHERE donators.username = donator;

	IF amount < 10 THEN
		amount = amount + 1;
		INSERT INTO favorites VALUES (username, receptor);
		UPDATE donators SET donators.favorites = amount WHERE donators.username = donator;
		RETURN TRUE;
	END IF;

	RETURN FALSE;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION delete_favorite() RETURNS TRIGGER AS $$
DECLARE
	amount INTEGER;
BEGIN
	SELECT donators.favorites INTO amount FROM donators WHERE donators.username = OLD.donator;
	amount = amount - 1;
	UPDATE donators SET donators.favorites = amount WHERE donators.username = OLD.donator;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_favorite BEFORE INSERT ON favorites
FOR EACH ROW EXECUTE PROCEDURE delete_favorite();
