/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.MesaPartes;

import BusinessServices.Beans.BeanMesaParte;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MesaParteDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MesaParteDAO;
import DataService.Despachadores.MsgerrDAO;
import Utiles.Utiles;
import java.awt.print.PrinterException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
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
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;

/**
 *
 * @author H-TECCSI-V
 */
@WebServlet(name = "IduMesaParteServlet", urlPatterns = {"/IduMesaParte"})
@MultipartConfig(location = "D:/SIPRE/DOCUMENTOS/MesaParte",
        fileSizeThreshold = 1024 * 1024 * 10,       // 10 MB 
        maxFileSize = 1024 * 1024 * 500,            // 500 MB
        maxRequestSize = 1024 * 1024 * 1000)        // 1000 MB
public class IduMesaParteServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanMesaParte objBnMesaParte;
    private Connection objConnection;
    private MesaParteDAO objDsMesaParte;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;
    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException, PrinterException, JRException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(true);
        response.setContentType("text/html;charset=UTF-8");
        String result = null;
        String k = "";
        String resulDetalle = null;
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("../FinSession.jsp");
            dispatcher.forward(request, response);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha        
        java.util.Date fecha_doc = sdf.parse(request.getParameter("fechaDocumento"));
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        sdf1.setLenient(false); //No Complaciente en Fecha        
        java.util.Date fecha_rec = sdf1.parse(request.getParameter("fechaRecepcion"));
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnMesaParte = new BeanMesaParte();
        objBnMesaParte.setMode(request.getParameter("mode"));
        objBnMesaParte.setPeriodo(request.getParameter("periodo"));
        objBnMesaParte.setTipo(request.getParameter("tipo"));
        objBnMesaParte.setNumero(request.getParameter("numero"));
        objBnMesaParte.setMes(request.getParameter("mes"));
        objBnMesaParte.setGrupo("01");
        objBnMesaParte.setSubGrupo(request.getParameter("codInstitucion"));
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
        objDsMesaParte = new MesaParteDAOImpl(objConnection);
        if (objBnMesaParte.getTipo().equals("E") && !objBnMesaParte.getMode().equals("D")) {
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if (null != Utiles.getFileName(part)) {
                    objBnMesaParte.setArchivo(Utiles.getFileName(part));
                    part.write(objBnMesaParte.getPeriodo() + "-" + objBnMesaParte.getTipo() + "-" + objBnMesaParte.getNumero() + "-" + objBnMesaParte.getArchivo());
                }
            }
        } else {
            if (objBnMesaParte.getMode().equals("C") || objBnMesaParte.getTipo().equals("S")) {
                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if (null != Utiles.getFileName(part)) {
                        objBnMesaParte.setArchivo(Utiles.getFileName(part));
                        part.write(objBnMesaParte.getPeriodo() + "-" + objBnMesaParte.getTipo() + "-" + objBnMesaParte.getNumero() + "-" + objBnMesaParte.getArchivo());
                    }
                }
            }
        }
        k = objDsMesaParte.iduMesaParte(objBnMesaParte, objUsuario.getUsuario());
        if (k.equals("0")) {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_DOCUMENTOS");
            objBnMsgerr.setTipo(objBnMesaParte.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            resulDetalle = objBnMsgerr.getDescripcion();
        }
        // EN CASO DE NO HABER PROBLEMAS RETORNAMOS UNA NUEVA CONSULTA CON TODOS LOS DATOS.
        if (result == null) {
            try (PrintWriter out = response.getWriter()) {
                out.print("GUARDO");
                if (objBnMesaParte.getMode().equals("I")) {
                    InputStream stream = context.getResourceAsStream("/Reportes/MesaParte/MPA0003.jasper");
                    Map parametro = new HashMap();
                    parametro.put("REPORT_LOCALE", new Locale("en", "US"));
                    parametro.put("PERIODO", objBnMesaParte.getPeriodo());
                    parametro.put("CODIGO", objBnMesaParte.getNumero());
                    parametro.put("TIPO", objBnMesaParte.getTipo());
                    parametro.put("USUARIO", objUsuario.getUsuario());
                    parametro.put("SUBREPORT_DIR", "D:\\SIPRE\\Reportes");
                    JasperPrint reporte = JasperFillManager.fillReport(stream, parametro, objConnection);
                    Utiles u = new Utiles();
                    u.printTicket(reporte);
                }
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
            Logger.getLogger(IduMesaParteServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (PrinterException ex) {
            Logger.getLogger(IduMesaParteServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JRException ex) {
            Logger.getLogger(IduMesaParteServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduMesaParteServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (PrinterException ex) {
            Logger.getLogger(IduMesaParteServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JRException ex) {
            Logger.getLogger(IduMesaParteServlet.class.getName()).log(Level.SEVERE, null, ex);
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
