/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanPIMInforme;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.ConsultaEjecucionDAO;
import DataService.Despachadores.Impl.ConsultaEjecucionDAOImpl;
import Utiles.ExportarExcel;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;
import javax.activation.MimetypesFileTypeMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author H-URBINA-M
 */
@WebServlet(name = "ConsultaEjecucionServlet", urlPatterns = {"/ConsultaEjecucion"})
public class ConsultaEjecucionServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objConsultaEjecucion;
    private BeanPIMInforme objBnEjecucion;
    private Connection objConnection;
    private ConsultaEjecucionDAO objDsEjecucion;

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
        String result = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnEjecucion = new BeanPIMInforme();
        objBnEjecucion.setMode(request.getParameter("mode"));
        objBnEjecucion.setPeriodo(request.getParameter("periodo"));
        objBnEjecucion.setPresupuesto(request.getParameter("presupuesto"));
        objBnEjecucion.setCategoriaPresupuestal(request.getParameter("categoriaPresupuestal"));
        objBnEjecucion.setProducto(request.getParameter("producto"));
        objBnEjecucion.setTipoClasificador(request.getParameter("pip"));
        objDsEjecucion = new ConsultaEjecucionDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.
        if (objBnEjecucion.getMode().equals("G")) {
            objConsultaEjecucion = objDsEjecucion.getListaConsultaEjecucion(objBnEjecucion, objUsuario.getUsuario());
        }
        if (objBnEjecucion.getMode().equals("E")) {
            int nombreArchivo = (int) Math.floor(Math.random() * 100000000);
            objConsultaEjecucion = objDsEjecucion.getListaConsultaEjecucion(objBnEjecucion, objUsuario.getUsuario());
            ExportarExcel export = new ExportarExcel();
            export.ConsultaEjecucion("" + nombreArchivo, objConsultaEjecucion);
            result = "CORRECTO";
            File fileToDownload = new File("D:/SIPRE/Temporal/" + nombreArchivo + ".xlsx");
            try (FileInputStream fileInputStream = new FileInputStream(fileToDownload);
                    ServletOutputStream out = response.getOutputStream()) {
                String mimeType = new MimetypesFileTypeMap().getContentType("D:/SIPRE/Temporal/" + nombreArchivo + ".xlsx");
                response.setContentType(mimeType);
                response.setContentLength(fileInputStream.available());
                response.setHeader("Content-Disposition", "attachment; filename=\""
                        + fileToDownload.getName() + "\"");
                int c;
                while ((c = fileInputStream.read()) != -1) {
                    out.write(c);
                }
                out.flush();
            } catch (IOException e) {
                System.out.println("Error al leer Archivo" + e.getMessage());
            }
            if(fileToDownload.exists()){
                fileToDownload.delete();
            }
        }
        if (request.getAttribute("objConsultaEjecucion") != null) {
            request.removeAttribute("objConsultaEjecucion");
        }
        request.setAttribute("objConsultaEjecucion", objConsultaEjecucion);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnEjecucion.getMode()) {
            case "consultaEjecucion":
                dispatcher = request.getRequestDispatcher("Ejecucion/ConsultaEjecucion.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaConsultaEjecucion.jsp");
                break;
            default:
                dispatcher = request.getRequestDispatcher("error.jsp");
                break;
        }
        if (result != null) {
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(result);
            }
        } else {
            dispatcher.forward(request, response);
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
