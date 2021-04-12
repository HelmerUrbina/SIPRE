/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanFuerzaOperativa;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.FuerzaOperativaDAOImpl;
import DataService.Despachadores.FuerzaOperativaDAO;
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
 * @author H-TECCSI-V
 */
@WebServlet(name = "FuerzaOperativaServlet", urlPatterns = {"/FuerzaOperativa"})
public class FuerzaOperativaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objFuerzaOperativa;
    private BeanFuerzaOperativa objBnFuerzaOperativa;
    private Connection objConnection;
    private FuerzaOperativaDAO objDsFuerzaOperativa;
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
        //VERIFICAMOS LA SESSION DEL USUARIO
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnFuerzaOperativa = new BeanFuerzaOperativa();
        objBnFuerzaOperativa.setMode(request.getParameter("mode"));
        objBnFuerzaOperativa.setPeriodo(request.getParameter("periodo"));
        objBnFuerzaOperativa.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnFuerzaOperativa.setCodigo(request.getParameter("codigo"));
        objBnFuerzaOperativa.setDependencia(request.getParameter("dependencia"));
        objBnFuerzaOperativa.setCodigoDepartamento(request.getParameter("departamento"));
        objBnFuerzaOperativa.setDependenciaDetalle(request.getParameter("codigoDetalle"));
        objDsFuerzaOperativa = new FuerzaOperativaDAOImpl(objConnection);
        objDsCombo = new CombosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.
        if (objBnFuerzaOperativa.getMode().equals("G")) {
            objFuerzaOperativa = objDsFuerzaOperativa.getListaFuerzaOperativa(objBnFuerzaOperativa, objUsuario.getUsuario());
            if (request.getAttribute("objDepartamento") != null) {
                request.removeAttribute("objDepartamento");
            }
            request.setAttribute("objDepartamento", objDsCombo.getDepartamento());
            if (request.getAttribute("objTipoFuerza") != null) {
                request.removeAttribute("objTipoFuerza");
            }
            request.setAttribute("objTipoFuerza", objDsCombo.getTipoFuerzaOperativa(objBnFuerzaOperativa.getPeriodo()));
        }
        if (objBnFuerzaOperativa.getMode().equals("GD")) {
            objFuerzaOperativa = objDsFuerzaOperativa.getListaFuerzaOperativaDetalle(objBnFuerzaOperativa, objUsuario.getUsuario());
            if (request.getAttribute("objTipoFuerza") != null) {
                request.removeAttribute("objTipoFuerza");
            }
            request.setAttribute("objTipoFuerza", objDsCombo.getTipoFuerzaOperativa(objBnFuerzaOperativa.getPeriodo()));
        }
        if (objBnFuerzaOperativa.getMode().equals("U")) {
            objBnFuerzaOperativa = objDsFuerzaOperativa.getFuerzaOperativa(objBnFuerzaOperativa, objUsuario.getUsuario());
            result = objBnFuerzaOperativa.getDependencia() + "+++"
                    + objBnFuerzaOperativa.getCodigoDepartamento() + "+++"
                    + objBnFuerzaOperativa.getComentario();
        }
        if (objBnFuerzaOperativa.getMode().equals("B")) {
            objBnFuerzaOperativa = objDsFuerzaOperativa.getFuerzaOperativaDetalle(objBnFuerzaOperativa, objUsuario.getUsuario());
            result = objBnFuerzaOperativa.getDependencia() + "+++"
                    + objBnFuerzaOperativa.getComentario() + "+++"
                    + objBnFuerzaOperativa.getTipoFuerzaOperativa() + "+++"
                    + objBnFuerzaOperativa.getCantidadOficina();
        }
        if (request.getAttribute("objFuerzaOperativa") != null) {
            request.removeAttribute("objFuerzaOperativa");
        }
        if (request.getAttribute("objBnFuerzaOperativa") != null) {
            request.removeAttribute("objBnFuerzaOperativa");
        }
        request.setAttribute("objFuerzaOperativa", objFuerzaOperativa);
        request.setAttribute("objBnFuerzaOperativa", objBnFuerzaOperativa);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnFuerzaOperativa.getMode()) {
            case "fuerzaOperativa":
                dispatcher = request.getRequestDispatcher("Programacion/FuerzaOperativa.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaFuerzaOperativa.jsp");
                break;
            case "GD":
                dispatcher = request.getRequestDispatcher("Programacion/ListaFuerzaOperativaDetalle.jsp");
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
