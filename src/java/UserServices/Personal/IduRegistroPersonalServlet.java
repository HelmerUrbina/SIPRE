/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanRegistroPersonal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.RegistroPersonalDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.RegistroPersonalDAO;
import Utiles.Utiles;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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
 * @author H-TECCSI-V
 */
@WebServlet(name = "IduRegistroPersonalServlet", urlPatterns = {"/IduRegistroPersonal"})
@MultipartConfig
public class IduRegistroPersonalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanRegistroPersonal objBnRegistroPersonal;
    private Connection objConnection;
    private RegistroPersonalDAO objDsRegistroPersonal;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;
    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(true);
        String result = null;
        int k = 0;
        String resulDetalle = null;
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha        
        java.util.Date fecha_nac = sdf.parse(request.getParameter("fecNacimiento"));
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnRegistroPersonal = new BeanRegistroPersonal();
        objBnRegistroPersonal.setMode(request.getParameter("mode"));
        objBnRegistroPersonal.setDni(request.getParameter("dni"));
        objBnRegistroPersonal.setNombresPersonal(request.getParameter("nombres"));
        objBnRegistroPersonal.setApellidosPersonal(request.getParameter("apellidos"));
        objBnRegistroPersonal.setFechaNacimiento(new java.sql.Date(fecha_nac.getTime()));
        objBnRegistroPersonal.setDireccion(request.getParameter("direccion"));
        objBnRegistroPersonal.setTelefono(request.getParameter("celular"));
        objBnRegistroPersonal.setAreaLaboral(request.getParameter("area"));
        objBnRegistroPersonal.setCargo(request.getParameter("cargo"));
        objBnRegistroPersonal.setGrado(request.getParameter("grado"));
        objDsRegistroPersonal = new RegistroPersonalDAOImpl(objConnection);
        if (objBnRegistroPersonal.getMode().equals("I") || objBnRegistroPersonal.getMode().equals("U")) {
            response.setContentType("text/html;charset=UTF-8");
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if (null != Utiles.getFileName(part)) {
                    String path = request.getServletContext().getRealPath("");
                    /*if (path.contains("\\")) {
                        path = path.replaceAll("\\\\", "/");
                    }*/
                    //Me quedo con la ruta del proyecto, quitando la parte de build/web y accediendo a web/Imagenes/Usuarios
                    path = path.replaceAll("build/web", "") + "web/Imagenes/Usuarios";
                    //path = "F:\\Apache Tomcat\\webapps\\SIPRE\\web\\Imagenes\\Usuarios";
                    objBnRegistroPersonal.setFoto(Utiles.getFileName(part));
                    part.write(path + "/" + objBnRegistroPersonal.getDni() + "-" + objBnRegistroPersonal.getFoto());
                }
            }
        }
        k = objDsRegistroPersonal.iduRegistroPersonal(objBnRegistroPersonal, objUsuario.getUsuario());
        if (k == 0) {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_REGISTRO_PERSONAL");
            objBnMsgerr.setTipo(objBnRegistroPersonal.getMode());
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(IduRegistroPersonalServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduRegistroPersonalServlet.class.getName()).log(Level.SEVERE, null, ex);
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
