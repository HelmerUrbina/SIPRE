/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;


import BusinessServices.Beans.BeanPersonalPresupuesto;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.PersonalPresupuestoDAOImpl;
import DataService.Despachadores.PersonalPresupuestoDAO;
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
 * @author hateccsiv
 */
@WebServlet(name = "PersonalPresupuestoServlet", urlPatterns = {"/PersonalPresupuesto"})
public class PersonalPresupuestoServlet extends HttpServlet {

        private ServletConfig config = null;
        private ServletContext context = null;
        private HttpSession session = null;
        private RequestDispatcher dispatcher = null;
        private List objPersonalPresupuesto;        
        private BeanPersonalPresupuesto objBnPersonalPresupuesto;
        private Connection objConnection;
        private PersonalPresupuestoDAO objDsPersonalPresupuesto;
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
        objBnPersonalPresupuesto = new BeanPersonalPresupuesto();
        objBnPersonalPresupuesto.setMode(request.getParameter("mode"));
        objBnPersonalPresupuesto.setPeriodo(request.getParameter("periodo"));
        objBnPersonalPresupuesto.setCodConcepto(Utiles.checkNum(request.getParameter("codConcepto")));
        objBnPersonalPresupuesto.setNivelGrado(Utiles.checkNum(request.getParameter("nivelGrado")));
        objBnPersonalPresupuesto.setNivelDescripcion(request.getParameter("nivelDescripcion"));
        objBnPersonalPresupuesto.setCodGrd(request.getParameter("codGrado"));
        objBnPersonalPresupuesto.setCadenaGasto(request.getParameter("cadenaGasto"));
        objBnPersonalPresupuesto.setTarea(request.getParameter("tarea"));
        objBnPersonalPresupuesto.setPeriodoRee(request.getParameter("periodoRee"));
        objBnPersonalPresupuesto.setDepartamento(request.getParameter("departamento"));
        objBnPersonalPresupuesto.setUnidad(request.getParameter("unidad"));
        
        objDsPersonalPresupuesto = new PersonalPresupuestoDAOImpl(objConnection);
        objDsCombo = new CombosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnPersonalPresupuesto.getMode().equals("persPresup")) {
            if (request.getAttribute("objListaConceptos") != null) request.removeAttribute("objListaConceptos");                        
            request.setAttribute("objListaConceptos", objDsCombo.getConceptoRemuneraciones());            
        }        
        if (objBnPersonalPresupuesto.getMode().equals("G")) {
            objPersonalPresupuesto = objDsPersonalPresupuesto.getConsultaPersonalPresupuesto(objBnPersonalPresupuesto, objUsuario.getUsuario());            
        }
        if (objBnPersonalPresupuesto.getMode().equals("GD")) {    
            if(objBnPersonalPresupuesto.getNivelGrado()==9){
                objPersonalPresupuesto = objDsPersonalPresupuesto.getconsultaPersonalPresupDetREE(objBnPersonalPresupuesto, objUsuario.getUsuario());
            }else{
                objPersonalPresupuesto = objDsPersonalPresupuesto.getconsultaPersonalPresupDet(objBnPersonalPresupuesto, objUsuario.getUsuario());            
            }
        }
        if (objBnPersonalPresupuesto.getMode().equals("gradoImp")) {
            result=objDsPersonalPresupuesto.getImporteGrado(objBnPersonalPresupuesto, objUsuario.getUsuario());
        }
        if (objBnPersonalPresupuesto.getMode().equals("reeImp")) {
            result=objDsPersonalPresupuesto.getImporteRee(objBnPersonalPresupuesto, objUsuario.getUsuario());
        }
        if (objBnPersonalPresupuesto.getMode().equals("V")) {
            result=objDsPersonalPresupuesto.getVerificarDatos(objBnPersonalPresupuesto, objUsuario.getUsuario());
        }
        if (objBnPersonalPresupuesto.getMode().equals("B")) {
            result=objDsPersonalPresupuesto.getVerificarDatosRee(objBnPersonalPresupuesto, objUsuario.getUsuario());
        }
        if (request.getAttribute("objPersonalPresupuesto") != null) {
            request.removeAttribute("objPersonalPresupuesto");
        }
        if (request.getAttribute("objPersonalPresupuestoDet") != null) {
            request.removeAttribute("objPersonalPresupuestoDet");
        }
        if (request.getAttribute("objBnPersonalPresupuesto") != null) {
            request.removeAttribute("objBnPersonalPresupuesto");
        }
        
        request.setAttribute("objPersonalPresupuesto", objPersonalPresupuesto);        
        request.setAttribute("objBnPersonalPresupuesto", objBnPersonalPresupuesto);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "persPresup":
                dispatcher = request.getRequestDispatcher("Programacion/PersonalPresupuesto.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaPersonalPresupuesto.jsp");
                break;
            case "GD":
                if(objBnPersonalPresupuesto.getNivelGrado()==9){
                    dispatcher = request.getRequestDispatcher("Programacion/ListaPersonalPresupuestoDetRee.jsp");                
                }else{
                    dispatcher = request.getRequestDispatcher("Programacion/ListaPersonalPresupuestoDet.jsp");                
                }
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
