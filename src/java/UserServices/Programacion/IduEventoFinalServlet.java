/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanEventos;
import BusinessServices.Beans.BeanHojaTrabajo;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.EventoFinalDAO;
import DataService.Despachadores.HojaTrabajoDAO;
import DataService.Despachadores.Impl.EventoFinalDAOImpl;
import DataService.Despachadores.Impl.HojaTrabajoDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import Utiles.Utiles;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;
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
@WebServlet(name = "IduEventoFinalServlet", urlPatterns = {"/IduEventoFinal"})
public class IduEventoFinalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanEventos objBnEvento;
    private Connection objConnection;
    private EventoFinalDAO objDsEvento;
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
        objBnEvento.setEvento(Utiles.checkNum(request.getParameter("eventoFinal")));
        objBnEvento.setNombreEvento(request.getParameter("nombreEvento"));
        objBnEvento.setDependencia(request.getParameter("dependencia"));
        objBnEvento.setOrden(Utiles.checkNum(request.getParameter("orden")));
        objBnEvento.setCantidad(Utiles.checkNum(request.getParameter("cantidad")));
        objDsEvento = new EventoFinalDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = 0;
        switch (objBnEvento.getMode()) {
            case "B": {
                List lista = objDsEvento.getListaHojaTrabajo(objBnEvento, objUsuario.getUsuario());
                objBnEvento.setMode("I");
                objBnEvento.setEvento(0);
                k = objDsEvento.iduEventoFinal(objBnEvento, objUsuario.getUsuario());
                String codigo = objDsEvento.getUltimoEventoFinal(objBnEvento, objUsuario.getUsuario());
                HojaTrabajoDAO objDsHojaTrabajo = new HojaTrabajoDAOImpl(objConnection);
                lista.forEach((lista1) -> {
                    BeanHojaTrabajo val = (BeanHojaTrabajo) lista1;
                    val.setPeriodo(request.getParameter("periodo"));
                    val.setUnidadOperativa(request.getParameter("unidadOperativa"));
                    val.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
                    val.setTarea(request.getParameter("tarea"));
                    val.setEventoPrincipal(request.getParameter("codigo"));
                    val.setEventoFinal(codigo);
                    val.setCorrelativo(0);
                    val.setMode("I");
                    int s = objDsHojaTrabajo.iduHojaTrabajo(val, objUsuario.getUsuario());
                });
                break;
            }
            default: {
                k = objDsEvento.iduEventoFinal(objBnEvento, objUsuario.getUsuario());
                break;
            }
        }
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("TAEVFI");
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
