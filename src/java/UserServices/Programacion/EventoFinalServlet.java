/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanEventos;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.EventoFinalDAO;
import DataService.Despachadores.Impl.EventoFinalDAOImpl;
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
@WebServlet(name = "EventoFinalServlet", urlPatterns = {"/EventoFinal"})
public class EventoFinalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objEvento;
    private BeanEventos objBnEvento;
    private Connection objConnection;
    private EventoFinalDAO objDsEvento;

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
        objBnEvento.setEvento(Utiles.Utiles.checkNum(request.getParameter("eventoFinal")));
        objBnEvento.setNivel(Utiles.Utiles.checkNum(request.getParameter("nivel")));
        objDsEvento = new EventoFinalDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS. 
        if (objBnEvento.getMode().equals("G")) {
            objEvento = objDsEvento.getListaEventoFinal(objBnEvento, objUsuario.getUsuario());
        }
        if (objBnEvento.getMode().equals("U")) {
            objBnEvento = objDsEvento.getEventoFinal(objBnEvento, objUsuario.getUsuario());
            result = objBnEvento.getNombreEvento() + "+++"
                    + objBnEvento.getDependencia() + "+++"
                    + objBnEvento.getOrden()+ "+++"
                    + objBnEvento.getCantidad();
        }
        if (objBnEvento.getMode().equals("C")) {
            result = objDsEvento.getUltimoEventoFinal(objBnEvento, objUsuario.getUsuario());
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
        switch (request.getParameter("mode")) {
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaEventoFinal.jsp");
                break;
            default:
                dispatcher = request.getRequestDispatcher("error.jsp");
                break;
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
