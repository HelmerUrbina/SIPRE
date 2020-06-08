/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.MesaPartes;

import BusinessServices.Beans.BeanMesaParte;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.Impl.MesaParteDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MesaParteDAO;
import DataService.Despachadores.MsgerrDAO;
import Utiles.JavaMail;
import Utiles.Utiles;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author H-URBINA-M
 */
@WebServlet(name = "RegistrarMesaPartesServlet", urlPatterns = {"/RegistrarMesaPartes"})
@MultipartConfig(location = "D:/SIPRE/DOCUMENTOS/MesaParte")
public class RegistrarMesaPartesServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private BeanMesaParte objBnMesaParte;
    private Connection objConnection;
    private MesaParteDAO objDsMesaParte;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;
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
        response.setContentType("text/html;charset=UTF-8");
        String result = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha
        java.util.Date fecha_doc = sdf.parse(request.getParameter("fechaDocumento"));
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        sdf1.setLenient(false); //No Complaciente en Fecha
        java.util.Date fecha_rec = sdf1.parse(request.getParameter("fechaRecepcion"));
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnMesaParte = new BeanMesaParte();
        objBnMesaParte.setMode("I");
        objBnMesaParte.setPeriodo(request.getParameter("periodo"));
        objBnMesaParte.setTipo(request.getParameter("tipo"));
        objBnMesaParte.setNumero("0");
        objBnMesaParte.setMes(request.getParameter("mes"));
        objBnMesaParte.setGrupo("01");
        objBnMesaParte.setSubGrupo(request.getParameter("institucion"));
        objBnMesaParte.setPrioridad(request.getParameter("prioridad"));
        objBnMesaParte.setTipoDocumento(request.getParameter("tipoDocumento"));
        objBnMesaParte.setNumeroDocumento(request.getParameter("numeroDocumento"));
        objBnMesaParte.setClasificacion(request.getParameter("clasificacion"));
        objBnMesaParte.setFecha(new java.sql.Date(fecha_doc.getTime()));
        objBnMesaParte.setFechaRecepcion(new java.sql.Date(fecha_rec.getTime()));
        objBnMesaParte.setAsunto(request.getParameter("asunto"));
        objBnMesaParte.setObservacion(request.getParameter("observacion"));
        objBnMesaParte.setUsuario(request.getParameter("firma"));
        objBnMesaParte.setLegajo(Utiles.checkNum(request.getParameter("legajos")));
        objBnMesaParte.setFolio(Utiles.checkNum(request.getParameter("folios")));
        objBnMesaParte.setArea(request.getParameter("area"));
        objBnMesaParte.setUsuarioResponsable(request.getParameter("usuario"));
        objBnMesaParte.setReferencia(request.getParameter("referencia"));
        objBnMesaParte.setCorreo(request.getParameter("correo"));
        objDsMesaParte = new MesaParteDAOImpl(objConnection);
        Collection<Part> parts = request.getParts();
        for (Part part : parts) {
            if (null != Utiles.getFileName(part)) {
                objBnMesaParte.setArchivo(Utiles.getFileName(part));
                part.write(objBnMesaParte.getPeriodo() + "-" + objBnMesaParte.getTipo() + "-" + objBnMesaParte.getNumero() + "-" + objBnMesaParte.getArchivo());
            }
        }
        objBnMesaParte.setNumero(objDsMesaParte.iduMesaParte(objBnMesaParte, "0000"));
        if (objBnMesaParte.getNumero().equals("0")) {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario("0000");
            objBnMsgerr.setTabla("SIPE_DOCUMENTO");
            objBnMsgerr.setTipo(objBnMesaParte.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            result = objBnMsgerr.getDescripcion();
        }
        // EN CASO DE NO HABER PROBLEMAS RETORNAMOS UNA NUEVA CONSULTA CON TODOS LOS DATOS.
        if (result == null) {
            try (PrintWriter out = response.getWriter()) {
                JavaMail mail = new JavaMail(objBnMesaParte, request, objConnection);
                mail.SendMail();
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
            Logger.getLogger(RegistrarMesaPartesServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(RegistrarMesaPartesServlet.class.getName()).log(Level.SEVERE, null, ex);
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
