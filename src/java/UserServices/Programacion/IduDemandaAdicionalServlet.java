/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanDemandaAdicional;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.DemandaAdicionalDAO;
import DataService.Despachadores.Impl.DemandaAdicionalDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import Utiles.Utiles;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.Collection;
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
@WebServlet(name = "IduDemandaAdicionalServlet", urlPatterns = {"/IduDemandaAdicional"})
@MultipartConfig(location = "D:/SIPRE/PROGRAMACION/DemandaAdicional",
        fileSizeThreshold = 1024 * 1024 * 10,       // 10 MB 
        maxFileSize = 1024 * 1024 * 500,            // 500 MB
        maxRequestSize = 1024 * 1024 * 1000)        // 1000 MB
public class IduDemandaAdicionalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanDemandaAdicional objBnDemandaAdicional;
    private Connection objConnection;
    private DemandaAdicionalDAO objDsDemandaAdicional;
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
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        String result = null;
        int k = 0;
        String resulDetalle = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnDemandaAdicional = new BeanDemandaAdicional();
        objBnDemandaAdicional.setMode(request.getParameter("mode"));
        objBnDemandaAdicional.setPeriodo(request.getParameter("periodo"));
        objBnDemandaAdicional.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnDemandaAdicional.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnDemandaAdicional.setDescripcion(request.getParameter("descripcion"));
        objDsDemandaAdicional = new DemandaAdicionalDAOImpl(objConnection);
        if (request.getParameter("codigo").equals("0") || request.getParameter("codigo") == null) {
            objBnDemandaAdicional.setCodigo(objDsDemandaAdicional.getCodigoDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario()));
        } else {
            objBnDemandaAdicional.setCodigo(Utiles.checkNum(request.getParameter("codigo")));
        }
        switch (objBnDemandaAdicional.getMode()) {
            case "Z": {
                k = objDsDemandaAdicional.iduDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                break;
            }
            case "D": {
                k = objDsDemandaAdicional.iduDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                break;
            }
            case "M": {
                String lista[][] = Utiles.generaLista(request.getParameter("lista"), 2);
                for (String[] item : lista) {
                    objBnDemandaAdicional.setTarea(item[0].trim());
                    objBnDemandaAdicional.setImporte(Utiles.checkDouble(item[1]));
                    k = objDsDemandaAdicional.iduMetaFisicaDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                }
                break;
            }
            case "A": {
                String lista[][] = Utiles.generaLista(request.getParameter("lista"), 5);
                for (String[] item : lista) {
                    objBnDemandaAdicional.setDependencia(item[0].trim());
                    objBnDemandaAdicional.setTarea(item[1].trim());
                    objBnDemandaAdicional.setCadenaGasto(item[2].trim());
                    objBnDemandaAdicional.setImporte(Utiles.checkDouble(item[3]));
                    objBnDemandaAdicional.setCantidad(Utiles.checkDouble(item[4]));
                    k = objDsDemandaAdicional.udpAprobacionDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                }
                k = objDsDemandaAdicional.iduDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                break;
            }
            case "C": {
                response.setContentType("text/html;charset=UTF-8");
                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if (null != Utiles.getFileName(part)) {
                        objBnDemandaAdicional.setDescripcion(Utiles.getFileName(part));
                        part.write(objBnDemandaAdicional.getPeriodo() + "-" + objBnDemandaAdicional.getUnidadOperativa()+ "-" + objBnDemandaAdicional.getPresupuesto()+ "-" + objBnDemandaAdicional.getCodigo()+ "-" + objBnDemandaAdicional.getDescripcion());
                    }
                }
                k = objDsDemandaAdicional.iduDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                break;
            }
            default: {
                String lista[][] = Utiles.generaLista(request.getParameter("lista"), 4);
                // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
                k = objDsDemandaAdicional.iduDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                objBnDemandaAdicional.setMode("D");
                objBnDemandaAdicional.setImporte(0.0);
                k = objDsDemandaAdicional.iduDetalleDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                if (k != 0) {
                    for (String[] item : lista) {
                        objBnDemandaAdicional.setMode("I");
                        objBnDemandaAdicional.setDependencia(item[0].trim());
                        objBnDemandaAdicional.setTarea(item[1].trim());
                        objBnDemandaAdicional.setCadenaGasto(item[2].trim());
                        objBnDemandaAdicional.setImporte(Utiles.checkDouble(item[3]));
                        k = objDsDemandaAdicional.iduDetalleDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
                    }
                }
                break;
            }
        }
        if (k == 0) {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBnDemandaAdicional.getMode());
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
