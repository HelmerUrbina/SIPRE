/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;



import BusinessServices.Beans.BeanIngresosPorGrado;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.ConceptoIngresosDAOImpl;
import DataService.Despachadores.ConceptoIngresosDAO;
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
 * @author H-TECCSI-V
 */

@WebServlet(name = "ConceptoIngresosServlet", urlPatterns = {"/ConceptoIngresos"})
public class ConceptoIngresosServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objIngresosPorGrado;
    private BeanIngresosPorGrado objBnIngresosPorGrado;
    private Connection objConnection;
    private ConceptoIngresosDAO objDsIngresosPorGrado;
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
        objBnIngresosPorGrado = new BeanIngresosPorGrado();
        objBnIngresosPorGrado.setMode(request.getParameter("mode"));        
        objBnIngresosPorGrado.setPeriodo(request.getParameter("periodo"));
        objBnIngresosPorGrado.setCodConcepto(Utiles.checkNum(request.getParameter("codConcepto"))); 
        objDsIngresosPorGrado = new ConceptoIngresosDAOImpl(objConnection);
        objDsCombo = new CombosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnIngresosPorGrado.getMode().equals("concepIngresos")) {
            if (request.getAttribute("objListaConceptos") != null) request.removeAttribute("objListaConceptos");                  
            request.setAttribute("objListaConceptos", objDsCombo.getConceptoRemuneraciones());           
        }
        if (objBnIngresosPorGrado.getMode().equals("G")) {
            objIngresosPorGrado = objDsIngresosPorGrado.getConsultaConceptoIngreso(objBnIngresosPorGrado, objUsuario.getUsuario());           
        }
        
        if (request.getAttribute("objBnIngresosPorGrado") != null) {
            request.removeAttribute("objBnIngresosPorGrado");
        }
        if (request.getAttribute("objIngresosPorGrado") != null) {
            request.removeAttribute("objIngresosPorGrado");
        }
        request.setAttribute("objBnIngresosPorGrado", objBnIngresosPorGrado);
        request.setAttribute("objIngresosPorGrado", objIngresosPorGrado);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "concepIngresos":
                dispatcher = request.getRequestDispatcher("Programacion/ConceptoIngresos.jsp");
                break;
            case "G":                
                dispatcher = request.getRequestDispatcher("Programacion/ListaConceptoIngresos.jsp");                
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
