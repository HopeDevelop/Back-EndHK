package BackEnd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class Connector {
	private Connection connection;
	
	protected Connector() {
		connection = null;
	}

	private boolean connect() {
		try {
			connection = DriverManager.getConnection("jdbc:mysql://ip:port/db", "username", "password");
		} catch (SQLException ex) {
			connection = null;
			return false;
		}
		return true;
	}
	
	protected ResultSet query(String query) {
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			this.connect();
			stmt = connection.createStatement();
			
			if (stmt.execute(query)) {
				rs = stmt.getResultSet();
			}
		} catch (SQLException ex) {
			System.out.println("Erro: " + ex.getMessage());
		} finally {
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException ex) {
					// IGNORE
				}
				stmt = null;
			}
			
			this.disconnect();
		}
		
		return rs;
	}
	
	private void disconnect() {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException ex) {
				// IGNORE
			}
			
			connection = null;
		}
	}
}
