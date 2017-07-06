var pg = require('pg');

var options = {
	user: "hkadmin",
	database: 'mybd',
	password: 'hopekeeper',
	host: 'hkdev.cfs9rsmxpyjg.us-east-1.rds.amazonaws.com',
	port: 5432
};

module.exports = new pg.Pool(options);


