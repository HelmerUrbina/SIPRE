/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Consultas;

import BusinessServices.Beans.BeanFirmaElectronica;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.FirmaElectronicaDAO;
import DataService.Despachadores.Impl.FirmaElectronicaDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MsgerrDAO;
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
 * @author H-URBINA-M
 */
@WebServlet(name = "IduFirmasServlet", urlPatterns = {"/IduFirmas"})
@MultipartConfig(location = "D:/SIPRE/DOCUMENTOS/Firmas")
public class IduFirmasServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanFirmaElectronica objBnFirma;
    private Connection objConnection;
    private FirmaElectronicaDAO objDsFirma;
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
     * @throws java.text.ParseException
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        response.setContentType("text/html;charset=UTF-8");
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha
        java.util.Date fechaInicio = sdf.parse(Utiles.checkFecha(request.getParameter("inicio")));
        java.util.Date fechaFin = sdf.parse(Utiles.checkFecha(request.getParameter("fin")));
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnFirma = new BeanFirmaElectronica();
        objBnFirma.setMode(request.getParameter("mode"));
        objBnFirma.setPeriodo(request.getParameter("periodo"));
        objBnFirma.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnFirma.setCodigo(request.getParameter("codigo"));
        objBnFirma.setNivel(Utiles.checkNum(request.getParameter("nivel")));
        objBnFirma.setDocumento(request.getParameter("responsable"));
        objBnFirma.setOpcion(request.getParameter("cargo"));
        objBnFirma.setConcepto(request.getParameter("grado"));
        objBnFirma.setInicio(new java.sql.Date(fechaInicio.getTime()));
        objBnFirma.setFin(new java.sql.Date(fechaFin.getTime()));
        objBnFirma.setEstado(request.getParameter("estado"));
        objDsFirma = new FirmaElectronicaDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        switch (request.getParameter("mode")) {
            case "A":
                k = objDsFirma.iduFirma(objBnFirma, objUsuario.getUsuario());
                break;
            case "D":
                k = objDsFirma.iduFirma(objBnFirma, objUsuario.getUsuario());
                break;
            default:
                response.setContentType("text/html;charset=UTF-8");
                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if (null != Utiles.getFileName(part)) {
                        objBnFirma.setArchivo(Utiles.getFileName(part));
                        part.write(objBnFirma.getPeriodo() + "-" + objBnFirma.getUnidadOperativa() + "-" + objBnFirma.getCodigo() + "-" + objBnFirma.getArchivo());
                    }
                }
                k = objDsFirma.iduFirma(objBnFirma, objUsuario.getUsuario());
        }
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_FIRMA");
            objBnMsgerr.setTipo(objBnFirma.getMode());
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(IduFirmasServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduFirmasServlet.class.getName()).log(Level.SEVERE, null, ex);
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
