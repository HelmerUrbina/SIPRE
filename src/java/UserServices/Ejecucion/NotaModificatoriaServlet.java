/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanNotaModificatoria;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.NotaModificatoriaDAO;
import DataService.Despachadores.Impl.NotaModificatoriaDAOImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;
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
@WebServlet(name = "NotaModificatoriaServlet", urlPatterns = {"/NotaModificatoria"})
public class NotaModificatoriaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objNotaModificatoria;
    private List objNotaModificatoriaDetalle;
    private BeanNotaModificatoria objBnNotaModificatoria;
    private Connection objConnection;
    private NotaModificatoriaDAO objDsNotaModificatoria;

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
        String result = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnNotaModificatoria = new BeanNotaModificatoria();
        objBnNotaModificatoria.setMode(request.getParameter("mode"));
        objBnNotaModificatoria.setPeriodo(request.getParameter("periodo"));
        objBnNotaModificatoria.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnNotaModificatoria.setMes(request.getParameter("mes"));
        objBnNotaModificatoria.setCodigo(request.getParameter("codigo"));
        objDsNotaModificatoria = new NotaModificatoriaDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnNotaModificatoria.getMode().equals("G")) {
            objNotaModificatoria = objDsNotaModificatoria.getListaNotasModificatorias(objBnNotaModificatoria, objUsuario.getUsuario());
            objNotaModificatoriaDetalle = objDsNotaModificatoria.getListaNotasModificatoriasDetalle(objBnNotaModificatoria, objUsuario.getUsuario());
        }
        if (objBnNotaModificatoria.getMode().equals("U")) {
            objBnNotaModificatoria = objDsNotaModificatoria.getNotaModificatoria(objBnNotaModificatoria, objUsuario.getUsuario());
            result = objBnNotaModificatoria.getTipo() + "+++"
                    + objBnNotaModificatoria.getJustificacion() + "+++"
                    + objBnNotaModificatoria.getFecha() + "+++"
                    + objBnNotaModificatoria.getEstado();
        }
        if (objBnNotaModificatoria.getMode().equals("B")) {
            result = "" + objDsNotaModificatoria.getListaNotaModificatoriaDetalle(objBnNotaModificatoria, objUsuario.getUsuario());
        }
        if (objBnNotaModificatoria.getMode().equals("M")) {
            result = "" + objDsNotaModificatoria.getListaNotaModificatoriaMetaFisica(objBnNotaModificatoria, objUsuario.getUsuario());
        }
        if (objBnNotaModificatoria.getMode().equals("A")) {
            objBnNotaModificatoria = objDsNotaModificatoria.getNotaModificatoriaInforme(objBnNotaModificatoria, objUsuario.getUsuario());
            result = objBnNotaModificatoria.getImportancia() + "+++"
                    + objBnNotaModificatoria.getFinanciamiento() + "+++"
                    + objBnNotaModificatoria.getConsecuencia() + "+++"
                    + objBnNotaModificatoria.getVariacion();
        }
        if (request.getAttribute("objNotaModificatoria") != null) {
            request.removeAttribute("objNotaModificatoria");
        }
        if (request.getAttribute("objNotaModificatoriaDetalle") != null) {
            request.removeAttribute("objNotaModificatoriaDetalle");
        }
        request.setAttribute("objNotaModificatoria", objNotaModificatoria);
        request.setAttribute("objNotaModificatoriaDetalle", objNotaModificatoriaDetalle);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnNotaModificatoria.getMode()) {
            case "notaModificatoria":
                dispatcher = request.getRequestDispatcher("Ejecucion/NotaModificatoria.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaNotaModificatoria.jsp");
                break;
            default:
                dispatcher = request.getRequestDispatcher("error.jsp");
                break;
        }
        if (result != null) {
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(result);
            }
        } else {
            dispatcher.forward(request, response);
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
