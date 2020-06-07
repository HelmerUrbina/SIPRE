/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanEnteGenerador;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.EnteGeneradorDAO;
import DataService.Despachadores.Impl.EnteGeneradorDAOImpl;
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
 * @author OPRE
 */
@WebServlet(name = "IduEnteGeneradorServlet", urlPatterns = {"/IduEnteGenerador"})
public class IduEnteGeneradorServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanEnteGenerador objBnEnteGenerador;
    private Connection objConnection;
    private EnteGeneradorDAO objDsEnteGenerador;
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
        session = request.getSession();
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnEnteGenerador = new BeanEnteGenerador();
        objBnEnteGenerador.setMode(request.getParameter("mode"));
        objBnEnteGenerador.setPeriodo(request.getParameter("periodo"));
        objBnEnteGenerador.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnEnteGenerador.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnEnteGenerador.setCodigo(Utiles.checkNum(request.getParameter("codigo")));
        objBnEnteGenerador.setCadenaIngreso(request.getParameter("cadenaIngreso"));
        objBnEnteGenerador.setDescripcion(request.getParameter("descripcion"));

        objBnEnteGenerador.setEnero(Utiles.checkDouble(request.getParameter("enero")));
        objBnEnteGenerador.setFebrero(Utiles.checkDouble(request.getParameter("febrero")));
        objBnEnteGenerador.setMarzo(Utiles.checkDouble(request.getParameter("marzo")));
        objBnEnteGenerador.setAbril(Utiles.checkDouble(request.getParameter("abril")));
        objBnEnteGenerador.setMayo(Utiles.checkDouble(request.getParameter("mayo")));
        objBnEnteGenerador.setJunio(Utiles.checkDouble(request.getParameter("junio")));
        objBnEnteGenerador.setJulio(Utiles.checkDouble(request.getParameter("julio")));
        objBnEnteGenerador.setAgosto(Utiles.checkDouble(request.getParameter("agosto")));
        objBnEnteGenerador.setSetiembre(Utiles.checkDouble(request.getParameter("setiembre")));
        objBnEnteGenerador.setOctubre(Utiles.checkDouble(request.getParameter("octubre")));
        objBnEnteGenerador.setNoviembre(Utiles.checkDouble(request.getParameter("noviembre")));
        objBnEnteGenerador.setDiciembre(Utiles.checkDouble(request.getParameter("diciembre")));

        objBnEnteGenerador.setCostoEnero(Utiles.checkDouble(request.getParameter("costoEnero")));
        objBnEnteGenerador.setCostoFebrero(Utiles.checkDouble(request.getParameter("costoFebrero")));
        objBnEnteGenerador.setCostoMarzo(Utiles.checkDouble(request.getParameter("costoMarzo")));
        objBnEnteGenerador.setCostoAbril(Utiles.checkDouble(request.getParameter("costoAbril")));
        objBnEnteGenerador.setCostoMayo(Utiles.checkDouble(request.getParameter("costoMayo")));
        objBnEnteGenerador.setCostoJunio(Utiles.checkDouble(request.getParameter("costoJunio")));
        objBnEnteGenerador.setCostoJulio(Utiles.checkDouble(request.getParameter("costoJulio")));
        objBnEnteGenerador.setCostoAgosto(Utiles.checkDouble(request.getParameter("costoAgosto")));
        objBnEnteGenerador.setCostoSetiembre(Utiles.checkDouble(request.getParameter("costoSetiembre")));
        objBnEnteGenerador.setCostoOctubre(Utiles.checkDouble(request.getParameter("costoOctubre")));
        objBnEnteGenerador.setCostoNoviembre(Utiles.checkDouble(request.getParameter("costoNoviembre")));
        objBnEnteGenerador.setCostoDiciembre(Utiles.checkDouble(request.getParameter("costoDiciembre")));
        objDsEnteGenerador = new EnteGeneradorDAOImpl(objConnection);
        int k;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        if (objBnEnteGenerador.getMode().equals("H")) {
            k = objDsEnteGenerador.iduGeneraCNV(objBnEnteGenerador, objUsuario.getUsuario());
            if (k != 0) {
                objBnEnteGenerador.setTarea("0001");
                result = objDsEnteGenerador.getCNV(objBnEnteGenerador, objUsuario.getUsuario());
            }
        } else {
            k = objDsEnteGenerador.iduEnteGenerador(objBnEnteGenerador, objUsuario.getUsuario());
        }
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_ENTE_GENERADOR");
            objBnMsgerr.setTipo(objBnEnteGenerador.getMode());
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
