package application.persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GenericDao {
	private Connection c;
	
	public Connection getConnection() throws SQLException, ClassNotFoundException {
		
		String hostname = "localhost";
		String dbName = "test";
		String user = "sa";
		String senha = "123456";
		
		
		Class.forName("net.sourceforge.jtds.jdbc.Driver");
		
		c = DriverManager.getConnection(
				String.format("jdbc:jtds:sqlserver://%s:1433;databaseNmae=%s;password=%s;", hostname, dbName, user, senha));
		return c;
	}
	
	
}
