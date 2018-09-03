import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConexaoDB {
    private final String URL="jdbc:postgresql://localhost:5432/hotel_db";
    public ConexaoDB() {
    }
    
    private Connection getConnection(){
        try {
            Class.forName("org.postgresql.Driver");
            Connection con = DriverManager.getConnection(URL, "postgres", "2421");
            return con;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(ConexaoDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public int executeUpdate(String query){
        Connection con;
        try{
            con = getConnection();
            Statement stm = con.createStatement();
            System.out.println(query);
            int res=stm.executeUpdate(query);
            con.close();
            return res;
        } catch (SQLException ex) {
            Logger.getLogger(ConexaoDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
    public ResultSet executeQuery(String query){
        try{
            Connection con = getConnection();
            Statement stm = con.createStatement();
            ResultSet rs = stm.executeQuery(query);
            return rs;
        } catch (SQLException ex) {
            Logger.getLogger(ConexaoDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
