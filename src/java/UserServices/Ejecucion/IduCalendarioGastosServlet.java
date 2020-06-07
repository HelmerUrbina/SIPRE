/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanCalendarioGastos;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.CalendarioGastosDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.CalendarioGastosDAO;
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
@WebServlet(name = "IduCalendarioGastosServlet", urlPatterns = {"/IduCalendarioGastos"})
public class IduCalendarioGastosServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanCalendarioGastos objBnCalendarioGastos;
    private Connection objConnection;
    private CalendarioGastosDAO objDsCalendarioGastos;
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
        objBnCalendarioGastos = new BeanCalendarioGastos();
        objBnCalendarioGastos.setMode(request.getParameter("mode"));
        objBnCalendarioGastos.setPeriodo(request.getParameter("periodo"));
        objBnCalendarioGastos.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnCalendarioGastos.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        String[] codigo = request.getParameter("codigo").split("-");
        objBnCalendarioGastos.setTarea(codigo[0].trim());
        objBnCalendarioGastos.setSecuenciaFuncional(codigo[1].trim());
        objBnCalendarioGastos.setTipoCalendario(codigo[2].trim());
        objBnCalendarioGastos.setResolucion(codigo[3].trim());
        objBnCalendarioGastos.setGenericaGasto(codigo[4].trim());
        objDsCalendarioGastos = new CalendarioGastosDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO        
        String lista[][] = Utiles.generaLista(request.getParameter("lista"), 16);
        for (String[] item : lista) {
            objBnCalendarioGastos.setMode("I");
            objBnCalendarioGastos.setDependencia(item[1]);
            objBnCalendarioGastos.setCadenaGasto(item[2]);
            objBnCalendarioGastos.setEnero(Utiles.checkDouble(item[3]));
            objBnCalendarioGastos.setFebrero(Utiles.checkDouble(item[4]));
            objBnCalendarioGastos.setMarzo(Utiles.checkDouble(item[5]));
            objBnCalendarioGastos.setAbril(Utiles.checkDouble(item[6]));
            objBnCalendarioGastos.setMayo(Utiles.checkDouble(item[7]));
            objBnCalendarioGastos.setJunio(Utiles.checkDouble(item[8]));
            objBnCalendarioGastos.setJulio(Utiles.checkDouble(item[9]));
            objBnCalendarioGastos.setAgosto(Utiles.checkDouble(item[10]));
            objBnCalendarioGastos.setSetiembre(Utiles.checkDouble(item[11]));
            objBnCalendarioGastos.setOctubre(Utiles.checkDouble(item[12]));
            objBnCalendarioGastos.setNoviembre(Utiles.checkDouble(item[13]));
            objBnCalendarioGastos.setDiciembre(Utiles.checkDouble(item[14]));
            objBnCalendarioGastos.setImporte(Utiles.checkDouble(item[15]));
            k = objDsCalendarioGastos.iduCalendarioGastoDetalle(objBnCalendarioGastos, objUsuario.getUsuario());
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0 || result != null) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("MODEPA");
            objBnMsgerr.setTipo(objBnCalendarioGastos.getMode());
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
