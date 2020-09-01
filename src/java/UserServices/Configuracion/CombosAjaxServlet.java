/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Configuracion;

import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import java.io.IOException;
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
@WebServlet(name = "CombosAjaxServlet", urlPatterns = {"/CombosAjax"})
public class CombosAjaxServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private Connection objConnection;
    private CombosDAO objDsCombos;

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
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSesion.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objDsCombos = new CombosDAOImpl(objConnection);
        String mode = request.getParameter("mode");
        String periodo = request.getParameter("periodo");
        String unidadOperativa = request.getParameter("unidadOperativa");
        String codigo = request.getParameter("codigo");
        Integer presupuesto = Utiles.Utiles.checkNum(request.getParameter("presupuesto"));
        Integer resolucion = Utiles.Utiles.checkNum(request.getParameter("resolucion"));
        if (request.getAttribute("objCombosAjax") != null) {
            request.removeAttribute("objCombosAjax");
        }
        switch (mode) {
            //CONFIGURACION DEL SISTEMA
            case "presupuesto":
                request.setAttribute("objCombosAjax", objDsCombos.getPresupuesto(periodo, objUsuario.getUnidadOperativa(), objUsuario.getUsuario()));
                break;
            case "unidadOperativa":
                request.setAttribute("objCombosAjax", objDsCombos.getUnidadesOperativas(periodo, presupuesto, objUsuario.getUnidadOperativa(), objUsuario.getUsuario()));
                break;
            case "dependencia":
                request.setAttribute("objCombosAjax", objDsCombos.getDependencia(unidadOperativa));
                break;
            case "tarea":
                request.setAttribute("objCombosAjax", objDsCombos.getTarea());
                break;
            case "unidadMedida":
                request.setAttribute("objCombosAjax", objDsCombos.getUnidadMedida());
                break;
            case "areaLaboral":
                request.setAttribute("objCombosAjax", objDsCombos.getAreaLaboral());
                break;
            case "grados":
                request.setAttribute("objCombosAjax", objDsCombos.getGrados(codigo));
                break;
            case "genericaGasto":
                request.setAttribute("objCombosAjax", objDsCombos.getGenericaGasto(periodo, presupuesto));
                break;
            //UBIGEO
            case "departamento":
                request.setAttribute("objCombosAjax", objDsCombos.getDepartamento());
                break;
            case "provincia":
                request.setAttribute("objCombosAjax", objDsCombos.getProvincia(request.getParameter("departamento")));
                break;
            case "distrito":
                request.setAttribute("objCombosAjax", objDsCombos.getDistrito(request.getParameter("departamento"), request.getParameter("provincia")));
                break;
            //PLANEAMIENTO
            case "objetivosEstrategicos":
                request.setAttribute("objCombosAjax", objDsCombos.getObjetivosEstrategicos(periodo));
                break;
            case "accionesEstrategicas":
                request.setAttribute("objCombosAjax", objDsCombos.getAccionesEstrategicas(periodo, request.getParameter("objetivo")));
                break;
            case "tareaOperativa":
                request.setAttribute("objCombosAjax", objDsCombos.getTareaOperativa());
                break;
            case "ubigeoActividad":
                request.setAttribute("objCombosAjax", objDsCombos.getUbigeoActividadPresupuestal(periodo, request.getParameter("categoriaPresupuestal"), request.getParameter("producto"), request.getParameter("actividad")));
                break;
            //EJECUCION PRESUPUESTAL - CERTIFICACION 
            case "tipoCalendarioCertificacion":
                request.setAttribute("objCombosAjax", objDsCombos.getTipoCalendarioUnidad(periodo, presupuesto, unidadOperativa));
                break;
            case "PAACProcesos":
                request.setAttribute("objCombosAjax", objDsCombos.getPAACProcesos(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCertificado")));
                break;
            case "subTipoCalendario":
                request.setAttribute("objCombosAjax", objDsCombos.getSubTipoCalendario(presupuesto, codigo));
                break;
            case "idpCertificado":
                request.setAttribute("objCombosAjax", objDsCombos.getIDPCertificado(periodo, presupuesto, unidadOperativa));
                break;
            case "resolucionCertificacion":
                request.setAttribute("objCombosAjax", objDsCombos.getResolucionesCertificado(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        request.getParameter("tipoCertificado"), request.getParameter("solicitudCredito"), request.getParameter("informeDisponibilidad")));
                break;
            case "dependenciaCertificacion":
                request.setAttribute("objCombosAjax", objDsCombos.getDependenciaCertificado(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        resolucion, request.getParameter("tipoCertificado"), request.getParameter("solicitudCredito"), request.getParameter("informeDisponibilidad")));
                break;
            case "secuenciaFuncionalCertificacion":
                request.setAttribute("objCombosAjax", objDsCombos.getSecuenciaFuncionalCertificado(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        resolucion, request.getParameter("dependencia"), request.getParameter("tipoCertificado"), request.getParameter("solicitudCredito"),
                        request.getParameter("informeDisponibilidad")));
                break;
            case "tareaCertificacion":
                request.setAttribute("objCombosAjax", objDsCombos.getTareaCertificado(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        resolucion, request.getParameter("dependencia"), request.getParameter("secuenciaFuncional"), request.getParameter("tipoCertificado"),
                        request.getParameter("solicitudCredito"), request.getParameter("informeDisponibilidad")));
                break;
            case "cadenaGastoCertificacion":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGastoCertificado(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        resolucion, request.getParameter("dependencia"), request.getParameter("secuenciaFuncional"), request.getParameter("tarea"), request.getParameter("tipoCertificado"),
                        request.getParameter("solicitudCredito"), request.getParameter("informeDisponibilidad")));
                break;
            //EJECUCION PRESUPUESTAL - COMPROMISO ANUAL   
            case "solicitudCredito":
                request.setAttribute("objCombosAjax", objDsCombos.getSolicitudCreditoUnidad(periodo, presupuesto, unidadOperativa));
                break;
            case "proveedorCompromiso":
                request.setAttribute("objCombosAjax", objDsCombos.getProveedorCompromiso(periodo, presupuesto, unidadOperativa, request.getParameter("compromisoAnual"),
                        request.getParameter("tipoCompromiso")));
                break;
            case "resolucionCompromiso":
                request.setAttribute("objCombosAjax", objDsCombos.getResolucionesCompromiso(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        request.getParameter("solicitudCredito"), request.getParameter("proveedor"), request.getParameter("tipoCompromiso"), request.getParameter("compromisoAnual")));
                break;
            case "dependenciaCompromiso":
                request.setAttribute("objCombosAjax", objDsCombos.getDependenciaCompromiso(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        resolucion, request.getParameter("solicitudCredito"), request.getParameter("proveedor"), request.getParameter("tipoCompromiso"), request.getParameter("compromisoAnual")));
                break;
            case "secuenciaFuncionalCompromiso":
                request.setAttribute("objCombosAjax", objDsCombos.getSecuenciaFuncionalCompromiso(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        resolucion, request.getParameter("dependencia"), request.getParameter("solicitudCredito"), request.getParameter("proveedor"),
                        request.getParameter("tipoCompromiso"), request.getParameter("compromisoAnual")));
                break;
            case "tareaCompromiso":
                request.setAttribute("objCombosAjax", objDsCombos.getTareaCompromiso(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        resolucion, request.getParameter("dependencia"), request.getParameter("secuenciaFuncional"), request.getParameter("solicitudCredito"), request.getParameter("proveedor"),
                        request.getParameter("tipoCompromiso"), request.getParameter("compromisoAnual")));
                break;
            case "cadenaGastoCompromiso":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGastoCompromiso(periodo, presupuesto, unidadOperativa, request.getParameter("tipoCalendario"),
                        resolucion, request.getParameter("dependencia"), request.getParameter("secuenciaFuncional"), request.getParameter("tarea"),
                        request.getParameter("solicitudCredito"), request.getParameter("proveedor"), request.getParameter("tipoCompromiso"), request.getParameter("compromisoAnual")));
                break;
            //EJECUCION PRESUPUESTAL - DECLARACION JURADA
            case "compromisoAnual":
                request.setAttribute("objCombosAjax", objDsCombos.getCompromisoAnualUnidad(periodo, presupuesto, unidadOperativa));
                break;
            case "proveedorDeclaracionJurada":
                request.setAttribute("objCombosAjax", objDsCombos.getProveedorDeclaracionJurada(periodo, presupuesto, unidadOperativa, request.getParameter("compromisoAnual"),
                        request.getParameter("tipoCalendario"), request.getParameter("cobertura")));
                break;
            case "resolucionDeclaracionJurada":
                request.setAttribute("objCombosAjax", objDsCombos.getResolucionesDeclaracionJurada(periodo, presupuesto, unidadOperativa, request.getParameter("compromisoAnual"),
                        request.getParameter("tipoCalendario"), request.getParameter("cobertura"), request.getParameter("proveedor")));
                break;
            case "dependenciaDeclaracionJurada":
                request.setAttribute("objCombosAjax", objDsCombos.getDependenciaDeclaracionJurada(periodo, presupuesto, unidadOperativa, request.getParameter("compromisoAnual"),
                        request.getParameter("tipoCalendario"), request.getParameter("cobertura"), request.getParameter("proveedor"), resolucion));
                break;
            case "secuenciaFuncionalDeclaracionJurada":
                request.setAttribute("objCombosAjax", objDsCombos.getSecuenciaFuncionalDeclaracionJurada(periodo, presupuesto, unidadOperativa, request.getParameter("compromisoAnual"),
                        request.getParameter("tipoCalendario"), request.getParameter("cobertura"), request.getParameter("proveedor"), resolucion, request.getParameter("dependencia")));
                break;
            case "tareaDeclaracionJurada":
                request.setAttribute("objCombosAjax", objDsCombos.getTareaDeclaracionJurada(periodo, presupuesto, unidadOperativa, request.getParameter("compromisoAnual"),
                        request.getParameter("tipoCalendario"), request.getParameter("cobertura"), request.getParameter("proveedor"), resolucion, request.getParameter("dependencia"),
                        request.getParameter("secuenciaFuncional")));
                break;
            case "cadenaGastoDeclaracionJurada":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGastoDeclaracionJurada(periodo, presupuesto, unidadOperativa, request.getParameter("compromisoAnual"),
                        request.getParameter("tipoCalendario"), request.getParameter("cobertura"), request.getParameter("proveedor"), resolucion, request.getParameter("dependencia"),
                        request.getParameter("secuenciaFuncional"), request.getParameter("tarea")));
                break;
            case "periodoResolucion":
                request.setAttribute("objCombosAjax", objDsCombos.getPeriodoResolucion(codigo));
                break;
            case "beneficioJADPE":
                request.setAttribute("objCombosAjax", objDsCombos.getBeneficioJADPE(codigo, periodo));
                break;
            //EJECUCION PRESUPUESTAL - NOTA MODIFICATORIA
            case "tipoNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getTipoNotaModificatoria(unidadOperativa));
                break;
            case "unidadNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getUnidadNotaModificatoria(unidadOperativa, request.getParameter("tipoNota"), request.getParameter("tipo")));
                break;
            case "presupuestoNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getPresupuestoNotaModificatoria(periodo, unidadOperativa, request.getParameter("tipoNota"), request.getParameter("tipo")));
                break;
            case "resolucionNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getResolucionNotaModificatoria(periodo, unidadOperativa, request.getParameter("tipoNota"), request.getParameter("tipo"), presupuesto));
                break;
            case "tipoCalendarioNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getTipoCalendarioNotaModificatoria(periodo, unidadOperativa, request.getParameter("tipoNota"), request.getParameter("tipo"), presupuesto,
                        resolucion));
                break;
            case "dependenciaNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getDependenciaNotaModificatoria(periodo, unidadOperativa, request.getParameter("tipoNota"), request.getParameter("tipo"), presupuesto,
                        resolucion, request.getParameter("tipoCalendario")));
                break;
            case "secuenciaFuncionalNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getSecuenciaFuncionalNotaModificatoria(periodo, unidadOperativa, request.getParameter("tipoNota"), request.getParameter("tipo"), presupuesto,
                        resolucion, request.getParameter("tipoCalendario"), request.getParameter("dependencia")));
                break;
            case "tareaNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getTareaNotaModificatoria(periodo, unidadOperativa, request.getParameter("tipoNota"), request.getParameter("tipo"), presupuesto,
                        resolucion, request.getParameter("tipoCalendario"), request.getParameter("dependencia"), request.getParameter("secuenciaFuncional")));
                break;
            case "cadenaGastoNotaModificatoria":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGastoNotaModificatoria(periodo, unidadOperativa, request.getParameter("tipoNota"), request.getParameter("tipo"), presupuesto,
                        resolucion, request.getParameter("tipoCalendario"), request.getParameter("dependencia"), request.getParameter("secuenciaFuncional"), request.getParameter("tarea")));
                break;
            //EJECUCION PRESUPUESTAL - NOTA MODIFICATORIA
            case "entidadSolicitante":
                request.setAttribute("objCombosAjax", objDsCombos.getEntidadSolicitante());
                break;
            case "informeResolucionCargo":
                request.setAttribute("objCombosAjax", objDsCombos.getInformeResolucionCargo(periodo, presupuesto, unidadOperativa));
                break;
            case "informeDependenciaCargo":
                request.setAttribute("objCombosAjax", objDsCombos.getInformeDependenciaCargo(periodo, presupuesto, unidadOperativa, resolucion));
                break;
            case "informeSecuenciaFuncionalCargo":
                request.setAttribute("objCombosAjax", objDsCombos.getInformeSecuenciaFuncionalCargo(periodo, presupuesto, unidadOperativa, resolucion, request.getParameter("dependencia")));
                break;
            case "informeTareaCargo":
                request.setAttribute("objCombosAjax", objDsCombos.getInformeTareaCargo(periodo, presupuesto, unidadOperativa, resolucion, request.getParameter("dependencia"),
                        request.getParameter("secuenciaFuncional")));
                break;
            case "informeCadenaGastoCargo":
                request.setAttribute("objCombosAjax", objDsCombos.getInformeCadenaGastoCargo(periodo, presupuesto, unidadOperativa, resolucion, request.getParameter("dependencia"),
                        request.getParameter("secuenciaFuncional"), request.getParameter("tarea")));
                break;
            //EJECUCION PRESUPUESTAL - ACTIVIDAD - TAREA PRESUPUESTAL    
            case "categoriaPresupuestalEjecucion":
                request.setAttribute("objCombosAjax", objDsCombos.getCategoriaPresupuestalEjecucion(periodo));
                break;
            case "productoTareaEjecucion":
                request.setAttribute("objCombosAjax", objDsCombos.getProductoEjecucion(periodo, codigo));
                break;
            case "actividadTareaEjecucion":
                request.setAttribute("objCombosAjax", objDsCombos.getActividadEjecucion(periodo, request.getParameter("categoriaPresupuestal"), request.getParameter("producto")));
                break;
            case "finalidadTareaEjecucion":
                request.setAttribute("objCombosAjax", objDsCombos.getFinalidadEjecucion(periodo, request.getParameter("categoriaPresupuestal"), request.getParameter("producto"), codigo));
                break;
            //PROGRAMACION PRESUPUESTAL
            case "dependenciaFuerzaOperativa":
                request.setAttribute("objCombosAjax", objDsCombos.getDependenciaFuerzaOperativa(periodo, presupuesto, unidadOperativa));
                break;
            case "cadenaGasto":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGasto());
                break;
            case "itemCadenaGasto":
                request.setAttribute("objCombosAjax", objDsCombos.getItemCadenaGasto(codigo));
                break;
            case "cadenaGastoTarea":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGastoTarea(periodo, request.getParameter("tarea")));
                break;
            case "cadenaGastoMutianual":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGastoTarea(periodo, request.getParameter("tarea")));
                break;
            case "cadenaIngreso":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaIngreso());
                break;
            case "cadenaIngresoEstimacionUnidad":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaIngresoEstimacion(periodo, unidadOperativa, presupuesto));
                break;
            case "cadenaFuncionalProgramacion":
                request.setAttribute("objCombosAjax", objDsCombos.getSecuenciaFuncionalProgramacion(periodo, presupuesto, request.getParameter("tarea")));
                break;
            case "dependenciaProgramacionMultianual":
                request.setAttribute("objCombosAjax", objDsCombos.getDependenciaProgramacionMultianual(periodo, presupuesto, unidadOperativa, request.getParameter("tarea")));
                break;
            //ACTIVIDAD - TAREA
            case "categoriaPresupuestalTarea":
                request.setAttribute("objCombosAjax", objDsCombos.getCategoriaPresupuestalProgramacion(periodo));
                break;
            case "productoTarea":
                request.setAttribute("objCombosAjax", objDsCombos.getProductoProgramacion(periodo, codigo));
                break;
            case "actividadTarea":
                request.setAttribute("objCombosAjax", objDsCombos.getActividadProgramacion(periodo, request.getParameter("categoriaPresupuestal"), request.getParameter("producto")));
                break;
            case "finalidadTarea":
                request.setAttribute("objCombosAjax", objDsCombos.getFinalidadProgramacion(periodo, request.getParameter("categoriaPresupuestal"), request.getParameter("producto"), codigo));
                break;
            case "actividadUbigeo":
                request.setAttribute("objCombosAjax", objDsCombos.getActividadUbigeo(periodo, request.getParameter("categoriaPresupuestal"), request.getParameter("producto"), codigo));
                break;
            case "cadenaGastoPers":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGastoPerS(periodo));
                break;
            case "tareaPers":
                request.setAttribute("objCombosAjax", objDsCombos.getTareaPersonal(periodo, codigo));
                break;
            case "nivelPersonal":
                request.setAttribute("objCombosAjax", objDsCombos.getNivelGradoPersonal(periodo, unidadOperativa));
                break;
            case "gradoPersonal":
                request.setAttribute("objCombosAjax", objDsCombos.getGradoPersonal(periodo, unidadOperativa, request.getParameter("codigo")));
                break;
            case "periodoREE":
                request.setAttribute("objCombosAjax", objDsCombos.getperiodoReePersonal(periodo, unidadOperativa, request.getParameter("resolucion"), request.getParameter("dependencia")));
                break;
            case "unidadFuerza":
                request.setAttribute("objCombosAjax", objDsCombos.getDependenciaFuerzaOperativa(periodo, unidadOperativa));
                break;
            case "cadGasHoraVuelo":
                request.setAttribute("objCombosAjax", objDsCombos.getCadenaGastoHorasVuelo());
                break;
            case "tareaHoraVuelo":
                request.setAttribute("objCombosAjax", objDsCombos.getListaTareaHorasVuelo(periodo));
                break;
            //MESA DE PARTES
            case "usuarioMesaParte":
                request.setAttribute("objCombosAjax", objDsCombos.getUsuarioMesaPartes(codigo));
                break;
            case "referenciaDoc":
                request.setAttribute("objCombosAjax", objDsCombos.getDocumentoReferencia(periodo, unidadOperativa, codigo));
                break;
            case "usuarioSubDecreto":
                request.setAttribute("objCombosAjax", objDsCombos.getUsuarioSubDecreto(codigo, objUsuario.getUsuario()));
                break;
            case "genericaUnidad":
                request.setAttribute("objCombosAjax", objDsCombos.getGenericaGastoUnidad(periodo, presupuesto, unidadOperativa));
                break;
            //LOGISTICA
            case "tipoProcesoContratacion":
                request.setAttribute("objCombosAjax", objDsCombos.getTipoProcesoContratacion());
                break;
            case "procesoEtapa":
                request.setAttribute("objCombosAjax", objDsCombos.getProcesoEtapa(Utiles.Utiles.checkNum(codigo)));
                break;
            case "procesoDocumento":
                request.setAttribute("objCombosAjax", objDsCombos.getProcesoDocumento());
                break;
            case "tipoProcedimiento":
                request.setAttribute("objCombosAjax", objDsCombos.getTipoProcedimiento());
                break;
            case "tipoProcedimientoTipoDocumento":
                request.setAttribute("objCombosAjax", objDsCombos.getTipoProcedimientoTipoDocumento(codigo));
                break;
            case "compromisoAnualCertificado":
                request.setAttribute("objCombosAjax", objDsCombos.getCompromisoAnualCertificado(periodo, presupuesto, unidadOperativa, codigo));
                break;
            default:
        }
        dispatcher = request.getRequestDispatcher("Comun/CombosAjax.jsp");
        dispatcher.forward(request, response);
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
