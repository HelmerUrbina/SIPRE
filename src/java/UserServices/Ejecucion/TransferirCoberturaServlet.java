/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.TransferirCoberturaDAOImpl;
import DataService.Despachadores.TransferirCoberturaDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;
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
 * @author H-TECCSI-V
 */
@WebServlet(name = "TransferirCoberturaServlet", urlPatterns = {"/TransferirCobertura"})
public class TransferirCoberturaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objCoberturaMensual;
    private BeanEjecucionPresupuestal objBnTransferirCobertura;
    private Connection objConnection;
    private TransferirCoberturaDAO objDsTransferirCobertura;

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
        objBnTransferirCobertura = new BeanEjecucionPresupuestal();
        objBnTransferirCobertura.setMode(request.getParameter("mode"));
        objBnTransferirCobertura.setPeriodo(request.getParameter("periodo"));
        objBnTransferirCobertura.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnTransferirCobertura.setCobertura(request.getParameter("coberturaInicial"));
        objBnTransferirCobertura.setCertificado(request.getParameter("coberturaFinal"));
        objDsTransferirCobertura = new TransferirCoberturaDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnTransferirCobertura.getMode().equals("G")) {
            objCoberturaMensual = objDsTransferirCobertura.getListaCoberturas(objBnTransferirCobertura, objUsuario.getUsuario());

        }
        if (request.getAttribute("objCoberturaMensual") != null) {
            request.removeAttribute("objCoberturaMensual");
        }
        if (request.getAttribute("objCoberturaMensualDetalle") != null) {
            request.removeAttribute("objCoberturaMensualDetalle");
        }
        request.setAttribute("objCoberturaMensual", objCoberturaMensual);
        request.setAttribute("objBnTransferirCobertura", objBnTransferirCobertura);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnTransferirCobertura.getMode()) {
            case "trans":
                dispatcher = request.getRequestDispatcher("Ejecucion/TransferirCobertura.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaTransferirCobertura.jsp");
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
