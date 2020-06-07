/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Planeamiento;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPlaneamiento;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.ActividadesOperativasDAO;
import DataService.Despachadores.Impl.ActividadesOperativasDAOImpl;
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
@WebServlet(name = "IduActividadesOperativasDetalleServlet", urlPatterns = {"/IduActividadesOperativasDetalle"})
public class IduActividadesOperativasDetalleServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private Connection objConnection;
    private BeanPlaneamiento objBnActividadesOperativas;
    private ActividadesOperativasDAO objDsActividadesOperativas;
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
        response.setContentType("text/html;charset=UTF-8");
        String result = null;
        int k = 0;
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnActividadesOperativas = new BeanPlaneamiento();
        objBnActividadesOperativas.setMode(request.getParameter("mode"));
        objBnActividadesOperativas.setPeriodo(request.getParameter("periodo"));
        objBnActividadesOperativas.setObjetivo(Utiles.checkNum(request.getParameter("objetivo")));
        objBnActividadesOperativas.setAcciones(Utiles.checkNum(request.getParameter("accion")));
        objBnActividadesOperativas.setActividades(Utiles.checkNum(request.getParameter("actividades")));
        objBnActividadesOperativas.setTareaOperativa(request.getParameter("tareaOperativa"));
        objBnActividadesOperativas.setUbigeo(request.getParameter("ubigeo"));
        objBnActividadesOperativas.setCantidadEnero(0);
        objBnActividadesOperativas.setCantidadFebrero(0);
        objBnActividadesOperativas.setCantidadMarzo(0);
        objBnActividadesOperativas.setCantidadAbril(0);
        objBnActividadesOperativas.setCantidadMayo(0);
        objBnActividadesOperativas.setCantidadJunio(0);
        objBnActividadesOperativas.setCantidadJulio(0);
        objBnActividadesOperativas.setCantidadAgosto(0);
        objBnActividadesOperativas.setCantidadSetiembre(0);
        objBnActividadesOperativas.setCantidadOctubre(0);
        objBnActividadesOperativas.setCantidadNoviembre(0);
        objBnActividadesOperativas.setCantidadDiciembre(0);
        objBnActividadesOperativas.setMontoEnero(0.0);
        objBnActividadesOperativas.setMontoFebrero(0.0);
        objBnActividadesOperativas.setMontoMarzo(0.0);
        objBnActividadesOperativas.setMontoAbril(0.0);
        objBnActividadesOperativas.setMontoMayo(0.0);
        objBnActividadesOperativas.setMontoJunio(0.0);
        objBnActividadesOperativas.setMontoJulio(0.0);
        objBnActividadesOperativas.setMontoAgosto(0.0);
        objBnActividadesOperativas.setMontoSetiembre(0.0);
        objBnActividadesOperativas.setMontoOctubre(0.0);
        objBnActividadesOperativas.setMontoNoviembre(0.0);
        objBnActividadesOperativas.setMontoDiciembre(0.0);
        objDsActividadesOperativas = new ActividadesOperativasDAOImpl(objConnection);
        if (objBnActividadesOperativas.getMode().equals("D")) {
            k = objDsActividadesOperativas.iduActividadesOperativasDetalle(objBnActividadesOperativas, objUsuario.getUsuario());
        } else {
            Integer ano = 0;
            String valor = "";
            objBnActividadesOperativas.setMode("D");
            k = objDsActividadesOperativas.iduActividadesOperativasDetalle(objBnActividadesOperativas, objUsuario.getUsuario());
            for (int n = 0; n < 3; n++) {
                switch (n) {
                    case 0:
                        ano = Utiles.checkNum(objBnActividadesOperativas.getPeriodo()) + n;
                        valor = "A";
                        break;
                    case 1:
                        ano = Utiles.checkNum(objBnActividadesOperativas.getPeriodo()) + n;
                        valor = "B";
                        break;
                    case 2:
                        ano = Utiles.checkNum(objBnActividadesOperativas.getPeriodo()) + n;
                        valor = "C";
                        break;
                    default:
                        ano = 0;
                        valor = "";
                        break;
                }
                objBnActividadesOperativas.setMode("I");
                objBnActividadesOperativas.setAnoRegistro("" + ano);
                objBnActividadesOperativas.setMontoEnero(Utiles.checkDouble(request.getParameter("montoEnero" + valor)));
                objBnActividadesOperativas.setMontoFebrero(Utiles.checkDouble(request.getParameter("montoFebrero" + valor)));
                objBnActividadesOperativas.setMontoMarzo(Utiles.checkDouble(request.getParameter("montoMarzo" + valor)));
                objBnActividadesOperativas.setMontoAbril(Utiles.checkDouble(request.getParameter("montoAbril" + valor)));
                objBnActividadesOperativas.setMontoMayo(Utiles.checkDouble(request.getParameter("montoMayo" + valor)));
                objBnActividadesOperativas.setMontoJunio(Utiles.checkDouble(request.getParameter("montoJunio" + valor)));
                objBnActividadesOperativas.setMontoJulio(Utiles.checkDouble(request.getParameter("montoJulio" + valor)));
                objBnActividadesOperativas.setMontoAgosto(Utiles.checkDouble(request.getParameter("montoAgosto" + valor)));
                objBnActividadesOperativas.setMontoSetiembre(Utiles.checkDouble(request.getParameter("montoSetiembre" + valor)));
                objBnActividadesOperativas.setMontoOctubre(Utiles.checkDouble(request.getParameter("montoOctubre" + valor)));
                objBnActividadesOperativas.setMontoNoviembre(Utiles.checkDouble(request.getParameter("montoNoviembre" + valor)));
                objBnActividadesOperativas.setMontoDiciembre(Utiles.checkDouble(request.getParameter("montoDiciembre" + valor)));
                objBnActividadesOperativas.setCantidadEnero(Utiles.checkNum(request.getParameter("cantidadEnero" + valor)));
                objBnActividadesOperativas.setCantidadFebrero(Utiles.checkNum(request.getParameter("cantidadFebrero" + valor)));
                objBnActividadesOperativas.setCantidadMarzo(Utiles.checkNum(request.getParameter("cantidadMarzo" + valor)));
                objBnActividadesOperativas.setCantidadAbril(Utiles.checkNum(request.getParameter("cantidadAbril" + valor)));
                objBnActividadesOperativas.setCantidadMayo(Utiles.checkNum(request.getParameter("cantidadMayo" + valor)));
                objBnActividadesOperativas.setCantidadJunio(Utiles.checkNum(request.getParameter("cantidadJunio" + valor)));
                objBnActividadesOperativas.setCantidadJulio(Utiles.checkNum(request.getParameter("cantidadJulio" + valor)));
                objBnActividadesOperativas.setCantidadAgosto(Utiles.checkNum(request.getParameter("cantidadAgosto" + valor)));
                objBnActividadesOperativas.setCantidadSetiembre(Utiles.checkNum(request.getParameter("cantidadSetiembre" + valor)));
                objBnActividadesOperativas.setCantidadOctubre(Utiles.checkNum(request.getParameter("cantidadOctubre" + valor)));
                objBnActividadesOperativas.setCantidadNoviembre(Utiles.checkNum(request.getParameter("cantidadNoviembre" + valor)));
                objBnActividadesOperativas.setCantidadDiciembre(Utiles.checkNum(request.getParameter("cantidadDiciembre" + valor)));
                k = objDsActividadesOperativas.iduActividadesOperativasDetalle(objBnActividadesOperativas, objUsuario.getUsuario());
            }
        }
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPRE_POI_ACTIVIDADES_OPE_DETA");
            objBnMsgerr.setTipo(objBnActividadesOperativas.getMode());
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
