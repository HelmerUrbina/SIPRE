/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionEstado;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.EjecucionEstadoDAO;
import DataService.Despachadores.Impl.EjecucionEstadoDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import Utiles.Utiles;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
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
@WebServlet(name = "IduEjecucionEstadoServlet", urlPatterns = {"/IduEjecucionEstado"})
public class IduEjecucionEstadoServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanEjecucionEstado objBnEjecucionEstado;
    private Connection objConnection;
    private EjecucionEstadoDAO objDsEjecucionEstado;
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
            throws ServletException, IOException, ParseException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(true);
        String result = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha
        java.util.Date desde = sdf.parse(Utiles.checkFecha(request.getParameter("desde")));
        java.util.Date hasta = sdf.parse(Utiles.checkFecha(request.getParameter("hasta")));
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnEjecucionEstado = new BeanEjecucionEstado();
        objBnEjecucionEstado.setMode(request.getParameter("mode"));
        objBnEjecucionEstado.setPeriodo(request.getParameter("periodo"));
        objBnEjecucionEstado.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnEjecucionEstado.setOpcion(request.getParameter("opcion"));
        objBnEjecucionEstado.setDesde(new java.sql.Date(desde.getTime()));
        objBnEjecucionEstado.setHasta(new java.sql.Date(hasta.getTime()));
        objDsEjecucionEstado = new EjecucionEstadoDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO        
        String arreglo[][] = Utiles.generaLista(request.getParameter("lista"), 2);
        objBnEjecucionEstado.setCodigo(objDsEjecucionEstado.getCodigoEjecucionEstado(objBnEjecucionEstado, objUsuario.getUsuario()));
        objBnEjecucionEstado.setMode("D");
        k = objDsEjecucionEstado.iduEjecucionEstado(objBnEjecucionEstado, objUsuario.getUsuario());
        for (String[] item : arreglo) {
            objBnEjecucionEstado.setMode("I");
            objBnEjecucionEstado.setUnidadOperativa(item[0].trim());
            objBnEjecucionEstado.setTipo("N");
            if (item[1].trim().equals("true")) {
                objBnEjecucionEstado.setTipo("Y");
            }
            k = objDsEjecucionEstado.iduEjecucionEstado(objBnEjecucionEstado, objUsuario.getUsuario());
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0) {
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_EJECUCION_ESTADO");
            objBnMsgerr.setTipo(objBnEjecucionEstado.getMode());
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(IduEjecucionEstadoServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(IduEjecucionEstadoServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
