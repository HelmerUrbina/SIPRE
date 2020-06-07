/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Consultas;

import BusinessServices.Beans.BeanCadenaFuncional;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CadenaFuncionalEjecucionDAO;
import DataService.Despachadores.Impl.CadenaFuncionalEjecucionDAOImpl;
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
@WebServlet(name = "CadenaFuncionalEjecucionServlet", urlPatterns = {"/CadenaFuncionalEjecucion"})
public class CadenaFuncionalEjecucionServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objCadenaFuncional;
    private BeanCadenaFuncional objBnCadenaFuncional;
    private Connection objConnection;
    private CadenaFuncionalEjecucionDAO objDsCadenaFuncional;

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
        objBnCadenaFuncional = new BeanCadenaFuncional();
        objBnCadenaFuncional.setMode(request.getParameter("mode"));
        objBnCadenaFuncional.setPeriodo(request.getParameter("periodo"));
        objBnCadenaFuncional.setCodigo(request.getParameter("codigo"));
        objDsCadenaFuncional = new CadenaFuncionalEjecucionDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnCadenaFuncional.getMode().equals("G")) {
            objCadenaFuncional = objDsCadenaFuncional.getListaCadenaFuncional(objBnCadenaFuncional, objUsuario.getUsuario());
        }        
        if (objBnCadenaFuncional.getMode().equals("B")) {
            objBnCadenaFuncional.setActividad(request.getParameter("actividad"));
            result = objDsCadenaFuncional.getMetaPresupuestal(objBnCadenaFuncional, objUsuario.getUsuario());
        }
        if (objBnCadenaFuncional.getMode().equals("U")) {
            objBnCadenaFuncional = objDsCadenaFuncional.getCadenaFuncional(objBnCadenaFuncional, objUsuario.getUsuario());
            result = objBnCadenaFuncional.getSecuenciaFuncional() + "+++"
                    + objBnCadenaFuncional.getCategoriaPresupuestal() + "+++"
                    + objBnCadenaFuncional.getCategoriaPresupuestalNombre() + "+++"
                    + objBnCadenaFuncional.getProducto() + "+++"
                    + objBnCadenaFuncional.getProductoNombre() + "+++"
                    + objBnCadenaFuncional.getActividad() + "+++"
                    + objBnCadenaFuncional.getActividadNombre() + "+++"
                    + objBnCadenaFuncional.getFuncion() + "+++"
                    + objBnCadenaFuncional.getFuncionNombre() + "+++"
                    + objBnCadenaFuncional.getDivisionFuncional() + "+++"
                    + objBnCadenaFuncional.getDivisionFuncionalNombre() + "+++"
                    + objBnCadenaFuncional.getGrupoFuncional() + "+++"
                    + objBnCadenaFuncional.getGrupoFuncionalNombre() + "+++"
                    + objBnCadenaFuncional.getMeta() + "+++"
                    + objBnCadenaFuncional.getMetaNombre() + "+++"
                    + objBnCadenaFuncional.getFinalidad() + "+++"
                    + objBnCadenaFuncional.getFinalidadNombre() + "+++"
                    + objBnCadenaFuncional.getUnidadMedida() + "+++"
                    + objBnCadenaFuncional.getDepartamento() + "+++"
                    + objBnCadenaFuncional.getProvincia() + "+++"
                    + objBnCadenaFuncional.getDistrito();
        }
        if (request.getAttribute("objCadenaFuncional") != null) {
            request.removeAttribute("objCadenaFuncional");
        }
        request.setAttribute("objCadenaFuncional", objCadenaFuncional);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "cadenaFuncional":
                dispatcher = request.getRequestDispatcher("Consultas/CadenaFuncionalEjecucion.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Consultas/ListaCadenaFuncionalEjecucion.jsp");
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
