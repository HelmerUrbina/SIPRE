/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPersonal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.PersonalDAOImpl;
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
import DataService.Despachadores.PersonalDAO;

/**
 *
 * @author H-TECCSI-V
 */
@WebServlet(name = "IduRegistroFamiliaServlet", urlPatterns = {"/IduRegistroFamilia"})
public class IduRegistroFamiliaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPersonal objBnRegistroFamilia;
    private Connection objConnection;
    private PersonalDAO objDsRegistroFamilia;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        //VERIFICAMOS QUE LA SESSION SEA VALIDA
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnRegistroFamilia = new BeanPersonal();
        objBnRegistroFamilia.setDocumento(request.getParameter("dni"));
        //objBnRegistroFamilia.setDocumentoFamiliar("");
        objBnRegistroFamilia.setTelefono("");
        // objBnRegistroFamilia.setTelefonoFamiliar("");
        objBnRegistroFamilia.setParentesco("");
        //  objBnRegistroFamilia.setNombreFamiliar("");
        //  objBnRegistroFamilia.setApellidoFamiliar("");
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        objDsRegistroFamilia = new PersonalDAOImpl(objConnection);
        objBnRegistroFamilia.setMode("D");
        int k = objDsRegistroFamilia.iduFamilia(objBnRegistroFamilia, objUsuario.getUsuario());

        String lista[][] = Utiles.generaLista(request.getParameter("lista"), 6);
        for (String[] item : lista) {
            objBnRegistroFamilia.setMode("I");
            //      objBnRegistroFamilia.setDocumentoFamiliar(item[0].trim());
            //      objBnRegistroFamilia.setTelefonoFamiliar(item[1]);
            objBnRegistroFamilia.setTelefono(item[2]);
            objBnRegistroFamilia.setParentesco(item[3].trim());
            //       objBnRegistroFamilia.setNombreFamiliar(item[4]);
            //       objBnRegistroFamilia.setApellidoFamiliar(item[5]);
            k = objDsRegistroFamilia.iduFamilia(objBnRegistroFamilia, objUsuario.getUsuario());
        }
        if (k == 0) {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_REGISTRO_FAMILIA");
            objBnMsgerr.setTipo(objBnRegistroFamilia.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            result = objBnMsgerr.getDescripcion();
        }
        // EN CASO DE NO HABER PROBLEMAS RETORNAMOS UNA NUEVA CONSULTA CON TODOS LOS DATOS.
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            if (result == null) {
                out.print("GUARDO");
            } else {
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
