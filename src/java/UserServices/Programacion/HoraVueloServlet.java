/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanHoraVuelo;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.HoraVueloDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.HoraVueloDAOImpl;
import Utiles.Utiles;
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
@WebServlet(name = "HoraVueloServlet", urlPatterns = {"/HoraVuelo"})
public class HoraVueloServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objHoraVuelo;
    private BeanHoraVuelo objBnHoraVuelo;
    private Connection objConnection;
    private HoraVueloDAO objDsHoraVuelo;
    private CombosDAO objDsCombo;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        //VERIFICAMOS LA SESSION DEL USUARIO
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnHoraVuelo = new BeanHoraVuelo();
        objBnHoraVuelo.setMode(request.getParameter("mode"));
        objBnHoraVuelo.setPeriodo(request.getParameter("periodo"));
        objBnHoraVuelo.setCodigoAeronave(Utiles.checkNum(request.getParameter("codigoAeronave")));
        objBnHoraVuelo.setCodigoCosteo(Utiles.checkNum(request.getParameter("codigoCosteo")));
        objBnHoraVuelo.setAeronave(request.getParameter("aeronave"));
        objBnHoraVuelo.setTarea(request.getParameter("tarea"));

        objDsHoraVuelo = new HoraVueloDAOImpl(objConnection);
        objDsCombo = new CombosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnHoraVuelo.getMode().equals("G")) {
            objHoraVuelo = objDsHoraVuelo.getListaHoraVuelo(objBnHoraVuelo, objUsuario.getUsuario());
        }
        if (objBnHoraVuelo.getMode().equals("GD")) {
            objHoraVuelo = objDsHoraVuelo.getListaCosteoHoraVuelo(objBnHoraVuelo, objUsuario.getUsuario());
        }
        if (objBnHoraVuelo.getMode().equals("U")) {
            objBnHoraVuelo = objDsHoraVuelo.getHoraVuelo(objBnHoraVuelo, objUsuario.getUsuario());
            result = objBnHoraVuelo.getTipoAeronave() + "+++"
                    + objBnHoraVuelo.getAeronave();
        }
        if (objBnHoraVuelo.getMode().equals("B")) {
            objBnHoraVuelo = objDsHoraVuelo.getCosteoHoraVuelo(objBnHoraVuelo, objUsuario.getUsuario());
            result = objBnHoraVuelo.getTipoCosto() + "+++"
                    + objBnHoraVuelo.getCadenaGasto() + "+++"
                    + objBnHoraVuelo.getImporte();
        }
        if (objBnHoraVuelo.getMode().equals("C")) {
            if (objBnHoraVuelo.getTarea().equals("0685")) {
                result = objDsHoraVuelo.getCosteoAeronaveHVEntidades(objBnHoraVuelo, objUsuario.getUsuario());
            } else {
                result = objDsHoraVuelo.getCostoAeronaveHV(objBnHoraVuelo, objUsuario.getUsuario());
            }
        }
        if (request.getAttribute("objHoraVuelo") != null) {
            request.removeAttribute("objHoraVuelo");
        }
        if (request.getAttribute("objBnHoraVuelo") != null) {
            request.removeAttribute("objBnHoraVuelo");
        }
        request.setAttribute("objHoraVuelo", objHoraVuelo);
        request.setAttribute("objBnHoraVuelo", objBnHoraVuelo);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnHoraVuelo.getMode()) {
            case "horaVuelo":
                dispatcher = request.getRequestDispatcher("Programacion/HoraVuelo.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaHoraVuelo.jsp");
                break;
            case "GD":
                dispatcher = request.getRequestDispatcher("Programacion/ListaCosteoHoraVuelo.jsp");
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
