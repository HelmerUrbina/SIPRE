<%-- 
    Document   : ListaReportesEjecucion
    Created on : 26/12/2017, 09:20:49 AM
    Author     : H-URBINA-M
--%>

<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var unidad = '${unidad}';
    var reporte = null;
    var codigo = null;
    var codigo2 = null;
    $(document).ready(function () {
        var source = [
            {id: "EJE0015", label: "1. Calendario de Gastos"},
            {id: "EJE0016", label: "2. Calendario de Gastos - Dependencias"},
            {id: "EJE0017", label: "3. Listado de Notas Modificatorias"},
            {id: "EJE0018", label: "4. Avance de Ejecución Presupuestal"},
            {id: "EJE0021", label: "5. Avance de Ejecución Presupuestal - Dependencias"},
            {id: "EJE0019", label: "6. Avance de Ejecución Mensualizado"},
            {id: "EJE0041", label: "7. Avance de Ejecución Mensualizado - Dependencias"},
            {id: "EJE0020", label: "8. Avance de Certificación Presupuestal"},
            {id: "EJE0013", label: "9. Listado de Informes de Disponibilidad Presupuestal"},
            {id: "EJE0033", label: "10. Conciliación Calendario de Gastos Vs Ejecución"},
            {id: "EJE0038", label: "11. Conciliación Calendario de Gastos Vs Ejecución - Dependencias"},
            {id: "EJE0034", label: "12. Listado de Anexos Mensualizados"},
            {id: "EJE0035", label: "13. Listado de Certificados SIAF"},
            {id: "EJE0036", label: "14. Avance Presupuestal PIM Vs. Devengado"},
            {id: "EJE0037", label: "15. Listado de Compromisos Anuales"},
            {id: "EJE0040", label: "16. Avance Ejecución Presupuestal - VRAEM"},
            {id: "EJE0030", label: "17. Listado de Registros "},
            {id: "EJE0045", label: "18. Avance de Ejecución Presupuestal - PIA -PIM"},
            {id: "EJE0047", label: "19. Avance Ejecución Presupuestal - VRAEM"}
        ];
        $('#div_Principal').jqxExpander({showArrow: false, toggleMode: 'none', width: ($(window).width() - 50), height: ($(window).height() - 110)});
        $('#div_Reporte').jqxTree({source: source});
        $('#div_Reporte').on('select', function (event) {
            var args = event.args;
            var item = $('#div_Reporte').jqxTree('getItem', args.element);
            reporte = item.id;
        });
    });

    function fn_CargarReporte() {
        var msg = "";
        switch (reporte) {
            case "EJE0013":
                break;
            case "EJE0015":
                break;
            case "EJE0016":
                break;
            case "EJE0017":
                break;
            case "EJE0018":
                break;
            case "EJE0019":
                break;
            case "EJE0020":
                break;
            case "EJE0021":
                break;
            case "EJE0030":
                codigo = $("#div_Fecha").val();
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "EJE0033":
                codigo = $("#cbo_MesInicial").val();
                codigo2 = $("#cbo_MesFinal").val();
                break;
            case "EJE0034":
                break;
            case "EJE0035":
                break;
            case "EJE0036":
                break;
            case "EJE0037":
                break;
            case "EJE0040":
                break;
            case "EJE0038":
                codigo = $("#cbo_MesInicial").val();
                codigo2 = $("#cbo_MesFinal").val();
                break;
            case "PROG0010":
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "EJE0041":
                break;
            case "EJE0045":
                break;
            case "EJE0047":
                if (autorizacion === 'false')
                    if (unidad !== "0870")
                        msg = "Usuario no Autorizado.";
                break;
            default:
                msg = "Debe selecciona una opción";
                break;
        }
        if (msg === "") {
            var url = '../Reportes?reporte=' + reporte + '&periodo=' + $("#cbo_Periodo").val() + '&unidadOperativa=' + $("#cbo_UnidadOperativa").val() +
                    '&presupuesto=' + $("#cbo_Presupuesto").val() + '&codigo=' + codigo + '&codigo2=' + codigo2 + '&generica=' + $("#cbo_Generica").val();
            window.open(url, '_blank');
        } else {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: msg,
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'red',
                typeAnimated: true
            });
        }
    }
</script>
<div id='div_Principal' style="margin: 15px">
    <div>
        <div> LISTADO DE REPORTES - <a href="javascript: fn_CargarReporte();" ><img src="../Imagenes/Botones/printer42.gif" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a> </div>
    </div>
    <div style="overflow: hidden;">
        <div style="border: none;" id='div_Reporte'>
        </div>
    </div>
</div>