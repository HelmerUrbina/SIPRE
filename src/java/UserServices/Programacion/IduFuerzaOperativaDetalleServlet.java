/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanFuerzaOperativa;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.FuerzaOperativaDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.FuerzaOperativaDAO;
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
 * @author H-TECCSI-V
 */
@WebServlet(name = "IduFuerzaOperativaDetalleServlet", urlPatterns = {"/IduFuerzaOperativaDetalle"})
public class IduFuerzaOperativaDetalleServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanFuerzaOperativa objBnFuerzaOperativa;
    private Connection objConnection;
    private FuerzaOperativaDAO objDsFuerzaOperativa;
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
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnFuerzaOperativa = new BeanFuerzaOperativa();
        objBnFuerzaOperativa.setMode(request.getParameter("mode"));
        objBnFuerzaOperativa.setPeriodo(request.getParameter("periodo"));
        objBnFuerzaOperativa.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnFuerzaOperativa.setDependencia(request.getParameter("dependencia"));
        objBnFuerzaOperativa.setCodigo(request.getParameter("codigo"));
        objBnFuerzaOperativa.setDependenciaDetalle(request.getParameter("codigoDetalle"));
        objBnFuerzaOperativa.setComentario(request.getParameter("comentario"));
        objBnFuerzaOperativa.setCodigoDepartamento(request.getParameter("departamento"));
        objBnFuerzaOperativa.setTipoFuerzaOperativa(Utiles.checkNum(request.getParameter("tipoFuerza")));
        objBnFuerzaOperativa.setDesactivacion(request.getParameter("desactivacion"));
        objBnFuerzaOperativa.setCantidadOficina(Utiles.checkNum(request.getParameter("cantidad")));

        objDsFuerzaOperativa = new FuerzaOperativaDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = objDsFuerzaOperativa.iduFuerzaOperativaDetalle(objBnFuerzaOperativa, objUsuario.getUsuario());
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_FUERZA_OPE");
            objBnMsgerr.setTipo(objBnFuerzaOperativa.getMode());
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
