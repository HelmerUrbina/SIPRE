
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanProgramacionPresupuestal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.ProgramacionMultianualDAOImpl;
import DataService.Despachadores.ProgramacionMultianualDAO;
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
@WebServlet(name = "ProgramacionMultianualServlet", urlPatterns = {"/ProgramacionMultianual"})
public class ProgramacionMultianualServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objProgramacion;
    private List objProgramacionDetalle;
    private BeanProgramacionPresupuestal objBnProgramacion;
    private Connection objConnection;
    private ProgramacionMultianualDAO objDsProgramacion;

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
        String result = null;
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnProgramacion = new BeanProgramacionPresupuestal();
        objBnProgramacion.setMode(request.getParameter("mode"));
        objBnProgramacion.setPeriodo(request.getParameter("periodo"));
        objBnProgramacion.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnProgramacion.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnProgramacion.setDependencia(request.getParameter("dependencia"));
        objBnProgramacion.setCodigo(request.getParameter("codigo"));
        objDsProgramacion = new ProgramacionMultianualDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnProgramacion.getMode().equals("G")) {
            objProgramacion = objDsProgramacion.getListaProgramacionMultianual(objBnProgramacion, objUsuario.getUsuario());
            objProgramacionDetalle = objDsProgramacion.getListaProgramacionMultianualDetalle(objBnProgramacion, objUsuario.getUsuario());
        }
        if (objBnProgramacion.getMode().equals("U")) {
            objBnProgramacion = objDsProgramacion.getProgramadoMultianual(objBnProgramacion, objUsuario.getUsuario());
            result = objBnProgramacion.getDepartamento() + "+++"
                    + objBnProgramacion.getProvincia() + "+++"
                    + objBnProgramacion.getDistrito() + "+++"
                    + objBnProgramacion.getProgramado() + "+++"
                    + objBnProgramacion.getEnero() + "+++"
                    + objBnProgramacion.getFebrero() + "+++"
                    + objBnProgramacion.getMarzo() + "+++"
                    + objBnProgramacion.getEstado() + "+++"
                    + objBnProgramacion.getUnidadMedida();
        }
        if (objBnProgramacion.getMode().equals("A")) {
            objBnProgramacion = objDsProgramacion.getProgramadoMultianualDetalle(objBnProgramacion, objUsuario.getUsuario());
            result = objBnProgramacion.getGenericaGasto() + "+++"
                    + objBnProgramacion.getEnero() + "+++"
                    + objBnProgramacion.getFebrero() + "+++"
                    + objBnProgramacion.getMarzo();
        }
        if (objBnProgramacion.getMode().equals("B")) {
            result = "" + objDsProgramacion.getDatosProgramacionMultianualDetalle(objBnProgramacion, objUsuario.getUsuario());
        }
        if (objBnProgramacion.getMode().equals("C")) {
            objBnProgramacion = objDsProgramacion.getProgramadoMultianualMetaFisica(objBnProgramacion, objUsuario.getUsuario());
            result = objBnProgramacion.getGenericaGasto() + "+++"
                    + objBnProgramacion.getUnidadMedida() + "+++"
                    + objBnProgramacion.getEnero() + "+++"
                    + objBnProgramacion.getFebrero() + "+++"
                    + objBnProgramacion.getMarzo();
        }
        if (objBnProgramacion.getMode().equals("E")) {
            objBnProgramacion = objDsProgramacion.getSaldoUtilidadEnteGenerador(objBnProgramacion, objUsuario.getUsuario());
            result = objBnProgramacion.getEnero() + "+++"
                    + objBnProgramacion.getFebrero() + "+++"
                    + objBnProgramacion.getMarzo();
        }
        if (objBnProgramacion.getMode().equals("S")) {
            objBnProgramacion = objDsProgramacion.getSaldoFuerzaOperativa(objBnProgramacion, objUsuario.getUsuario());
            result = objBnProgramacion.getEnero() + "+++"
                    + objBnProgramacion.getFebrero() + "+++"
                    + objBnProgramacion.getMarzo();
        }
        if (request.getAttribute("objBnProgramacionMultianual") != null) {
            request.removeAttribute("objBnProgramacionMultianual");
        }
        if (request.getAttribute("objProgramacionMultianual") != null) {
            request.removeAttribute("objProgramacionMultianual");
        }
        if (request.getAttribute("objProgramacionMultianualDetalle") != null) {
            request.removeAttribute("objProgramacionMultianualDetalle");
        }
        request.setAttribute("objBnProgramacionMultianual", objBnProgramacion);
        request.setAttribute("objProgramacionMultianual", objProgramacion);
        request.setAttribute("objProgramacionMultianualDetalle", objProgramacionDetalle);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "programacionMultianual":
                dispatcher = request.getRequestDispatcher("Programacion/ProgramacionMultianual.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaProgramacionMultianual.jsp");
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
