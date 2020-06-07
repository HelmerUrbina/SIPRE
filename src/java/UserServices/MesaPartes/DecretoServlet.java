/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.MesaPartes;

import BusinessServices.Beans.BeanMesaParte;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.DecretoDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.DecretoDAOImpl;
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
@WebServlet(name = "DecretoServlet", urlPatterns = {"/Decreto"})
public class DecretoServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objDocumentos;
    private BeanMesaParte objBnDecreto;
    private Connection objConnection;
    private DecretoDAO objDsDecreto;
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
        objBnDecreto = new BeanMesaParte();
        objBnDecreto.setMode(request.getParameter("mode"));
        objBnDecreto.setPeriodo(request.getParameter("periodo"));
        objBnDecreto.setMes(request.getParameter("mes"));
        objBnDecreto.setTipo(request.getParameter("tipo"));
        objBnDecreto.setEstado(request.getParameter("estadoDoc"));
        objBnDecreto.setNumero(request.getParameter("numero"));
        objDsDecreto = new DecretoDAOImpl(objConnection);
        if (objBnDecreto.getMode().equals("G")) {
            objDocumentos = objDsDecreto.getConsultaDocumentos(objBnDecreto, objUsuario.getUsuario());
            objDsCombo = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objArea") != null) {
                request.removeAttribute("objArea");
            }
            request.setAttribute("objArea", objDsCombo.getAreaMesaPartes());
            if (request.getAttribute("objPrioridad") != null) {
                request.removeAttribute("objPrioridad");
            }
            request.setAttribute("objPrioridad", objDsCombo.getPrioridad());
        }
        if (objBnDecreto.getMode().equals("U")) {
            objBnDecreto = objDsDecreto.getDecretoDocumento(objBnDecreto, objUsuario.getUsuario());
            result = objBnDecreto.getUsuarioResponsable();
        }
        if (objBnDecreto.getMode().equals("B")) {
            result = "" + objDsDecreto.getListaDetalleDocumentoDecretado(objBnDecreto, objUsuario.getUsuario());
        }
        if (request.getAttribute("objDocumentos") != null) {
            request.removeAttribute("objDocumentos");
        }
        if (request.getAttribute("objBnDecreto") != null) {
            request.removeAttribute("objBnDecreto");
        }
        request.setAttribute("objDocumentos", objDocumentos);
        request.setAttribute("objBnDecreto", objBnDecreto);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "decreto":
                dispatcher = request.getRequestDispatcher("MesaPartes/Decreto.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("MesaPartes/ListaDecreto.jsp");
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
