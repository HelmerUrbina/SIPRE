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
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import DataService.Despachadores.PersonalDAO;
import java.io.InputStream;

/**
 *
 * @author H-TECCSI-V
 */
@WebServlet(name = "IduRegistroServlet", urlPatterns = {"/IduPersonal"})
@MultipartConfig(maxFileSize = 16177215, location = "D:/SIPRE/PERSONAL/Foto")
public class IduPersonalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPersonal objBnPersonal;
    private Connection objConnection;
    private PersonalDAO objDsRegistroPersonal;
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
        java.util.Date fecha_nac = sdf.parse(Utiles.checkFecha(request.getParameter("fechaNacimiento")));
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnPersonal = new BeanPersonal();
        objBnPersonal.setMode(request.getParameter("mode"));
        objBnPersonal.setPersonal(Utiles.checkNum(request.getParameter("personal")));
        objBnPersonal.setTipoDocumento(request.getParameter("tipoDocumento"));
        objBnPersonal.setDocumento(request.getParameter("documento"));
        objBnPersonal.setPaterno(request.getParameter("paterno"));
        objBnPersonal.setMaterno(request.getParameter("materno"));
        objBnPersonal.setNombres(request.getParameter("nombres"));
        objBnPersonal.setFechaNacimiento(new java.sql.Date(fecha_nac.getTime()));
        objBnPersonal.setSexo(request.getParameter("sexo"));
        objBnPersonal.setTelefono(request.getParameter("celular"));
        objBnPersonal.setDireccion(request.getParameter("direccion"));
        objBnPersonal.setCorreo(request.getParameter("email"));
        objBnPersonal.setGrado(request.getParameter("grado"));
        objBnPersonal.setCIP(request.getParameter("cip"));
        objBnPersonal.setAreaLaboral(request.getParameter("area"));
        objBnPersonal.setCargo(request.getParameter("cargo"));
        objDsRegistroPersonal = new PersonalDAOImpl(objConnection);
        if (objBnPersonal.getMode().equals("I") || objBnPersonal.getMode().equals("U")) {
            response.setContentType("text/html;charset=UTF-8");
            try {
                Part filePart = request.getPart("txt_Foto");
                if (filePart.getSize() > 0) {
                    objBnPersonal.setFoto(Utiles.getFileName(filePart));
                    String n = String.valueOf(filePart.getContentType());
                    objBnPersonal.setImage(filePart.getInputStream());
                    filePart.write(objBnPersonal.getDocumento() + "-" + objBnPersonal.getFoto());
                }
                if (filePart.getSize() == 0 && objBnPersonal.getMode().equals("I")) {
                    objBnPersonal.setFoto("usuario.jpg");
                    InputStream stream = context.getResourceAsStream("/Imagenes/Fondos/usuario.jpg");
                    objBnPersonal.setImage(stream);
                }
            } catch (IOException e) {
                System.out.println("ERROR EN IMAGEN" + e.getMessage());
            }
        }
        k = objDsRegistroPersonal.iduPersonal(objBnPersonal, objUsuario.getUsuario());
        if (k == 0) {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPRE_PERSONAL");
            objBnMsgerr.setTipo(objBnPersonal.getMode());
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
            Logger.getLogger(IduPersonalServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduPersonalServlet.class.getName()).log(Level.SEVERE, null, ex);
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
