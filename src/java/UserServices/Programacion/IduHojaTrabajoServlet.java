/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanHojaTrabajo;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.HojaTrabajoDAO;
import DataService.Despachadores.Impl.HojaTrabajoDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
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
@WebServlet(name = "IduHojaTrabajoServlet", urlPatterns = {"/IduHojaTrabajo"})
public class IduHojaTrabajoServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanHojaTrabajo objBnHojaTrabajo;
    private Connection objConnection;
    private HojaTrabajoDAO objDsHojaTrabajo;
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
        //VERIFICAMOS QUE LA SESSION SEA VALIDA
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnHojaTrabajo = new BeanHojaTrabajo();
        objBnHojaTrabajo.setMode(request.getParameter("mode"));
        objBnHojaTrabajo.setPeriodo(request.getParameter("periodo"));
        objBnHojaTrabajo.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnHojaTrabajo.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnHojaTrabajo.setTarea(request.getParameter("tarea"));
        objBnHojaTrabajo.setEventoPrincipal(request.getParameter("eventoPrincipal"));
        objBnHojaTrabajo.setEventoFinal(request.getParameter("eventoFinal"));
        objBnHojaTrabajo.setCorrelativo(Utiles.checkNum(request.getParameter("correlativo")));
        objBnHojaTrabajo.setCadenaGasto(request.getParameter("cadenaGasto"));
        objBnHojaTrabajo.setCodigo(request.getParameter("codigoItem"));
        objBnHojaTrabajo.setItem(request.getParameter("item"));
        objBnHojaTrabajo.setUnidadMedida(request.getParameter("unidadMedida"));
        objBnHojaTrabajo.setCantidad(Utiles.checkDouble(request.getParameter("cantidad")));
        objBnHojaTrabajo.setPrecio(Utiles.checkDouble(request.getParameter("precio")));
        objDsHojaTrabajo = new HojaTrabajoDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = objDsHojaTrabajo.iduHojaTrabajo(objBnHojaTrabajo, objUsuario.getUsuario());
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("TAHOTR");
            objBnMsgerr.setTipo(objBnHojaTrabajo.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            result = objBnMsgerr.getDescripcion();
        }
        // EN CASO DE NO HABER PROBLEMAS RETORNAMOS UNA NUEVA CONSULTA CON TODOS LOS DATOS.
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            if (result == null) {
                out.print("GUARDO");
            } else {
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
