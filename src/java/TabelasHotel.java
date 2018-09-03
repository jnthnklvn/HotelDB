import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 *
 * @author j_kel
 */
@WebServlet(name = "Ingressos", urlPatterns = {"/Ingressos"})
public class TabelasHotel extends HttpServlet {

    static final String JDBC_DRIVER = "org.postgresql.Driver";
    static final String DATABASE_URL = "jdbc:postgresql://localhost:5432/hotel_db";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Connection conn;
        Statement st;
        ResultSet rec;
        try {
            out = response.getWriter();
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Igressos</title>");
            out.println("<link rel='stylesheet' href='ServletStyle.css'"
                    + " type='text/css'/>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Tabelas do Hotel</h1>");
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DATABASE_URL,
                    "postgres", "2421");
            st = conn.createStatement();
            rec = st.executeQuery("SELECT * FROM hotel.pessoa");
            out.println("<table border=1>");
            out.println("<tr><th colspan='7'><b>Pessoa</th></tr><tr>");
            out.println("<td><b>CPF</b></td><td><b>RG</b></td>"
                    + "<td align='center'><b>Primeiro</br>Nome</b></td>"
                    + "<td align='center'><b>Sobrenome</b></td>"
                    + "<td align='center'><b>Data</br>Nascimento</b></td>"
                    + "<td align='center'><b>Rua</b></td>"
                    + "<td align='right'><b>CEP</b></td></tr>");
            while (rec.next()) {
                out.println("<tr><td>" + rec.getString(1) + "</td><td>"
                        + rec.getString(2) + "</td><td align='center'> "
                        + rec.getString(3) + "</td><td align='center'> "
                        + rec.getString(4) + "</td><td align='center'> " 
                        + rec.getString(5) + "</td><td align='center'> "
                        + rec.getString(6) + "</td><td align='right'> " 
                        + rec.getString(7) + "</td></tr>");
            }
            rec.close();
            out.println("</table><br/><br/>");
            rec = st.executeQuery("SELECT * FROM hotel.usuario");
            out.println("<table border=1>");
            out.println("<tr><th colspan='7'><b>Usuario</th></tr><tr>");
            out.println("<td><b>ID</b></td><td><b>Usuario</b></td>"
                    + "<td align='center'><b>Senha</br></b></td></tr>");
            while (rec.next()) {
                out.println("<tr><td>" + rec.getString(1) + "</td><td>"
                        + rec.getString(2) + "</td><td align='center'> "
                        + rec.getString(3) + "</td></tr></table><br/><br/>");
            }
            rec.close();
            rec = st.executeQuery("SELECT * FROM hotel.cliente");
            out.println("<table border=1>");
            out.println("<tr><th colspan='7'><b>Cliente</th></tr><tr><td><b>"
                    + "Cod_Cliente</b></td><td><b>CPF</b></td><td><b>Idade</br>"
                    + "</b></td><td><b>Data</br><b>Cadastro</b></br></td></tr>");
            while (rec.next()) {
                out.println("<tr><td>"+rec.getString(1)+"</td><td>"
                        +rec.getString(2)+"</td><td>" + rec.getString(3)
                        +"</td><td> " + rec.getString(4) 
                        +"</td></tr></table><br/><br/>");
            }
            //rec.close();
            st.close();
            conn.close();
        } catch (SQLException s) {
            out.println("SQL Error: (3) " + s.toString() + "  "
                    + s.getErrorCode() + " " + s.getSQLState());
        } catch (ClassNotFoundException e) {
            out.println("Error: " + e.toString()
                    + e.getMessage());
        }
        out.println("</br><form name='form1' action='Consultas' method='post'>");
        out.println("<input class='botao' type='submit' value='Consultas'>");
        out.println("</form></body>");
        out.println("</html>");
        out.close();
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
