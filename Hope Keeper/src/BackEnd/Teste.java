package BackEnd;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Teste {

	public static void main(String[] args) {
		ResultSet rs = null;

		try {
			Connector db = new Connector();

			rs = db.query("SELECT * FROM flags");

			if(rs.first()) {
				while ( !rs.isAfterLast() ) {
					System.out.println(rs.getString("name"));
					rs.next();
				}
			} else {
				System.out.println("Empty ResultSet");
			}

			rs.close();
			db.close();
		} catch (Exception ex) {
			System.out.println("Erro 1: " + ex.getMessage());
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException ex) {
					System.out.println("Erro 2: " + ex.getMessage());
				}
				
				rs = null;
			}
		}
	}
}
