/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanEventos;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.EventoPrincipalDAO;
import DataService.Despachadores.Impl.EventoPrincipalDAOImpl;
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
@WebServlet(name = "IduEventoPrincipalServlet", urlPatterns = {"/IduEventoPrincipal"})
public class IduEventoPrincipalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanEventos objBnEvento;
    private Connection objConnection;
    private EventoPrincipalDAO objDsEvento;
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
        objBnEvento = new BeanEventos();
        objBnEvento.setMode(request.getParameter("mode"));
        objBnEvento.setPeriodo(request.getParameter("periodo"));
        objBnEvento.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnEvento.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnEvento.setTarea(request.getParameter("tarea"));
        objBnEvento.setCodigo(request.getParameter("codigo"));
        objBnEvento.setNombreEvento(request.getParameter("evento"));
        objBnEvento.setComentario(request.getParameter("comentario"));
        objBnEvento.setNiveles(Utiles.checkNum(request.getParameter("niveles")));
        objBnEvento.setCantidad(Utiles.checkNum(request.getParameter("cantidad"))); 
        objBnEvento.setNivel(Utiles.checkNum(request.getParameter("nivel")));  
        objBnEvento.setUltimoEvento(Utiles.checkBoolean(request.getParameter("eventoFinal")));
        objBnEvento.setEnero(Utiles.checkDouble(request.getParameter("enero")));
        objBnEvento.setFebrero(Utiles.checkDouble(request.getParameter("febrero")));
        objBnEvento.setMarzo(Utiles.checkDouble(request.getParameter("marzo")));
        objBnEvento.setAbril(Utiles.checkDouble(request.getParameter("abril")));
        objBnEvento.setMayo(Utiles.checkDouble(request.getParameter("mayo")));
        objBnEvento.setJunio(Utiles.checkDouble(request.getParameter("junio")));
        objBnEvento.setJulio(Utiles.checkDouble(request.getParameter("julio")));
        objBnEvento.setAgosto(Utiles.checkDouble(request.getParameter("agosto")));
        objBnEvento.setSetiembre(Utiles.checkDouble(request.getParameter("setiembre")));
        objBnEvento.setOctubre(Utiles.checkDouble(request.getParameter("octubre")));
        objBnEvento.setNoviembre(Utiles.checkDouble(request.getParameter("noviembre")));
        objBnEvento.setDiciembre(Utiles.checkDouble(request.getParameter("diciembre")));
        objDsEvento = new EventoPrincipalDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = 0;
        if (objBnEvento.getMode().equals("CF")) {
            k = objDsEvento.iduCantidadesFisicas(objBnEvento, objUsuario.getUsuario());
        } else {
            k = objDsEvento.iduEventoPrincipal(objBnEvento, objUsuario.getUsuario());
        }
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBnEvento.getMode());
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
