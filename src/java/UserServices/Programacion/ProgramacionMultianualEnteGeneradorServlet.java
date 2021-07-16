/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanEnteRecaudador;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.ProgramacionMultianualEnteGeneradorDAOImpl;
import DataService.Despachadores.ProgramacionMultianualEnteGeneradorDAO;
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
@WebServlet(name = "ProgramacionMultianualEnteGeneradorServlet", urlPatterns = {"/ProgramacionMultianualEnteGenerador"})
public class ProgramacionMultianualEnteGeneradorServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objProgramacionMultianualEnteGenerador;
    private List objProgramacionMultianualEnteGeneradorDetalle;
    private BeanEnteRecaudador objBnProgramacionMultianualEnteGenerador;
    private Connection objConnection;
    private ProgramacionMultianualEnteGeneradorDAO objDsProgramacionMultianualEnteGenerador;

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
        objBnProgramacionMultianualEnteGenerador = new BeanEnteRecaudador();
        objBnProgramacionMultianualEnteGenerador.setMode(request.getParameter("mode"));
        objBnProgramacionMultianualEnteGenerador.setPeriodo(request.getParameter("periodo"));
        objBnProgramacionMultianualEnteGenerador.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnProgramacionMultianualEnteGenerador.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnProgramacionMultianualEnteGenerador.setCodigo(Utiles.Utiles.checkNum(request.getParameter("codigo")));
        objDsProgramacionMultianualEnteGenerador = new ProgramacionMultianualEnteGeneradorDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnProgramacionMultianualEnteGenerador.getMode().equals("G")) {
            objProgramacionMultianualEnteGenerador = objDsProgramacionMultianualEnteGenerador.getListaProgramacionMultianualEnteGenerador(objBnProgramacionMultianualEnteGenerador, objUsuario.getUsuario());
            objProgramacionMultianualEnteGeneradorDetalle = objDsProgramacionMultianualEnteGenerador.getListaProgramacionMultianualEnteGeneradorDetalle(objBnProgramacionMultianualEnteGenerador, objUsuario.getUsuario());
        }
        if (objBnProgramacionMultianualEnteGenerador.getMode().equals("U")) {
            objBnProgramacionMultianualEnteGenerador = objDsProgramacionMultianualEnteGenerador.getProgramacionMultianualEnteGenerador(objBnProgramacionMultianualEnteGenerador, objUsuario.getUsuario());
            result = objBnProgramacionMultianualEnteGenerador.getCadenaIngreso() + "+++"
                    + objBnProgramacionMultianualEnteGenerador.getDescripcion() + "+++"
                    + objBnProgramacionMultianualEnteGenerador.getEnero() + "+++"
                    + objBnProgramacionMultianualEnteGenerador.getFebrero() + "+++"
                    + objBnProgramacionMultianualEnteGenerador.getMarzo() + "+++"
                    + objBnProgramacionMultianualEnteGenerador.getCostoEnero() + "+++"
                    + objBnProgramacionMultianualEnteGenerador.getCostoFebrero() + "+++"
                    + objBnProgramacionMultianualEnteGenerador.getCostoMarzo();

        }
        if (request.getAttribute("objProgramacionMultianualEnteGenerador") != null) {
            request.removeAttribute("objProgramacionMultianualEnteGenerador");
        }
        if (request.getAttribute("objProgramacionMultianualEnteGeneradorDetalle") != null) {
            request.removeAttribute("objProgramacionMultianualEnteGeneradorDetalle");
        }
        if (request.getAttribute("objBnProgramacionMultianualEnteGenerador") != null) {
            request.removeAttribute("objBnProgramacionMultianualEnteGenerador");
        }
        request.setAttribute("objProgramacionMultianualEnteGenerador", objProgramacionMultianualEnteGenerador);
        request.setAttribute("objProgramacionMultianualEnteGeneradorDetalle", objProgramacionMultianualEnteGeneradorDetalle);
        request.setAttribute("objBnProgramacionMultianualEnteGenerador", objBnProgramacionMultianualEnteGenerador);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "progMultiEnteGenerador":
                dispatcher = request.getRequestDispatcher("Programacion/ProgramacionMultianualEnteGenerador.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaProgramacionMultianualEnteGenerador.jsp");
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
