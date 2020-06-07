/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.SIAF;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPriorizacionPCA;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.PriorizacionPCADAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PriorizacionPCADAO;
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
@WebServlet(name = "IduPriorizacionPCAServlet", urlPatterns = {"/IduPriorizacionPCA"})
public class IduPriorizacionPCAServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPriorizacionPCA objBnPriorizacion;
    private Connection objConnection;
    private PriorizacionPCADAO objDsPriorizacion;
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
        objBnPriorizacion = new BeanPriorizacionPCA();
        objBnPriorizacion.setMode(request.getParameter("mode"));
        objBnPriorizacion.setPeriodo(request.getParameter("periodo"));
        objBnPriorizacion.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnPriorizacion.setGenericaGasto(request.getParameter("genericaGasto"));
        objBnPriorizacion.setCodigo(Utiles.checkNum(request.getParameter("codigo")));
        objBnPriorizacion.setSolicitudCredito(request.getParameter("siaf"));
        objDsPriorizacion = new PriorizacionPCADAOImpl(objConnection);
        String lista[][];
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        switch (objBnPriorizacion.getMode()) {
            case "A":
                k = objDsPriorizacion.iduPriorizacionPCA(objBnPriorizacion, objUsuario.getUsuario());
                break;
            case "D":
                k = objDsPriorizacion.iduPriorizacionPCA(objBnPriorizacion, objUsuario.getUsuario());
                break;
            case "I":
                objBnPriorizacion.setCodigo(objDsPriorizacion.iduPriorizacionPCA(objBnPriorizacion, objUsuario.getUsuario()));
                lista = Utiles.generaLista(request.getParameter("lista"), 4);
                for (String[] item : lista) {
                    objBnPriorizacion.setDetalle(Integer.valueOf(item[0].trim() + 1));
                    objBnPriorizacion.setUnidadOperativa(item[1].trim());
                    objBnPriorizacion.setSolicitudCredito(item[2].trim());
                    objBnPriorizacion.setTipo(item[3].trim());
                    k = objDsPriorizacion.iduPriorizacionPCADetalle(objBnPriorizacion, objUsuario.getUsuario());
                }
                if (k == 0) {
                    result = "ERROR";
                    objBnMsgerr = new BeanMsgerr();
                    objBnMsgerr.setUsuario(objUsuario.getUsuario());
                    objBnMsgerr.setTabla("SIPE_PRIORIZACION_DETALLE");
                    objBnMsgerr.setTipo(objBnPriorizacion.getMode());
                    objDsMsgerr = new MsgerrDAOImpl(objConnection);
                    objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
                    resulDetalle = objBnMsgerr.getDescripcion();
                }
                break;
            case "U":
                objBnPriorizacion.setMode("D");
                objBnPriorizacion.setDetalle(0);
                k = objDsPriorizacion.iduPriorizacionPCADetalle(objBnPriorizacion, objUsuario.getUsuario());
                if (k != 0) {
                    lista = Utiles.generaLista(request.getParameter("lista"), 4);
                    for (String[] item : lista) {
                        objBnPriorizacion.setMode("I");
                        objBnPriorizacion.setDetalle(Integer.valueOf(item[0].trim() + 1));
                        objBnPriorizacion.setUnidadOperativa(item[1].trim());
                        objBnPriorizacion.setSolicitudCredito(item[2].trim());
                        objBnPriorizacion.setTipo(item[3].trim());
                        k = objDsPriorizacion.iduPriorizacionPCADetalle(objBnPriorizacion, objUsuario.getUsuario());
                    }
                    if (k == 0) {
                        result = "ERROR";
                        objBnMsgerr = new BeanMsgerr();
                        objBnMsgerr.setUsuario(objUsuario.getUsuario());
                        objBnMsgerr.setTabla("SIPE_PRIORIZACION_DETALLE");
                        objBnMsgerr.setTipo(objBnPriorizacion.getMode());
                        objDsMsgerr = new MsgerrDAOImpl(objConnection);
                        objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
                        resulDetalle = objBnMsgerr.getDescripcion();
                    }
                }
                break;
            default:
                break;
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_PRIORIZACION");
            objBnMsgerr.setTipo(objBnPriorizacion.getMode());
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
