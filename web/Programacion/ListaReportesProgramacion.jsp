<%-- 
    Document   : ListaReportesProgramacion
    Created on : 20/03/2017, 09:04:13 AM
    Author     : H-URBINA-M
--%>

<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = '${objBnReporte.periodo}';
    var presupuesto = '${objBnReporte.presupuesto}';
    var unidadOperativa = '${objBnReporte.unidadOperativa}';
    var reporte = null;
    if (autorizacion === 'false') {
        window.location = "../Error/PaginaMantenimiento.jsp";
    }
    $(document).ready(function () {
        var source = [
            {id: "PROG0005", label: "1. Programación Multianual de Gastos"},
            {id: "PROG0010", label: "2. Programación Multianual de Gastos - Anexo 1"},
            {id: "PROG0006", label: "3. Programación Multianual de Ingresos - Anexo 1"},
            {id: "PROG0007", label: "4. Programación Multianual de Ingresos - Anexo 2"},
            {id: "PROG0009", label: "5. Programación Multianual de Ingresos - Anexo 3"},
            {id: "PROG0008", label: "6. Meta Fisicas"},
            {id: "PROG0004", label: "7. Metas Fisicas - Anexo 1"},
            {id: "PROG0014", label: "8. Avance de Ejecucion Presupuestal"},
            {id: "PROG0015", label: "9. Variacion PIA - PIM"}
        ];
        $('#div_Principal').jqxExpander({showArrow: false, toggleMode: 'none', width: ($(window).width() - 80), height: ($(window).height() - 100)});
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
            case "PROG0004":
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "PROG0005":
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "PROG0006":
                if (presupuesto !== '6')
                    msg = "Fuente de Financiamiento incorrecto!!!";
                break;
            case "PROG0007":
                if (presupuesto !== '6')
                    msg = "Fuente de Financiamiento incorrecto!!!";
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "PROG0008":
                break;
            case "PROG0009":
                if (presupuesto !== '6')
                    msg = "Fuente de Financiamiento incorrecto!!!";
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "PROG0010":
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "PROG0014":
                break;
            case "PROG0015":
                break;
            default:
                msg = "Debe selecciona una opción";
                break;
        }
        if (msg === "") {
            var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto;
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
        <div> LISTADO DE REPORTES   - <a href="javascript: fn_CargarReporte();" ><img src="../Imagenes/Botones/printer42.gif" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a> </div>       
    </div>
    <div style="overflow: hidden;">
        <div style="border: none;" id='div_Reporte'>
        </div>
    </div>
</div>


