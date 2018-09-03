

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
 * Create on 09/2017
 *
 * @author j_kel
 */
@WebServlet(name = "Loja", urlPatterns = {"/Loja"})
public class Consultas extends HttpServlet {

    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DATABASE_URL = "jdbc:mysql://localhost/cinema";
    int identUser;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Connection conn;
        String usuario = request.getParameter("usuario");
        String codigo;

        if (usuario != null) {
            identUser = Integer.parseInt(usuario);
        } else {
            double x = Math.random() * 1000 + 1; // gera números de 1 a 1000
            identUser = (int) x;
        }
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DATABASE_URL,
                    "root", "2421");
            Statement st = conn.createStatement();
            Statement st1 = conn.createStatement();
            
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Loja de Ingressos</title>");
            out.println("<link rel='stylesheet' href='ServletStyle.css'"
                    + " type='text/css'/>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Cinema Aracaju</h1>");
            out.println("<h2>Filmes em cartaz</h2>");
            
            ResultSet rec = st.executeQuery(
                    "SELECT * FROM filmes ORDER by nome_filme");
            String valor1, valor2, valor3, valor4, valor5, valor6;
            while (rec.next()) {
                codigo = rec.getString("cod_filme");
                int preçoM = 15, preçoI = 30;
                ResultSet rec2 = st1.executeQuery("SELECT * FROM sessoes WHERE "
                    + "cod_filme='"+codigo+"' ORDER BY data_sessao, horario");
                rec2.next();
                valor1="Dia: "+rec2.getString(3)+", "+rec2.getString(5)+"hrs";
                valor4 = rec2.getString(1);
                if (!rec2.next()){
                    valor2="";
                    valor3="";
                    valor5="";
                    valor6="";
                }else{
                    valor2="Dia: "+rec2.getString(3)+", "+rec2.getString(5)+"hrs";
                    valor5 = rec2.getString(1);
                }
                if (!rec2.next()){
                    valor3="";
                    valor6="";
                }else{
                    valor3="Dia: "+rec2.getString(3)+", "+rec2.getString(5)+"hrs";
                    valor6 = rec2.getString(1);
                }
                out.println("<form action='Carrinho' method='post'>");
                out.println("<input type='hidden' name='usuario' value='" + identUser
                        + "'/>");
                out.println("<input type='hidden' name='cod_filme' value='"
                        + codigo + "'/>");
                out.println("<table><td align='center'>");
                out.println("<img height='70' width='56' src='filmes//" + codigo + ".jpg'"
                        + " width='50' align='absMidle' border='1'></td>");
                out.println("<td width='300' id='td'><b>Código:</b> " + codigo
                        + "<br /><b>Nome:</b> " + rec.getString(2)
                        + "<br /><b>Estreia:</b> " + rec.getString(3)
                        + ", <b>fim:</b> " + rec.getString(4)
                        + "<br /><b>Preço meia:</b> R$ " + preçoM + "<b>, inteira:</b> R$ " + preçoI
                        + "<br /><b>Ingressos meia:</b> " + rec.getString(5) 
                        + "<b>, inteira:</b> " + rec.getString(6)
                        + "</td><td id='td' width=''><select id='state'"
                                + " name='state' required='required'></br>"
                +"<option disabled selected value>-- Select a session --</option>"
                        + "<option value='"+valor4+"'>"+valor1+"</option>"
                        + "<option value='"+valor5+"'>"+valor2+"</option>"
                +"<option value='"+valor6+"'>"+valor3+"</option></br></select></td>"
                        + "<td id='td'><table><tr><td>Quantidade Meia</td> "
                        + "<td><input class='entrada' type='text' name='quantM'"
                                + " size='3'></td></tr>"
                        + "<tr><td>Quantidade Inteira</td> "
                        + "<td><input class='entrada' type='text' name='quantI'"
                                + " size='3'></td></tr></table>");
                out.println("</td><td><input id='botao' type='submit'"
                        + " value='Adicionar ao carrinho'>");
                out.println("</td></table>");
                out.println("</form>");
                rec2.close();
            }
            out.println("</br><form action='Listar' method='post'>"
                    + "<input id='botao' type='submit' value='Listar Filmes'>"
                    + "</form>");
            rec.close();
            st.close();
        } catch (SQLException s) {
            out.println("SQL Error: " + s.toString() + " "
                    + s.getErrorCode() + " " + s.getSQLState());
        } catch (ClassNotFoundException e) {
            out.println("Error class not found: " + e.toString()
                    + e.getMessage());
        }
        out.println("</body>");
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
