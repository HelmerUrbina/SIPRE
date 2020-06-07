/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanNotaModificatoria;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.ConsolidadoNotaModificatoriaDAO;
import DataService.Despachadores.Impl.ConsolidadoNotaModificatoriaDAOImpl;
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
@WebServlet(name = "IduConsolidadoNotaModificatoriaServlet", urlPatterns = {"/IduConsolidadoNotaModificatoria"})
public class IduConsolidadoNotaModificatoriaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanNotaModificatoria objBnConsolidadoNota;
    private Connection objConnection;
    private ConsolidadoNotaModificatoriaDAO objDsConsolidadoNota;
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
        session = request.getSession(true);
        String result = null;
        String resulDetalle = null;

        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnConsolidadoNota = new BeanNotaModificatoria();
        objBnConsolidadoNota.setMode(request.getParameter("mode"));
        objBnConsolidadoNota.setPeriodo(request.getParameter("periodo"));
        objBnConsolidadoNota.setPresupuesto(request.getParameter("presupuesto"));
        objBnConsolidadoNota.setMes(request.getParameter("mes"));
        objBnConsolidadoNota.setCodigo(request.getParameter("codigo"));
        objBnConsolidadoNota.setJustificacion(request.getParameter("justificacion"));
        objBnConsolidadoNota.setSIAF(Utiles.checkNum(request.getParameter("siaf")));
        objDsConsolidadoNota = new ConsolidadoNotaModificatoriaDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        switch (objBnConsolidadoNota.getMode()) {
            case "A":
                objBnConsolidadoNota.setImportancia(request.getParameter("importancia"));
                objBnConsolidadoNota.setFinanciamiento(request.getParameter("financiamiento"));
                objBnConsolidadoNota.setConsecuencia(request.getParameter("consecuencias"));
                objBnConsolidadoNota.setVariacion(request.getParameter("variacion"));
                k = objDsConsolidadoNota.iduConsolidadoNotaModificatoriaInforme(objBnConsolidadoNota, objUsuario.getUsuario());
                break;
            case "C":
                k = objDsConsolidadoNota.iduConsolidarNotaModificatoria(objBnConsolidadoNota, objUsuario.getUsuario());
                break;
            case "D":
                k = objDsConsolidadoNota.iduConsolidarNotaModificatoria(objBnConsolidadoNota, objUsuario.getUsuario());
                break;
            case "U":
                k = objDsConsolidadoNota.iduConsolidarNotaModificatoria(objBnConsolidadoNota, objUsuario.getUsuario());
                break;
            case "M":
                k = objDsConsolidadoNota.eliminaDetalleConsolidadoNotaModificatoria(objBnConsolidadoNota, objUsuario.getUsuario());
                String arreglo[][] = Utiles.generaLista(request.getParameter("lista"), 3);
                for (String[] item : arreglo) {
                    objBnConsolidadoNota.setMode("I");
                    objBnConsolidadoNota.setUnidadOperativa(item[1].trim());
                    objBnConsolidadoNota.setNotaModificatoria("" + Utiles.checkNum(item[2].trim()));
                    k = objDsConsolidadoNota.iduConsolidadoNotaModificatoriaDetalle(objBnConsolidadoNota, objUsuario.getUsuario());
                }
                break;
            default:
                if (objBnConsolidadoNota.getMode().equals("I")) {
                    objBnConsolidadoNota.setCodigo(objDsConsolidadoNota.getCodigoConsolidadoNota(objBnConsolidadoNota, objUsuario.getUsuario()));
                }
                String lista[][] = Utiles.generaLista(request.getParameter("lista"), 3);
                for (String[] item : lista) {
                    objBnConsolidadoNota.setUnidadOperativa(item[1]);
                    objBnConsolidadoNota.setNotaModificatoria(item[2]);
                    k = objDsConsolidadoNota.iduConsolidarNotaModificatoria(objBnConsolidadoNota, objUsuario.getUsuario());
                }
                break;
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0 || result != null) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_CONSOLIDADO_NOTA");
            objBnMsgerr.setTipo(objBnConsolidadoNota.getMode());
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
