/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPersonalPresupuesto;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.PersonalPresupuestoDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PersonalPresupuestoDAO;
import Utiles.Utiles;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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
@WebServlet(name = "IduPersonalPresupuestoServlet", urlPatterns = {"/IduPersonalPresupuesto"})
public class IduPersonalPresupuestoServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPersonalPresupuesto objBnPersonalPresupuesto;
    private Connection objConnection;
    private PersonalPresupuestoDAO objDsPersonalPresupuesto;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;
    
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
        objBnPersonalPresupuesto.setCadenaGasto(request.getParameter("cadenaGasto"));
        objBnPersonalPresupuesto.setTarea(request.getParameter("tarea"));
        objBnPersonalPresupuesto.setNivelGrado(Utiles.checkNum(request.getParameter("nivelGrado")));
        objBnPersonalPresupuesto.setCodGrd(request.getParameter("codGrd"));
        objBnPersonalPresupuesto.setPeriodoRee(request.getParameter("periodoRee"));
                
        objDsPersonalPresupuesto = new PersonalPresupuestoDAOImpl(objConnection);
        
        int k=0;
        if(objBnPersonalPresupuesto.getMode().equals("I")){
            String lista[][] = Utiles.generaLista(request.getParameter("lista"), 7);
            // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
            for (String[] item : lista) {       
                objBnPersonalPresupuesto.setDepartamento(item[0].trim());
                objBnPersonalPresupuesto.setUnidad(item[1].trim());
                objBnPersonalPresupuesto.setNivelGrado(Utiles.checkNum(item[2].trim()));
                objBnPersonalPresupuesto.setCodGrd(item[3].trim());
                objBnPersonalPresupuesto.setPeriodoRee(item[4]);
                objBnPersonalPresupuesto.setCantidad(Utiles.checkNum(item[5]));
                objBnPersonalPresupuesto.setImporte(Utiles.checkDouble(item[6]));            
                k = objDsPersonalPresupuesto.iduPersonalPresupuesto(objBnPersonalPresupuesto, objUsuario.getUsuario());
                
                if (k == 0) {
                    objBnMsgerr = new BeanMsgerr();
                    objBnMsgerr.setUsuario(objUsuario.getUsuario());
                    objBnMsgerr.setTabla("SIPE_PERSONAL_PRESUP_PRG");
                    objBnMsgerr.setTipo(objBnPersonalPresupuesto.getMode());
                    objDsMsgerr = new MsgerrDAOImpl(objConnection);
                    objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
                    result = objBnMsgerr.getDescripcion();
                } 
            }
            
        }else{
            k = objDsPersonalPresupuesto.iduPersonalPresupuesto(objBnPersonalPresupuesto, objUsuario.getUsuario());
            if (k == 0) {
                objBnMsgerr = new BeanMsgerr();
                objBnMsgerr.setUsuario(objUsuario.getUsuario());
                objBnMsgerr.setTabla("SIPE_PERSONAL_PRESUP_PRG");
                objBnMsgerr.setTipo(objBnPersonalPresupuesto.getMode());
                objDsMsgerr = new MsgerrDAOImpl(objConnection);
                objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
                result = objBnMsgerr.getDescripcion();
            }           
        }
       
        // EN CASO DE NO HABER PROBLEMAS RETORNAMOS UNA NUEVA CONSULTA CON TODOS LOS DATOS.
        response.setContentType("text/html;charset=UTF-8");
        if (result == null) {
            try (PrintWriter out = response.getWriter()) {
                out.print("GUARDO");
            }
        } else {
            //PROCEDEMOS A ELIMINAR TODO;
            try (PrintWriter out = response.getWriter()) {
                out.print(result);
            }
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
