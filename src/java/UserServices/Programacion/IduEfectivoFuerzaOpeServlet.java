/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanFuerzaOperativa;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.FuerzaOperativaDAO;
import DataService.Despachadores.Impl.FuerzaOperativaDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MsgerrDAO;
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
@WebServlet(name = "IduEfectivoFuerzaOpeServlet", urlPatterns = {"/IduEfectivoFuerzaOpe"})
public class IduEfectivoFuerzaOpeServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanFuerzaOperativa objBnFuerzaOperativa;
    private Connection objConnection;
    private FuerzaOperativaDAO objDsFuerzaOperativa;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        String result = null;
        String resulDetalle = null;
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
        objBnFuerzaOperativa.setUnidadOperativa(request.getParameter("unidad"));
        objBnFuerzaOperativa.setDependencia(request.getParameter("dependencia"));
        objBnFuerzaOperativa.setCodigo(request.getParameter("codFuerza"));
        
        objDsFuerzaOperativa = new FuerzaOperativaDAOImpl(objConnection);
        
        String lista[][]=null;
        lista=Utiles.generaLista(request.getParameter("lista"), 3);
        
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO        
        int k=0;
        for (String[] item : lista) {    
                            
            objBnFuerzaOperativa.setCodigoDepartamento(item[0]);    
            objBnFuerzaOperativa.setPeriodoREE(item[1]);                         
            objBnFuerzaOperativa.setCantidadOficina(Utiles.checkNum(item[2]));             
                     
            k = objDsFuerzaOperativa.iduEfectivoFuerzaOpe(objBnFuerzaOperativa, objUsuario.getUsuario());
        }
        
        if (k == 0) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_EFECTIVO_FUER_OPERATIVA");
            objBnMsgerr.setTipo(objBnFuerzaOperativa.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            resulDetalle = objBnMsgerr.getDescripcion();
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_EFECTIVO_FUER_OPERATIVA");
            objBnMsgerr.setTipo(objBnFuerzaOperativa.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            resulDetalle = objBnMsgerr.getDescripcion();
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
                out.print(resulDetalle);
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
