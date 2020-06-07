/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Consultas;

import BusinessServices.Beans.BeanCadenaFuncional;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CadenaFuncionalEjecucionDAO;
import DataService.Despachadores.Impl.CadenaFuncionalEjecucionDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MsgerrDAO;
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
@WebServlet(name = "IduCadenaFuncionalEjecucionServlet", urlPatterns = {"/IduCadenaFuncionalEjecucion"})
public class IduCadenaFuncionalEjecucionServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanCadenaFuncional objBnCadenaFuncional;
    private Connection objConnection;
    private CadenaFuncionalEjecucionDAO objDsCadenaFuncional;
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
        objBnCadenaFuncional = new BeanCadenaFuncional();
        objBnCadenaFuncional.setMode(request.getParameter("mode"));
        objBnCadenaFuncional.setPeriodo(request.getParameter("periodo"));
        objBnCadenaFuncional.setCodigo(request.getParameter("codigo"));
        objBnCadenaFuncional.setSecuenciaFuncional(request.getParameter("secuenciaFuncional"));
        objBnCadenaFuncional.setCategoriaPresupuestal(request.getParameter("categoriaPresupuestal"));
        objBnCadenaFuncional.setCategoriaPresupuestalNombre(request.getParameter("categoriaPresupuestalNombre"));
        objBnCadenaFuncional.setProducto(request.getParameter("producto"));
        objBnCadenaFuncional.setProductoNombre(request.getParameter("productoNombre"));
        objBnCadenaFuncional.setActividad(request.getParameter("actividad"));
        objBnCadenaFuncional.setActividadNombre(request.getParameter("actividadNombre"));
        objBnCadenaFuncional.setFuncion(request.getParameter("funcion").trim());
        objBnCadenaFuncional.setFuncionNombre(request.getParameter("funcionNombre"));
        objBnCadenaFuncional.setDivisionFuncional(request.getParameter("divisionFuncional"));
        objBnCadenaFuncional.setDivisionFuncionalNombre(request.getParameter("divisionFuncionalNombre"));
        objBnCadenaFuncional.setGrupoFuncional(request.getParameter("grupoFuncional"));
        objBnCadenaFuncional.setGrupoFuncionalNombre(request.getParameter("grupoFuncionalNombre"));
        objBnCadenaFuncional.setMeta(request.getParameter("meta"));
        objBnCadenaFuncional.setMetaNombre(request.getParameter("metaNombre"));
        objBnCadenaFuncional.setFinalidad(request.getParameter("finalidad"));
        objBnCadenaFuncional.setFinalidadNombre(request.getParameter("finalidadNombre"));
        objBnCadenaFuncional.setUnidadMedida(request.getParameter("unidadMedida"));
        objBnCadenaFuncional.setDepartamento(request.getParameter("departamento"));
        objBnCadenaFuncional.setProvincia(request.getParameter("provincia"));
        objBnCadenaFuncional.setDistrito(request.getParameter("distrito"));
        objDsCadenaFuncional = new CadenaFuncionalEjecucionDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = objDsCadenaFuncional.iduCadenaFuncional(objBnCadenaFuncional, objUsuario.getUsuario());
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("TACAFU");
            objBnMsgerr.setTipo(objBnCadenaFuncional.getMode());
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
