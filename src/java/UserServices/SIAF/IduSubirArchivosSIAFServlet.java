/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.SIAF;

import BusinessServices.Beans.BeanArchivosSIAF;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.ArchivosSIAFDAO;
import DataService.Despachadores.Impl.ArchivosSIAFDAOImpl;
import Utiles.LeerArchivosSIAF;
import Utiles.Utiles;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author H-URBINA-M
 */
@WebServlet(name = "IduSubirArchivosSIAFServlet", urlPatterns = {"/IduSubirArchivosSIAF"})
@MultipartConfig(location = "D:/SIPRE/SIAF/ArchivosSIAF")
public class IduSubirArchivosSIAFServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private Connection objConnection;
    private BeanArchivosSIAF archivosSIAF;
    private ArchivosSIAFDAO objDsArchivos;
    private static final long serialVersionUID = 1L;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * @throws java.text.ParseException
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(true);
        response.setContentType("text/html;charset=UTF-8");
        String result = null;
        int k = 0;
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        java.util.Date fechaSistema = new java.util.Date();
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        archivosSIAF = new BeanArchivosSIAF();
        archivosSIAF.setMode("D");
        archivosSIAF.setPeriodo(request.getParameter("periodo"));
        archivosSIAF.setTipoCambio(0.0);
        archivosSIAF.setMonto(0.0);
        archivosSIAF.setMontoNacional(0.0);
        archivosSIAF.setPIM(0.0);
        archivosSIAF.setEjecucion(0.0);
        archivosSIAF.setSaldo(0.0);
        archivosSIAF.setEnero(0.0);
        archivosSIAF.setFebrero(0.0);
        archivosSIAF.setMarzo(0.0);
        archivosSIAF.setAbril(0.0);
        archivosSIAF.setMayo(0.0);
        archivosSIAF.setJunio(0.0);
        archivosSIAF.setJulio(0.0);
        archivosSIAF.setAgosto(0.0);
        archivosSIAF.setSetiembre(0.0);
        archivosSIAF.setOctubre(0.0);
        archivosSIAF.setNoviembre(0.0);
        archivosSIAF.setDiciembre(0.0);
        objDsArchivos = new ArchivosSIAFDAOImpl(objConnection);
        Collection<Part> parts = request.getParts();
        for (Part part : parts) {
            if (null != Utiles.getFileName(part)) {
                String archivo = part.getName().replace("txt_", "") + "-" + df.format(fechaSistema) + "-" + Utiles.getFileName(part);
                part.write(archivo);
                if (part.getName().equals("txt_Marco")) {
                    k = objDsArchivos.iduMarcoPresupuestal(archivosSIAF, objUsuario.getUsuario());
                    result = LeerArchivosSIAF.subirMarcoPresupuestal(new File(archivo), objConnection, objUsuario.getUsuario());
                }
                if (part.getName().equals("txt_Certificado")) {
                    k = objDsArchivos.iduCertificadoSIAF(archivosSIAF, objUsuario.getUsuario());
                    result = LeerArchivosSIAF.subirCertificadoSIAF(new File(archivo), objConnection, objUsuario.getUsuario());
                }
                if (part.getName().equals("txt_Priorizacion")) {
                    k = objDsArchivos.iduPriorizacionSIAF(archivosSIAF, objUsuario.getUsuario());
                    result = LeerArchivosSIAF.subirPriorizacionSIAF(new File(archivo), objConnection, objUsuario.getUsuario());
                }
                //if (part.getName().equals("txt_NotaModificatoria")) {
                //  k = objDsArchivos.iduNotasModificatoriasSIAF(archivosSIAF, objUsuario.getUsuario());
                //result = LeerArchivosSIAF.subirNotasModificatoriasSIAF(new File(archivo), objConnection, objUsuario.getUsuario());
                // }
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
        try {
            processRequest(request, response);

        } catch (ParseException ex) {
            Logger.getLogger(IduSubirArchivosSIAFServlet.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);

        } catch (ParseException ex) {
            Logger.getLogger(IduSubirArchivosSIAFServlet.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
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
