/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanDisponibilidadPresupuestal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.DisponibilidadPresupuestalDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.DisponibilidadPresupuestalDAO;
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
@WebServlet(name = "IduDisponibilidadPresupuestalServlet", urlPatterns = {"/IduDisponibilidadPresupuestal"})
public class IduDisponibilidadPresupuestalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanDisponibilidadPresupuestal objBnDisponibilidadPresupuestal;
    private Connection objConnection;
    private DisponibilidadPresupuestalDAO objDsDisponibilidadPresupuestal;
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
     * @throws java.text.ParseException
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
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
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha
        java.util.Date fecha_util = sdf.parse(Utiles.checkFecha(request.getParameter("fecha")));
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnDisponibilidadPresupuestal = new BeanDisponibilidadPresupuestal();
        objBnDisponibilidadPresupuestal.setMode(request.getParameter("mode"));
        objBnDisponibilidadPresupuestal.setPeriodo(request.getParameter("periodo"));
        objBnDisponibilidadPresupuestal.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnDisponibilidadPresupuestal.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnDisponibilidadPresupuestal.setMes(request.getParameter("mes"));
        objBnDisponibilidadPresupuestal.setCodigo(request.getParameter("codigo"));
        objBnDisponibilidadPresupuestal.setFecha(new java.sql.Date(fecha_util.getTime()));
        objBnDisponibilidadPresupuestal.setTipo(request.getParameter("tipo"));
        objBnDisponibilidadPresupuestal.setOficio(request.getParameter("oficio"));
        objBnDisponibilidadPresupuestal.setConcepto(request.getParameter("concepto"));
        objBnDisponibilidadPresupuestal.setImporte(Utiles.checkDouble(request.getParameter("importe")));
        objDsDisponibilidadPresupuestal = new DisponibilidadPresupuestalDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        switch (objBnDisponibilidadPresupuestal.getMode()) {
            case "D":
                k = objDsDisponibilidadPresupuestal.iduDisponibilidadPresupuestal(objBnDisponibilidadPresupuestal, objUsuario.getUsuario());
                break;
            case "C":
                k = objDsDisponibilidadPresupuestal.iduDisponibilidadPresupuestal(objBnDisponibilidadPresupuestal, objUsuario.getUsuario());
                break;
            case "V":
                k = objDsDisponibilidadPresupuestal.iduEnvioDisponibilidadPresupuestal(objBnDisponibilidadPresupuestal, objUsuario.getUsuario());
                break;
            default:
                if (objBnDisponibilidadPresupuestal.getMode().equals("I")) {
                    objBnDisponibilidadPresupuestal.setCodigo(objDsDisponibilidadPresupuestal.getCodigoDisponibilidadPresupuestal(objBnDisponibilidadPresupuestal, objUsuario.getUsuario()));
                }
                k = objDsDisponibilidadPresupuestal.iduDisponibilidadPresupuestal(objBnDisponibilidadPresupuestal, objUsuario.getUsuario());
                if (k != 0) {
                    String lista[][] = Utiles.generaLista(request.getParameter("lista"), 12);
                    objBnDisponibilidadPresupuestal.setMode("D");
                    objBnDisponibilidadPresupuestal.setDetalle(0);
                    objBnDisponibilidadPresupuestal.setResolucion(0);
                    k = objDsDisponibilidadPresupuestal.iduDisponibilidadPresupuestalDetalle(objBnDisponibilidadPresupuestal, objUsuario.getUsuario());
                    for (String[] item : lista) {
                        objBnDisponibilidadPresupuestal.setMode("I");
                        objBnDisponibilidadPresupuestal.setDetalle(Utiles.checkNum(item[0] + 1));
                        objBnDisponibilidadPresupuestal.setResolucion(Utiles.checkNum(item[1]));
                        objBnDisponibilidadPresupuestal.setDependenciaCargo(item[2]);
                        objBnDisponibilidadPresupuestal.setSecuenciaFuncionalCargo(item[3]);
                        objBnDisponibilidadPresupuestal.setTareaCargo(item[4]);
                        objBnDisponibilidadPresupuestal.setCadenaGastoCargo(item[5]);
                        objBnDisponibilidadPresupuestal.setUnidad(item[6]);
                        objBnDisponibilidadPresupuestal.setDependencia(item[7]);
                        objBnDisponibilidadPresupuestal.setSecuencia(item[8]);
                        objBnDisponibilidadPresupuestal.setTarea(item[9]);
                        objBnDisponibilidadPresupuestal.setCadenaGasto(item[10]);
                        objBnDisponibilidadPresupuestal.setImporte(Utiles.checkDouble(item[11]));
                        k = objDsDisponibilidadPresupuestal.iduDisponibilidadPresupuestalDetalle(objBnDisponibilidadPresupuestal, objUsuario.getUsuario());
                    }
                    if (k == 0) {
                        result = "ERROR";
                        objBnMsgerr = new BeanMsgerr();
                        objBnMsgerr.setUsuario(objUsuario.getUsuario());
                        objBnMsgerr.setTabla("SIPE_INFORME_DISPONIBILIDAD");
                        objBnMsgerr.setTipo("I");
                        objDsMsgerr = new MsgerrDAOImpl(objConnection);
                        objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
                        resulDetalle = objBnMsgerr.getDescripcion();
                    }
                }
                break;
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0 || result != null) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_INFORME_DISPONIBILIDAD");
            objBnMsgerr.setTipo(objBnDisponibilidadPresupuestal.getMode());
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(IduDisponibilidadPresupuestalServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduDisponibilidadPresupuestalServlet.class.getName()).log(Level.SEVERE, null, ex);
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
