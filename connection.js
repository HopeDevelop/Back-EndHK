var pg = require('pg');

var options = {
	user: "hkadmin",
	database: 'hk',
	password: 'hopekeeper',
	host: 'hk.cfs9rsmxpyjg.us-east-1.rds.amazonaws.com',
	port: 5432
};

module.exports = new pg.Pool(options);


