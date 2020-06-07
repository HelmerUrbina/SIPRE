/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Configuracion;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.UsuarioDAO;
import DataService.Despachadores.Impl.UsuarioDAOImpl;
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
 * @author H-URBINA-M
 */
@WebServlet(name = "IduUsuarioServlet", urlPatterns = {"/IduUsuario"})
public class IduUsuarioServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanUsuario objBnUsuario;
    private Connection objConnection;
    private UsuarioDAO objDsUsuario;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;

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
        if (objUsuario == null && !request.getParameter("mode").equals("I")) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnUsuario = new BeanUsuario();
        objBnUsuario.setMode(request.getParameter("mode"));
        objBnUsuario.setUsuario(request.getParameter("usuario"));
        objBnUsuario.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnUsuario.setApellido(request.getParameter("apellidos"));
        objBnUsuario.setNombre(request.getParameter("nombres"));
        objBnUsuario.setPassword(request.getParameter("password"));
        objBnUsuario.setAreaLaboral(request.getParameter("areaLaboral"));
        objBnUsuario.setIniciales(request.getParameter("iniciales"));
        objBnUsuario.setOpre(request.getParameter("opre"));
        objBnUsuario.setActa(request.getParameter("acta"));
        objBnUsuario.setEstado(request.getParameter("estado"));
        String registra = "";
        if (objBnUsuario.getMode().equals("I")) {
            registra = objBnUsuario.getUsuario();
        } else {
            registra = objUsuario.getUsuario();
        }
        objDsUsuario = new UsuarioDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO        
        int k = 0;
        if (objBnUsuario.getMode().equals("O")) {
            objBnUsuario.setMode("D");
            k = objDsUsuario.iduOpciones(objBnUsuario, objUsuario.getUsuario());
            String lista[][] = Utiles.generaLista(request.getParameter("lista"), 1);
            for (String[] item : lista) {
                if (item[0].trim().length() == 4) {
                    objBnUsuario.setMode("I");
                    objBnUsuario.setModulo(item[0].trim().substring(0, 2));
                    objBnUsuario.setMenu(item[0].trim().substring(2, 4));
                    k = objDsUsuario.iduOpciones(objBnUsuario, objUsuario.getUsuario());
                }
            }
        } else {
            k = objDsUsuario.iduUsuario(objBnUsuario, registra);
        }
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(registra);
            objBnMsgerr.setTabla("TABUSU");
            objBnMsgerr.setTipo(objBnUsuario.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            result = objBnMsgerr.getDescripcion();
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
