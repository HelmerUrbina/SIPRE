/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Configuracion;

import DataService.Despachadores.Impl.TextoDAOImpl;
import DataService.Despachadores.TextoDAO;
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

/**
 *
 * @author H-URBINA-M
 */
@WebServlet(name = "TextoAjaxServlet", urlPatterns = {"/TextoAjax"})
public class TextoAjaxServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private RequestDispatcher dispatcher = null;
    private Connection objConnection;
    private TextoDAO objDsTexto;
    private String result;

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
        objConnection = (Connection) context.getAttribute("objConnection");
        objDsTexto = new TextoDAOImpl(objConnection);
        String mode = request.getParameter("mode");
        String codigo = request.getParameter("codigo");
        if (request.getAttribute("objTextoAjax") != null) {
            request.removeAttribute("objTextoAjax");
        }
        switch (mode) {
            case "item":
                request.setAttribute("objTextoAjax", objDsTexto.getItem(codigo.replaceAll(" ", "%")));
                dispatcher = request.getRequestDispatcher("Comun/TextoItemAjax.jsp");
                break;
            case "institucion":
                request.setAttribute("objTextoAjax", objDsTexto.getInstitucion(codigo.replaceAll(" ", "%")));
                dispatcher = request.getRequestDispatcher("Comun/TextoInstitucionAjax.jsp");
                break;
            case "categoriaPresupuestal":
                result = objDsTexto.getCategoriaPresupuesta(codigo);
                break;
            case "producto":
                result = objDsTexto.getProducto(codigo);
                break;
            case "actividad":
                result = objDsTexto.getActividad(codigo);
                break;
            case "funcion":
                result = objDsTexto.getFuncion(codigo);
                break;
            case "divisionFuncional":
                result = objDsTexto.getDivisionFuncional(codigo);
                break;
            case "grupoFuncional":
                result = objDsTexto.getGrupoFuncional(codigo);
                break;
            case "mensualizarNotaModificatoria":
                result = objDsTexto.getMensualizarNotaModificatoria(request.getParameter("periodo"), request.getParameter("presupuesto"), request.getParameter("unidadOperativa"),
                        request.getParameter("resolucion"), request.getParameter("tipoCalendario"), request.getParameter("dependencia"), request.getParameter("secuenciaFuncional"),
                        request.getParameter("tarea"), request.getParameter("cadenaGasto"));
                break;
            default:
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
