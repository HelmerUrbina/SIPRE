/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanRegistroPersonal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.RegistroPersonalDAOImpl;
import DataService.Despachadores.RegistroPersonalDAO;
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
 * @author hateccsiv
 */
@WebServlet(name = "PersonalServlet", urlPatterns = {"/Personal"})
public class PersonalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objPersonal;
    private List objPersonalFamiliar;
    private BeanRegistroPersonal objBnRegistroPersonal;
    private Connection objConnection;
    private RegistroPersonalDAO ObjDsRegistroPersonal;
    private String filePath;
    private CombosDAO objDsCombo;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnRegistroPersonal = new BeanRegistroPersonal();
        objBnRegistroPersonal.setMode(request.getParameter("mode"));
        objBnRegistroPersonal.setDni(request.getParameter("dni"));

        ObjDsRegistroPersonal = new RegistroPersonalDAOImpl(objConnection);
        objDsCombo = new CombosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnRegistroPersonal.getMode().equals("G")) {
            filePath = "";
            objBnRegistroPersonal.setRutaFile(filePath);
            objPersonal = ObjDsRegistroPersonal.getListaPersonal(objBnRegistroPersonal, objUsuario.getUsuario());
            objPersonalFamiliar = ObjDsRegistroPersonal.getListaPersonalFamilia(objBnRegistroPersonal, objUsuario.getUsuario());
            if (request.getAttribute("objParentesco") != null) {
                request.removeAttribute("objParentesco");
            }
            if (request.getAttribute("objArea") != null) {
                request.removeAttribute("objArea");
            }
            if (request.getAttribute("objGrado") != null) {
                request.removeAttribute("objGrado");
            }
            request.setAttribute("objParentesco", objDsCombo.getParentesco());
            request.setAttribute("objArea", objDsCombo.getAreaLaboral());
            request.setAttribute("objGrado", objDsCombo.getGrado());
        }
        if (objBnRegistroPersonal.getMode().equals("U")) {
            objBnRegistroPersonal = ObjDsRegistroPersonal.getPersonal(objBnRegistroPersonal, objUsuario.getUsuario());
            result = objBnRegistroPersonal.getNombresPersonal() + "+++"
                    + objBnRegistroPersonal.getApellidosPersonal() + "+++"
                    + objBnRegistroPersonal.getDireccion() + "+++"
                    + objBnRegistroPersonal.getTelefono() + "+++"
                    + objBnRegistroPersonal.getFechaNacimiento() + "+++"
                    + objBnRegistroPersonal.getAreaLaboral() + "+++"
                    + objBnRegistroPersonal.getCargo() + "+++"
                    + objBnRegistroPersonal.getGrado();
        }
        if (objBnRegistroPersonal.getMode().equals("F")) {
            result = "" + ObjDsRegistroPersonal.getDatosFamiliares(objBnRegistroPersonal, objUsuario.getUsuario());
            objDsCombo = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objParentesco") != null) {
                request.removeAttribute("objParentesco");
            }
            request.setAttribute("objParentesco", objDsCombo.getParentesco());
        }

        if (request.getAttribute("objBnRegistroPersonal") != null) {
            request.removeAttribute("objBnRegistroPersonal");
        }
        if (request.getAttribute("objPersonal") != null) {
            request.removeAttribute("objPersonal");
        }
        if (request.getAttribute("objPersonalFamiliar") != null) {
            request.removeAttribute("objPersonalFamiliar");
        }
        request.setAttribute("objBnRegistroPersonal", objBnRegistroPersonal);
        request.setAttribute("objPersonal", objPersonal);
        request.setAttribute("objPersonalFamiliar", objPersonalFamiliar);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "personal":
                dispatcher = request.getRequestDispatcher("Personal/RegistroPersonal.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Personal/ListaRegistroPersonal.jsp");
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
