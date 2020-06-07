/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanDerechoPersonal;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.DerechoPersonalDAO;
import DataService.Despachadores.Impl.DerechoPersonalDAOImpl;
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
 * @author H-TECCSI-V
 */
@WebServlet(name = "IduResolucionJADPEServlet", urlPatterns = {"/IduResolucionJADPE"})
public class IduResolucionJADPEServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanDerechoPersonal objBnDerechoPersonal;
    private Connection objConnection;
    private DerechoPersonalDAO objDsDerechoPersonal;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(true);
        String result = null;
        String resulDetalle = null;

        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnDerechoPersonal = new BeanDerechoPersonal();
        objBnDerechoPersonal.setMode(request.getParameter("mode"));
        objBnDerechoPersonal.setPeriodo(request.getParameter("periodo"));
        objBnDerechoPersonal.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnDerechoPersonal.setMes(request.getParameter("mes"));
        objBnDerechoPersonal.setCodigo(request.getParameter("codigo"));
        objBnDerechoPersonal.setCodigoBeneficio(request.getParameter("codigoBeneficio"));
        objBnDerechoPersonal.setCobertura(request.getParameter("pedido"));
        objBnDerechoPersonal.setReferencia(request.getParameter("periodoResolucion"));
        objBnDerechoPersonal.setAsunto(request.getParameter("tipo"));
        objBnDerechoPersonal.setOficio(Utiles.checkNum("0"));
        objBnDerechoPersonal.setResolucion(Utiles.checkNum("0"));
        objDsDerechoPersonal = new DerechoPersonalDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        if (objBnDerechoPersonal.getMode().equals("I")) {            
            String arreglo[][] = Utiles.generaLista(request.getParameter("lista"), 5);
            for (String[] item : arreglo) {                
                objBnDerechoPersonal.setOficio(Utiles.checkNum(item[1].trim()));
                objBnDerechoPersonal.setResolucion(Utiles.checkNum(item[2].trim()));
                objBnDerechoPersonal.setCodigoSubTipo(item[3].trim());
                objBnDerechoPersonal.setCodigoAdministrativo(item[4].trim());
                k = objDsDerechoPersonal.iduRelacionJADPE(objBnDerechoPersonal, objUsuario.getUsuario());
            }
        } else {
            k = objDsDerechoPersonal.iduRelacionJADPE(objBnDerechoPersonal, objUsuario.getUsuario());
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("DERPER");
            objBnMsgerr.setTipo(objBnDerechoPersonal.getMode());
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
