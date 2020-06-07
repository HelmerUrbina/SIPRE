<%-- 
    Document   : ListaReportesEvaluacion
    Created on : 18/04/2018, 08:30:46 AM
    Author     : H-URBINA-M
--%>

<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var programa = $("#cbo_Programa").val();
    var reporte = null;
    var codigo = null;
    $(document).ready(function () {
        var source = [
            {id: "EVA0001", label: "1. Ejecución Mensual de Egresos"},
            {id: "EVA0002", label: "2. Listado de RA's Emitidas"},
            {id: "EVA0003", label: "3. PIA - Metas Fisicas"},
            {id: "EVA0004", label: "4. PIM - Metas Fisicas"}
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
            case "EVA0001":
                break;
            case "EVA0002":
                break;
            case "EVA0003":
                msg = fn_validaCombos('#cbo_Programa', "Seleccione el Programa.");
                codigo = ($("#cbo_Programa").jqxComboBox('getSelectedItem')).label;
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "EVA0004":
                msg = fn_validaCombos('#cbo_Programa', "Seleccione el Programa.");
                codigo = ($("#cbo_Programa").jqxComboBox('getSelectedItem')).label;
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            default:
                msg = "Debe selecciona una opción";
                break;
        }
        if (msg === "") {
            var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa +
                    '&presupuesto=' + presupuesto + '&codigo=' + codigo;
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