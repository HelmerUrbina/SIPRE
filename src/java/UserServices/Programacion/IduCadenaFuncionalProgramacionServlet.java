/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanCadenaFuncional;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CadenaFuncionalProgramacionDAO;
import DataService.Despachadores.Impl.CadenaFuncionalProgramacionDAOImpl;
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
@WebServlet(name = "IduCadenaFuncionalProgramacionServlet", urlPatterns = {"/IduCadenaFuncionalProgramacion"})
public class IduCadenaFuncionalProgramacionServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanCadenaFuncional objBnCadenaFuncional;
    private Connection objConnection;
    private CadenaFuncionalProgramacionDAO objDsCadenaFuncional;
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
        objBnCadenaFuncional.setCategoriaPresupuestal(Utiles.Utiles.CompletarCeros(request.getParameter("categoriaPresupuestal"), 4));
        objBnCadenaFuncional.setCategoriaPresupuestalNombre(request.getParameter("categoriaPresupuestalNombre"));
        objBnCadenaFuncional.setProducto(Utiles.Utiles.CompletarCeros(request.getParameter("producto").trim(), 7));
        objBnCadenaFuncional.setProductoNombre(request.getParameter("productoNombre"));
        objBnCadenaFuncional.setActividad(Utiles.Utiles.CompletarCeros(request.getParameter("actividad").trim(), 7));
        objBnCadenaFuncional.setActividadNombre(request.getParameter("actividadNombre"));
        objBnCadenaFuncional.setFuncion(Utiles.Utiles.CompletarCeros(request.getParameter("funcion"), 2));
        objBnCadenaFuncional.setFuncionNombre(request.getParameter("funcionNombre"));
        objBnCadenaFuncional.setDivisionFuncional(Utiles.Utiles.CompletarCeros(request.getParameter("divisionFuncional"), 3));
        objBnCadenaFuncional.setDivisionFuncionalNombre(request.getParameter("divisionFuncionalNombre"));
        objBnCadenaFuncional.setGrupoFuncional(Utiles.Utiles.CompletarCeros(request.getParameter("grupoFuncional"), 4));
        objBnCadenaFuncional.setGrupoFuncionalNombre(request.getParameter("grupoFuncionalNombre"));
        objBnCadenaFuncional.setMeta(request.getParameter("meta"));
        objBnCadenaFuncional.setMetaNombre(request.getParameter("metaNombre"));
        objBnCadenaFuncional.setFinalidad(Utiles.Utiles.CompletarCeros(request.getParameter("finalidad").trim(), 7));
        objBnCadenaFuncional.setFinalidadNombre(request.getParameter("finalidadNombre"));
        objBnCadenaFuncional.setUnidadMedida(request.getParameter("unidadMedida"));
        objBnCadenaFuncional.setDepartamento(request.getParameter("departamento"));
        objBnCadenaFuncional.setProvincia(request.getParameter("provincia"));
        objBnCadenaFuncional.setDistrito(request.getParameter("distrito"));
        objDsCadenaFuncional = new CadenaFuncionalProgramacionDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = objDsCadenaFuncional.iduCadenaFuncional(objBnCadenaFuncional, objUsuario.getUsuario());
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("TACAFU_PRG");
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
