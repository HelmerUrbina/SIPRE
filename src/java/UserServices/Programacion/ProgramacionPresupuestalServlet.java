/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanProgramacionPresupuestal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.ProgramacionPresupuestalDAOImpl;
import DataService.Despachadores.ProgramacionPresupuestalDAO;
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
@WebServlet(name = "ProgramacionPresupuestalServlet", urlPatterns = {"/ProgramacionPresupuestal"})
public class ProgramacionPresupuestalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objProgramacion;
    private List objProgramacionDetalle;
    private BeanProgramacionPresupuestal objBnProgramacion;
    private Connection objConnection;
    private ProgramacionPresupuestalDAO objDsProgramacion;
    private CombosDAO objDsCombo;

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
        //VERIFICAMOS QUE LA SESSION SEA VALIDA
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnProgramacion = new BeanProgramacionPresupuestal();
        objBnProgramacion.setMode(request.getParameter("mode"));
        objBnProgramacion.setPeriodo(request.getParameter("periodo"));
        objBnProgramacion.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnProgramacion.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnProgramacion.setCodigo(request.getParameter("codigo"));
        objDsProgramacion = new ProgramacionPresupuestalDAOImpl(objConnection);
        objDsCombo = new CombosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnProgramacion.getMode().equals("G")) {
            objProgramacion = objDsProgramacion.getListaProgramacion(objBnProgramacion, objUsuario.getUsuario());
            objProgramacionDetalle = objDsProgramacion.getListaProgramacionDetalle(objBnProgramacion, objUsuario.getUsuario());
            objBnProgramacion.setProgramado(objDsProgramacion.getSaldoEnteGenerador(objBnProgramacion, objUsuario.getUsuario()));
            if (request.getAttribute("objTarea") != null) {
                request.removeAttribute("objTarea");
            }
            if (request.getAttribute("objGenericaGasto") != null) {
                request.removeAttribute("objGenericaGasto");
            }            
            request.setAttribute("objTarea", objDsCombo.getTarea());
            request.setAttribute("objGenericaGasto", objDsCombo.getGenericaGasto());            
        }
        if (objBnProgramacion.getMode().equals("U")) {
            objBnProgramacion = objDsProgramacion.getProgramado(objBnProgramacion, objUsuario.getUsuario());
            result = objBnProgramacion.getCadenaFuncional() + "+++"
                    + objBnProgramacion.getTipoCalendario() + "+++"
                    + objBnProgramacion.getImporte() + "+++"
                    + objBnProgramacion.getGenericaGasto() + "+++"
                    + objBnProgramacion.getUnidadMedida();
        }
        if (request.getAttribute("objBnProgramacionPresupuestal") != null) {
            request.removeAttribute("objBnProgramacionPresupuestal");
        }
        if (request.getAttribute("objProgramacionPresupuestal") != null) {
            request.removeAttribute("objProgramacionPresupuestal");
        }
        if (request.getAttribute("objProgramacionDetalle") != null) {
            request.removeAttribute("objProgramacionDetalle");
        }
        request.setAttribute("objBnProgramacionPresupuestal", objBnProgramacion);
        request.setAttribute("objProgramacionPresupuestal", objProgramacion);
        request.setAttribute("objProgramacionDetalle", objProgramacionDetalle);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "programacionPresupuestal":
                dispatcher = request.getRequestDispatcher("Programacion/ProgramacionPresupuestal.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaProgramacionPresupuestal.jsp");
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
