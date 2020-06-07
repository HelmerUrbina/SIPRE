/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanCalendarioGastos;
import BusinessServices.Beans.BeanEventos;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CalendarioGastosDAO;
import DataService.Despachadores.EventoPrincipalDAO;
import DataService.Despachadores.Impl.CalendarioGastosDAOImpl;
import DataService.Despachadores.Impl.EventoPrincipalDAOImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
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
@WebServlet(name = "CalendarioGastosServlet", urlPatterns = {"/CalendarioGastos"})
public class CalendarioGastosServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objCalendarioGastos;
    private List objCalendarioGastosDetalle;
    private BeanCalendarioGastos objBnCalendarioGastos;
    private Connection objConnection;
    private CalendarioGastosDAO objDsCalendarioGastos;

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
        String result = null;
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
        objBnCalendarioGastos.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnCalendarioGastos.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnCalendarioGastos.setCodigo(request.getParameter("codigo"));
        objDsCalendarioGastos = new CalendarioGastosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnCalendarioGastos.getMode().equals("G")) {
            objCalendarioGastos = objDsCalendarioGastos.getListaCalendarioGastos(objBnCalendarioGastos, objUsuario.getUsuario());
            objCalendarioGastosDetalle = objDsCalendarioGastos.getListaCalendarioGastosDetalle(objBnCalendarioGastos, objUsuario.getUsuario());
        }
        if (objBnCalendarioGastos.getMode().equals("B")) {
            result = "" + objDsCalendarioGastos.getListaCalendarioGastoDetalle(objBnCalendarioGastos, objUsuario.getUsuario());
        }
        if (objBnCalendarioGastos.getMode().equals("C")) {
            EventoPrincipalDAO objDsEventoPrincipal = new EventoPrincipalDAOImpl(objConnection);
            BeanEventos objBnEventos = new BeanEventos();
            objBnEventos.setMode(request.getParameter("mode"));
            objBnEventos.setPeriodo(request.getParameter("periodo"));
            objBnEventos.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
            objBnEventos.setUnidadOperativa(request.getParameter("unidadOperativa"));
            objBnEventos.setTarea(request.getParameter("codigo").substring(0, 4));
            List lista = objDsEventoPrincipal.getListaEventoPrincipal(objBnEventos, objUsuario.getUsuario());
            ArrayList<String> Arreglo = new ArrayList<>();
            ArrayList<String> Filas = new ArrayList<>();
            for (Object item :  lista) {
                Filas.clear();
                String arreglo = ((BeanEventos) item).getCodigo() + "+++"
                        + ((BeanEventos) item).getNombreEvento() + "+++"                      
                        + ((BeanEventos) item).getNivel() + "+++"
                        + ((BeanEventos) item).getCantidad() + "+++"
                        + ((BeanEventos) item).getProgramado() + "+++"
                        + ((BeanEventos) item).getEnero() + "+++"
                        + ((BeanEventos) item).getFebrero() + "+++"
                        + ((BeanEventos) item).getMarzo() + "+++"
                        + ((BeanEventos) item).getAbril() + "+++"
                        + ((BeanEventos) item).getMayo() + "+++"
                        + ((BeanEventos) item).getJunio() + "+++"
                        + ((BeanEventos) item).getJulio() + "+++"
                        + ((BeanEventos) item).getAgosto() + "+++"
                        + ((BeanEventos) item).getSetiembre() + "+++"
                        + ((BeanEventos) item).getOctubre() + "+++"
                        + ((BeanEventos) item).getNoviembre() + "+++"
                        + ((BeanEventos) item).getDiciembre() + "+++"
                        + ((BeanEventos) item).getTotal();               
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
            result = "" + Arreglo;           
        }
        if (request.getAttribute("objCalendarioGastos") != null) {
            request.removeAttribute("objCalendarioGastos");
        }
        if (request.getAttribute("objCalendarioGastosDetalle") != null) {
            request.removeAttribute("objCalendarioGastosDetalle");
        }
        request.setAttribute("objCalendarioGastos", objCalendarioGastos);
        request.setAttribute("objCalendarioGastosDetalle", objCalendarioGastosDetalle);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "calendarioGastos":
                dispatcher = request.getRequestDispatcher("Ejecucion/CalendarioGastos.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaCalendarioGastos.jsp");
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
