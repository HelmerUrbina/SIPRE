/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Logistica;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPAACProcesos;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.PAACProcesosDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PAACProcesosDAO;
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
@WebServlet(name = "IduPAACProcesosDetalleContratoServlet", urlPatterns = {"/IduPAACProcesosDetalleContrato"})
public class IduPAACProcesosDetalleContratoServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPAACProcesos objBnPAACProcesos;
    private Connection objConnection;
    private PAACProcesosDAO objDsPAACProcesos;
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

        objBnPAACProcesos = new BeanPAACProcesos();
        objBnPAACProcesos.setMode(request.getParameter("mode"));
        objBnPAACProcesos.setPeriodo(request.getParameter("periodo"));
        objBnPAACProcesos.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnPAACProcesos.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnPAACProcesos.setCodigo(Utiles.Utiles.checkNum(request.getParameter("codigo")));
        objBnPAACProcesos.setDetalle(Utiles.Utiles.checkNum(request.getParameter("detalle")));
        objBnPAACProcesos.setTipoCalendario(request.getParameter("tipoCalendario"));
        objBnPAACProcesos.setResolucion(request.getParameter("resolucion"));
        objBnPAACProcesos.setDependencia(request.getParameter("dependencia"));
        objBnPAACProcesos.setSecuenciaFuncional(request.getParameter("secuenciaFuncional"));
        objBnPAACProcesos.setTareaPresupuestal(request.getParameter("tareaPresupuestal"));
        objBnPAACProcesos.setCadenaGasto(request.getParameter("cadenaGasto"));
        objDsPAACProcesos = new PAACProcesosDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = objDsPAACProcesos.iduPAACProcesosDetalleContratoAfectacion(objBnPAACProcesos, objUsuario.getUsuario());
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPRE_PAAC_PROCESOS_DETALLE");
            objBnMsgerr.setTipo(objBnPAACProcesos.getMode());
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
