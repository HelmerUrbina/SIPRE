/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Evaluacion;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanResolucionesAdministrativas;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.ResolucionesAdministrativasDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.ResolucionesAdministrativasDAO;
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
@WebServlet(name = "IduResolucionesAdministrativasServlet", urlPatterns = {"/IduResolucionesAdministrativas"})
public class IduResolucionesAdministrativasServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanResolucionesAdministrativas objBnResoluciones;
    private Connection objConnection;
    private ResolucionesAdministrativasDAO objDsResoluciones;
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
        session = request.getSession(true);
        String result = null;
        String resulDetalle = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnResoluciones = new BeanResolucionesAdministrativas();
        objBnResoluciones.setMode(request.getParameter("mode"));
        objBnResoluciones.setPeriodo(request.getParameter("periodo"));
        objBnResoluciones.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnResoluciones.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnResoluciones.setCodigo(request.getParameter("codigo"));
        objDsResoluciones = new ResolucionesAdministrativasDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO        
        String lista[][] = Utiles.generaLista(request.getParameter("lista"), 8);
        for (String[] item : lista) {
            objBnResoluciones.setMode("U");
            objBnResoluciones.setSecuenciaFuncional(item[1]);
            objBnResoluciones.setTareaPresupuestal(item[2]);
            objBnResoluciones.setCadenaGasto(item[3]);
            objBnResoluciones.setCompromiso(Utiles.checkDouble(item[4]));
            objBnResoluciones.setDevengado(Utiles.checkDouble(item[5]));
            objBnResoluciones.setGirado(Utiles.checkDouble(item[6]));
            objBnResoluciones.setRevertido(Utiles.checkDouble(item[7]));
            k = objDsResoluciones.iduResolucionesAdministrativas(objBnResoluciones, objUsuario.getUsuario());
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0 || result != null) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("TABRAD");
            objBnMsgerr.setTipo(objBnResoluciones.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            resulDetalle = objBnMsgerr.getDescripcion();
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
                out.print(resulDetalle);
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
