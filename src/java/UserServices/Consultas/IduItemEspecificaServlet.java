/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Consultas;

import BusinessServices.Beans.BeanItemEspecifica;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.ItemEspecificaDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.ItemEspecificaDAO;
import DataService.Despachadores.MsgerrDAO;
import Utiles.Utiles;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "IduItemEspecificaServlet", urlPatterns = {"/IduItemEspecifica"})
public class IduItemEspecificaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanItemEspecifica objBnItemEspecifica;
    private Connection objConnection;
    private ItemEspecificaDAO objDsItemEspecifica;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;

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
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null && !request.getParameter("mode").equals("I")) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnItemEspecifica = new BeanItemEspecifica();
        objBnItemEspecifica.setMode(request.getParameter("mode"));
        objBnItemEspecifica.setCadenaGasto(request.getParameter("cadenaGasto"));
        objBnItemEspecifica.setItem(request.getParameter("item"));
        objBnItemEspecifica.setCodigo(request.getParameter("codigo"));
        objBnItemEspecifica.setCadenaGasto(request.getParameter("cadenaGasto"));
        objDsItemEspecifica = new ItemEspecificaDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO   
        if (objBnItemEspecifica.getMode().equals("D")) {
            k = objDsItemEspecifica.eliminarItemEspecifica(objBnItemEspecifica, objUsuario.getUsuario());
        } else {
            objBnItemEspecifica.setMode("D");
            objBnItemEspecifica.setCodigo(request.getParameter("item"));
            k = objDsItemEspecifica.iduItemEspecifica(objBnItemEspecifica, objUsuario.getUsuario());
            String lista[][] = Utiles.generaLista(request.getParameter("lista"), 2);
            for (String[] item : lista) {
                objBnItemEspecifica.setMode("I");
                objBnItemEspecifica.setCodigo(item[0].trim());
                objBnItemEspecifica.setUnidadMedida(item[1].trim());
                k = objDsItemEspecifica.iduItemEspecifica(objBnItemEspecifica, objUsuario.getUsuario());
            }
        }
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_ITEM_ESPECIFICA_GASTO");
            objBnMsgerr.setTipo(objBnItemEspecifica.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            result = objBnMsgerr.getDescripcion();
        }
        // EN CASO DE NO HABER PROBLEMAS RETORNAMOS UNA NUEVA CONSULTA CON TODOS LOS DATOS.
        response.setContentType("text/html;charset=UTF-8");
        if (result == null) {
            try (PrintWriter out = response.getWriter()) {
                out.print("GUARDO");
            }
        } else {
            //PROCEDEMOS A ELIMINAR TODO;
            try (PrintWriter out = response.getWriter()) {
                out.print(result);
            }
        }
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
