/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.MesaPartes;

import BusinessServices.Beans.BeanMesaParte;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.MesaParteDAOImpl;
import DataService.Despachadores.MesaParteDAO;
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
@WebServlet(name = "RemisionDocumentoServlet", urlPatterns = {"/RemisionDocumento"})
public class RemisionDocumentoServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objRemisionDocumento;
    private BeanMesaParte objBnMesaParte;
    private Connection objConnection;
    private MesaParteDAO objDsMesaParte;
    private CombosDAO objDsCombo;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(false);
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        //VERIFICAMOS LA SESSION DEL USUARIO
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnMesaParte = new BeanMesaParte();
        objBnMesaParte.setMode(request.getParameter("mode"));
        objBnMesaParte.setPeriodo(request.getParameter("periodo"));
        objBnMesaParte.setMes(request.getParameter("mes"));
        objBnMesaParte.setTipo(request.getParameter("tipo"));
        objBnMesaParte.setNumero(request.getParameter("codigo"));
        objBnMesaParte.setTipoDocumento(request.getParameter("tipoDocumento"));
        objDsMesaParte = new MesaParteDAOImpl(objConnection);
        if (objBnMesaParte.getMode().equals("G")) {
            objRemisionDocumento = objDsMesaParte.getListaRemisionDocumento(objBnMesaParte, objUsuario.getUsuario());
            objDsCombo = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objPrioridad") != null) {
                request.removeAttribute("objPrioridad");
            }
            request.setAttribute("objPrioridad", objDsCombo.getPrioridad());
            if (request.getAttribute("objTipoDocumento") != null) {
                request.removeAttribute("objTipoDocumento");
            }
            request.setAttribute("objTipoDocumento", objDsCombo.getTipoDocumentos());
            if (request.getAttribute("objClasificacion") != null) {
                request.removeAttribute("objClasificacion");
            }
            request.setAttribute("objClasificacion", objDsCombo.getClasificacionDocumento());
            if (request.getAttribute("objArea") != null) {
                request.removeAttribute("objArea");
            }
            request.setAttribute("objArea", objDsCombo.getAreaMesaPartes());
            objBnMesaParte.setArea(objUsuario.getAreaLaboral());
            objBnMesaParte.setUsuario(objUsuario.getUsuario());
        }
        if (objBnMesaParte.getMode().equals("B")) {
            result = objDsMesaParte.getNumeroDocumentoSalida(objBnMesaParte, objUsuario.getUsuario());
        }
        if (objBnMesaParte.getMode().equals("I")) {
            result = objDsMesaParte.getNumeroDocumento(objBnMesaParte, objUsuario.getUsuario());
        }
        if (objBnMesaParte.getMode().equals("U")) {
            objBnMesaParte = objDsMesaParte.getMesaParte(objBnMesaParte, objUsuario.getUsuario());
            result = objBnMesaParte.getNumeroDocumento() + "+++"
                    + objBnMesaParte.getFecha() + "+++"
                    + objBnMesaParte.getObservacion() + "+++"
                    + objBnMesaParte.getAsunto() + "+++"
                    + objBnMesaParte.getFechaRecepcion() + "+++"
                    + objBnMesaParte.getTipoDocumento() + "+++"
                    + objBnMesaParte.getClasificacion() + "+++"
                    + objBnMesaParte.getSubGrupo() + "+++"
                    + objBnMesaParte.getInstitucion() + "+++"
                    + objBnMesaParte.getPrioridad() + "+++"
                    + objBnMesaParte.getHora() + "+++"
                    + objBnMesaParte.getLegajo() + "+++"
                    + objBnMesaParte.getFolio() + "+++"
                    + objBnMesaParte.getArea() + "+++"
                    + objBnMesaParte.getUsuarioResponsable() + "+++"
                    + objBnMesaParte.getReferencia();
        }
        if (request.getAttribute("objRemisionDocumento") != null) {
            request.removeAttribute("objRemisionDocumento");
        }
        if (request.getAttribute("objBnMesaParte") != null) {
            request.removeAttribute("objBnMesaParte");
        }
        request.setAttribute("objRemisionDocumento", objRemisionDocumento);
        request.setAttribute("objBnMesaParte", objBnMesaParte);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "remision":
                dispatcher = request.getRequestDispatcher("MesaPartes/RemisionDocumento.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("MesaPartes/ListaRemisionDocumento.jsp");
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
