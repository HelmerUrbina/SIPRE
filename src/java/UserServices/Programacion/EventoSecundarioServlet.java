/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanEventos;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.EventoSecundarioDAO;
import DataService.Despachadores.Impl.EventoSecundarioDAOImpl;
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
@WebServlet(name = "EventoSecundarioServlet", urlPatterns = {"/EventoSecundario"})
public class EventoSecundarioServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objEvento;
    private BeanEventos objBnEvento;
    private Connection objConnection;
    private EventoSecundarioDAO objDsEvento;

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
        //VERIFICAMOS LA SESSION DEL USUARIO
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnEvento = new BeanEventos();
        objBnEvento.setMode(request.getParameter("mode"));
        objBnEvento.setPeriodo(request.getParameter("periodo"));
        objBnEvento.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnEvento.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnEvento.setTarea(request.getParameter("tarea"));
        objBnEvento.setCodigo(request.getParameter("codigo"));
        objBnEvento.setNivel(Utiles.Utiles.checkNum(request.getParameter("nivel")));
        objDsEvento = new EventoSecundarioDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS. 
        objBnEvento = objDsEvento.getEventoPrincipal(objBnEvento, objUsuario.getUsuario());
        if (objBnEvento.getNiveles() == 0) {
            if (objBnEvento.getMode().equals("EP")) {
                objEvento = objDsEvento.getListaEventoPrincipal(objBnEvento, objUsuario.getUsuario());
            }
            if (objBnEvento.getMode().equals("ES")) {
                objEvento = objDsEvento.getListaEventoFinal(objBnEvento, objUsuario.getUsuario());
            }
        } else {
            if (objBnEvento.getMode().equals("EP")) {
                objBnEvento.setNivel(objBnEvento.getNivel() - 1);
                objBnEvento.setCodigo(objBnEvento.getCodigo().substring(0, objBnEvento.getCodigo().lastIndexOf("-") ));                
                if (objBnEvento.getNivel() == 0) {
                    objEvento = objDsEvento.getListaEventoPrincipal(objBnEvento, objUsuario.getUsuario());
                } else {
                    objEvento = objDsEvento.getListaEventoSecundario(objBnEvento, objUsuario.getUsuario());
                }
            }
            if (objBnEvento.getMode().equals("ES")) {
                objBnEvento.setNivel(objBnEvento.getNivel() + 1);
                if (objBnEvento.getNivel() > objBnEvento.getNiveles()) {
                    objEvento = objDsEvento.getListaEventoFinal(objBnEvento, objUsuario.getUsuario());
                } else {
                    objEvento = objDsEvento.getListaEventoSecundario(objBnEvento, objUsuario.getUsuario());
                }
            }
        }
        if (objBnEvento.getMode().equals("G")) {
            objEvento = objDsEvento.getListaEventoSecundario(objBnEvento, objUsuario.getUsuario());
        }
        if (objBnEvento.getMode().equals("I")) {
            result = objDsEvento.getCodigoEventoSecundario(objBnEvento, objUsuario.getUsuario());
        }
        if (objBnEvento.getMode().equals("U")) {
            objBnEvento = objDsEvento.getEventoSecundario(objBnEvento, objUsuario.getUsuario());
            result = objBnEvento.getCodigo() + "+++"
                    + objBnEvento.getNombreEvento();
        }

        if (request.getAttribute("objBnEvento") != null) {
            request.removeAttribute("objBnEvento");
        }
        if (request.getAttribute("objEvento") != null) {
            request.removeAttribute("objEvento");
        }
        request.setAttribute("objBnEvento", objBnEvento);
        request.setAttribute("objEvento", objEvento);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO        
        if (objBnEvento.getNiveles() > 0) {
            if (request.getParameter("mode").equals("ES") || request.getParameter("mode").equals("EP") || request.getParameter("mode").equals("G")) {
                dispatcher = request.getRequestDispatcher("Programacion/ListaEventoSecundario.jsp");
            }
            if (objBnEvento.getNivel() == 0 && request.getParameter("mode").equals("EP")) {
                dispatcher = request.getRequestDispatcher("Programacion/ListaEventoPrincipal.jsp");
            }
            if (objBnEvento.getNivel() > objBnEvento.getNiveles()) {
                dispatcher = request.getRequestDispatcher("Programacion/ListaEventoFinal.jsp");
            }
        } else {
            if (request.getParameter("mode").equals("ES")) {
                dispatcher = request.getRequestDispatcher("Programacion/ListaEventoFinal.jsp");
            }
            if (request.getParameter("mode").equals("EP")) {
                dispatcher = request.getRequestDispatcher("Programacion/ListaEventoPrincipal.jsp");
            }
        }

        if (result != null) {
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(result);
            }
        } else {
            dispatcher.forward(request, response);
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
