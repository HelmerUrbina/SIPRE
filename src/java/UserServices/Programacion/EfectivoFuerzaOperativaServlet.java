/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;


import BusinessServices.Beans.BeanFuerzaOperativa;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.FuerzaOperativaDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.FuerzaOperativaDAOImpl;
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
 * @author hateccsiv
 */
@WebServlet(name = "EfectivoFuerzaOperativaServlet", urlPatterns = {"/EfectivoFuerzaOperativa"})
public class EfectivoFuerzaOperativaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objEfectivoFuerzaOpe;
    private BeanFuerzaOperativa objBnFuerzaOperativa;
    private Connection objConnection;
    private FuerzaOperativaDAO objDsFuerzaOperativa;
    private CombosDAO objDsCombo;
    
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
        objBnFuerzaOperativa = new BeanFuerzaOperativa();
        objBnFuerzaOperativa.setMode(request.getParameter("mode"));        
        objBnFuerzaOperativa.setPeriodo(request.getParameter("periodo"));
        objBnFuerzaOperativa.setCodigo(request.getParameter("codFuerza")); 
        objBnFuerzaOperativa.setUnidadOperativa(request.getParameter("unidadOperativa")); 
        objBnFuerzaOperativa.setComentario(request.getParameter("tipoFuerza")); 
        objBnFuerzaOperativa.setDependencia(request.getParameter("dependencia")); 
        objBnFuerzaOperativa.setCodigoDepartamento(request.getParameter("codigo"));
        objBnFuerzaOperativa.setDependenciaDetalle(request.getParameter("departamento"));
        objBnFuerzaOperativa.setNombreDependencia(request.getParameter("unidad"));
        objBnFuerzaOperativa.setDesactivacion(request.getParameter("nomUnidad"));
        
        objDsFuerzaOperativa = new FuerzaOperativaDAOImpl(objConnection);
        objDsCombo = new CombosDAOImpl(objConnection);
        
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.          
        if(objBnFuerzaOperativa.getMode().equals("efectivoFuerza")){
            if (request.getAttribute("objListaNivelGrado") != null) request.removeAttribute("objListaNivelGrado"); 
            request.setAttribute("objListaNivelGrado", objDsCombo.getNivelGrado());
        }
        if (objBnFuerzaOperativa.getMode().equals("G")) {
            objEfectivoFuerzaOpe = objDsFuerzaOperativa.getListaEfectivoFuerOperativa(objBnFuerzaOperativa, objUsuario.getUsuario());           
        }
        
        if (request.getAttribute("objBnFuerzaOperativa") != null) {
            request.removeAttribute("objBnFuerzaOperativa");
        }
        if (request.getAttribute("objEfectivoFuerzaOpe") != null) {
            request.removeAttribute("objEfectivoFuerzaOpe");
        }
        request.setAttribute("objBnFuerzaOperativa", objBnFuerzaOperativa);
        request.setAttribute("objEfectivoFuerzaOpe", objEfectivoFuerzaOpe);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {            
            
            case "G":                
                dispatcher = request.getRequestDispatcher("Programacion/ListaEfectivoFuerzaOpe.jsp");                
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
