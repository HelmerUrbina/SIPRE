/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanPersonal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.PersonalDAOImpl;
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
import DataService.Despachadores.PersonalDAO;
import java.io.InputStream;
import java.io.OutputStream;
import org.apache.commons.io.IOUtils;

/**
 *
 * @author H-TECCSI-V
 */
@WebServlet(name = "PersonalServlet", urlPatterns = {"/Personal"})
public class PersonalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPersonal objBnPersonal;
    private Connection objConnection;
    private PersonalDAO objDsRegistroPersonal;
    private CombosDAO objDsCombo;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnPersonal = new BeanPersonal();
        objBnPersonal.setMode(request.getParameter("mode"));
        objBnPersonal.setPersonal(Utiles.Utiles.checkNum(request.getParameter("personal")));
        objDsRegistroPersonal = new PersonalDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnPersonal.getMode().equals("G")) {
            objDsCombo = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objParentesco") != null) {
                request.removeAttribute("objParentesco");
            }
            if (request.getAttribute("objArea") != null) {
                request.removeAttribute("objArea");
            }
            if (request.getAttribute("objGrado") != null) {
                request.removeAttribute("objGrado");
            }
            if (request.getAttribute("objPersonal") != null) {
                request.removeAttribute("objPersonal");
            }
            if (request.getAttribute("objFamilia") != null) {
                request.removeAttribute("objFamilia");
            }
            request.setAttribute("objParentesco", objDsCombo.getParentesco());
            request.setAttribute("objArea", objDsCombo.getAreaLaboral());
            request.setAttribute("objGrado", objDsCombo.getGrado());
            request.setAttribute("objPersonal", objDsRegistroPersonal.getListaPersonal(objUsuario.getUsuario()));
            request.setAttribute("objFamilia", objDsRegistroPersonal.getListaPersonalFamilia(objUsuario.getUsuario()));
        }
        if (objBnPersonal.getMode().equals("U")) {
            objBnPersonal = objDsRegistroPersonal.getPersonal(objBnPersonal, objUsuario.getUsuario());
            result = objBnPersonal.getTipoDocumento() + "+++"
                    + objBnPersonal.getDocumento() + "+++"
                    + objBnPersonal.getPaterno() + "+++"
                    + objBnPersonal.getMaterno() + "+++"
                    + objBnPersonal.getNombres() + "+++"
                    + objBnPersonal.getFechaNacimiento() + "+++"
                    + objBnPersonal.getSexo() + "+++"
                    + objBnPersonal.getTelefono() + "+++"
                    + objBnPersonal.getDireccion() + "+++"
                    + objBnPersonal.getCorreo() + "+++"
                    + objBnPersonal.getGrado() + "+++"
                    + objBnPersonal.getCIP() + "+++"
                    + objBnPersonal.getAreaLaboral() + "+++"
                    + objBnPersonal.getCargo();
        }
        if (objBnPersonal.getMode().equals("F")) {
            result = "" + objDsRegistroPersonal.getDatosFamiliares(objBnPersonal, objUsuario.getUsuario());
        }
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "personal":
                dispatcher = request.getRequestDispatcher("Personal/Personal.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Personal/ListaPersonal.jsp");
                break;
            default:
                dispatcher = request.getRequestDispatcher("FinSession.jsp");
                break;
        }
        if (objBnPersonal.getMode().equals("imagen")) {
            byte[] imgData = objDsRegistroPersonal.getImagen(objBnPersonal.getPersonal());
            if (imgData == null) {
                try {
                    InputStream stream = context.getResourceAsStream("/Imagenes/Fondos/usuario.jpg");
                    imgData = IOUtils.toByteArray(stream);
                } catch (IOException ex) {
                    System.out.println(ex.getMessage());
                }
            }
            response.setContentType("image/*");
            try (OutputStream o = response.getOutputStream()) {
                o.write(imgData);
                o.flush();
            }
        } else if (result != null) {
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
