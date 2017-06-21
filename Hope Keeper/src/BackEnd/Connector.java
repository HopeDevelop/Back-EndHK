package BackEnd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class Connector {
	private Connection connection;
	private Statement stmt;
	
	protected Connector() {
		connection = null;
		stmt = null;
	}

	protected boolean connect() {
		if (connection == null) {
			try {
				connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/teste", "teste", "");
				stmt = connection.createStatement();
			} catch (SQLException ex) {
				connection = null;
				stmt = null;
				System.out.println("Connector.connect() error: " + ex.getMessage());

				return false;
			}
		}

		return true;
	}
	
	protected ResultSet query(String sql) {
		ResultSet rs = null;
		
		try {
			if (!this.connect()) {
				return null;
			}
			
			if (stmt.execute(sql)) {
				rs = stmt.getResultSet();
			}
		} catch (SQLException ex) {
			System.out.println("Connector.query() error: " + ex.getMessage());
		}
		
		return rs;
	}
	
	protected void close() {
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException ex) {
				System.out.println("Connector.close() error: " + ex.getMessage());
			}
			
			connection = null;
		}
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException ex) {
				System.out.println("Connector.close() error: " + ex.getMessage());
			}
			
			connection = null;
		}
	}
}
