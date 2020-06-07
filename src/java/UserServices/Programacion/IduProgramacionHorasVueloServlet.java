/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanHoraVuelo;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.HoraVueloDAO;
import DataService.Despachadores.Impl.HoraVueloDAOImpl;
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
@WebServlet(name = "IduProgramacionHorasVueloServlet", urlPatterns = {"/IduProgramacionHorasVuelo"})
public class IduProgramacionHorasVueloServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanHoraVuelo objBnHoraVuelo;
    private Connection objConnection;
    private HoraVueloDAO objDsHoraVuelo;
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
        
        objBnHoraVuelo = new BeanHoraVuelo();
        objDsHoraVuelo = new HoraVueloDAOImpl(objConnection);
        objBnHoraVuelo.setMode(request.getParameter("mode"));
        objBnHoraVuelo.setPeriodo(request.getParameter("periodo"));
        objBnHoraVuelo.setCodigoAeronave(Utiles.checkNum(request.getParameter("codigoAeronave")));
        objBnHoraVuelo.setTipoAeronave(request.getParameter("tipoAeronave"));
        objBnHoraVuelo.setAeronave(request.getParameter("modelo"));
        objBnHoraVuelo.setCodigoProgramacion(Utiles.checkNum(objDsHoraVuelo.getCodigoHoraVueloCNV(objBnHoraVuelo, objUsuario.getUsuario())));
        
        
        int k=0;
       
            String lista[][] = Utiles.generaLista(request.getParameter("lista"), 5);
            // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
            for (String[] item : lista) {       
                objBnHoraVuelo.setPlacaAeronave(item[0].trim());
                objBnHoraVuelo.setTarea(item[1].trim());
                objBnHoraVuelo.setCostoCCFFAA(Utiles.checkDouble(item[2].trim()));
                objBnHoraVuelo.setCantidad(Utiles.checkNum(item[3].trim()));
                objBnHoraVuelo.setCostoEntidades(Utiles.checkDouble(item[4].trim()));                
                k = objDsHoraVuelo.iduHoraVueloCNV(objBnHoraVuelo, objUsuario.getUsuario());
                
                if (k == 0) {
                    objBnMsgerr = new BeanMsgerr();
                    objBnMsgerr.setUsuario(objUsuario.getUsuario());
                    objBnMsgerr.setTabla("SIPE_PROG_COSTEO_AERONAVE");
                    objBnMsgerr.setTipo(objBnHoraVuelo.getMode());
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
