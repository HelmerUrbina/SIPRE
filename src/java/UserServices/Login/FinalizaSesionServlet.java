package UserServices.Login;

import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import java.io.IOException;
import java.sql.Connection;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author H-URBINA-M
 */
@WebServlet(name = "FinalizaSesionServlet", urlPatterns = {"/FinalizaSesion"})
public class FinalizaSesionServlet extends HttpServlet {

    private ServletConfig config;
    private ServletContext context;
    private HttpSession session;
    private Connection objConnection;
    private RequestDispatcher dispatcher;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        objConnection = (Connection) context.getAttribute("objConnection");
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario != null) {
            session.removeAttribute("ID");
            session.removeAttribute("objUsuario" + session.getId());
            session.removeAttribute("autorizacion");
            session.removeAttribute("modulo");
            session.removeAttribute("menu");
            session.invalidate();
            MsgerrDAO daoMsgErr = new MsgerrDAOImpl(objConnection);
            daoMsgErr.iduLog(objUsuario.getUsuario(), "INFO", "Salio del Sistema", request);
        }
        dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
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