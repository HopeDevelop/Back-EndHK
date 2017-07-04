var pg = require('pg');
var options = {
	user: "postgres",
	database: 'hk',
	password: 'admin',
	host: 'localhost',
	port: 5432
};

module.exports = new pg.Pool(options);
