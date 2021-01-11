<%-- 
    Document   : ListaAvanceEjecutora
    Created on : 21/12/2020, 03:37:37 PM
    Author     : helme
--%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title id='Description'>JavaScript Chart 100% Stacked Column Series Example</title>
        <meta name="description" content="This is an example of JavaScript Chart 100% Stacked Column Series." />		
        <link rel="stylesheet" href="../../jqwidgets/styles/jqx.base.css" type="text/css" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <meta name="viewport" content="width=device-width, initial-scale=1 maximum-scale=1 minimum-scale=1" />	
        <script type="text/javascript" src="../../scripts/jquery-1.11.1.min.js"></script>
        <script type="text/javascript" src="../../jqwidgets/jqxcore.js"></script>
        <script type="text/javascript" src="../../jqwidgets/jqxdata.js"></script>
        <script type="text/javascript" src="../../jqwidgets/jqxdraw.js"></script>
        <script type="text/javascript" src="../../jqwidgets/jqxchart.core.js"></script>
        <script type="text/javascript" src="../../scripts/demos.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                // prepare chart data as an array
                var sampleData = [
                    {Ejecutora: 'MINDEF', Devengado: 68604702, Saldo: 7890631, Avance: 95, Pendiente: 5},
                    {Ejecutora: 'CCFFAA', Devengado: 72343593, Saldo: 9751991, Avance: 51, Pendiente: 49},
                    {Ejecutora: 'EJERCITO PERUANO', Devengado: 2695168816, Saldo: 75162003, Avance: 61, Pendiente: 39},
                    {Ejecutora: 'MGP', Devengado: 2246922917, Saldo: 99928105, Avance: 64, Pendiente: 36},
                    {Ejecutora: 'FAP', Devengado: 1636664848, Saldo: 39604414, Avance: 95, Pendiente: 5},
                    {Ejecutora: 'CONIDA', Devengado: 11530796, Saldo: 80505, Avance: 98, Pendiente: 2},
                    {Ejecutora: 'ENAMM', Devengado: 7588614, Saldo: 3602105, Avance: 100, Pendiente: 0},
                    {Ejecutora: 'OPREFA', Devengado: 2144617866, Saldo: 265642, Avance: 55, Pendiente: 45}
                ];
                // prepare jqxChart settings
                var settings = {
                    title: "Avance por Ejecutora",
                    description: " ",
                    showLegend: true,
                    enableAnimations: true,
                    padding: {left: 20, top: 5, right: 20, bottom: 5},
                    titlePadding: {left: 90, top: 0, right: 0, bottom: 10},
                    source: sampleData,
                    xAxis: {
                        dataField: 'Ejecutora',
                        flip: false,
                        tickMarks: {
                            visible: true,
                            interval: 1,
                            color: '#BCBCBC'
                        },
                        gridLines: {
                            visible: true,
                            interval: 1,
                            color: '#BCBCBC'
                        },
                        axisSize: 'auto',
                        position: 'top',
                        labels: {
                            angle: 55,
                            horizontalAlignment: 'right',
                            verticalAlignment: 'center',
                            rotationPoint: 'right',
                            offset: {x: 0, y: -5}
                        }
                    },
                    valueAxis: {
                        flip: true,
                        unitInterval: 20,
                        title: {text: ' '},
                        tickMarks: {color: '#BCBCBC'},
                        gridLines: {color: '#BCBCBC'},
                        labels: {
                            horizontalAlignment: 'right',
                            formatSettings: {sufix: '%'}
                        }
                    },
                    colorScheme: 'scheme01',
                    seriesGroups:
                            [
                                {
                                    type: 'stackedcolumn100',
                                    orientation: 'horizontal',
                                    columnsGapPercent: 50,
                                    toolTipFormatFunction: function (value, itemIndex, serie, group, xAxisValue, xAxis) {
                                         var formattedTooltip = "<div>" +
                                                "<b>Ejecutora: </b>" + xAxisValue + "</br>" +
                                                "<b>Serie: </b>" + serie.displayText  + "</br>" +
                                                "<b>Avance: </b>" + value + "%</br>" +
                                                "</div>";
                                        return formattedTooltip;
                                    },
                                    series: [
                                        {dataField: 'Avance', displayText: 'Devengado', showLabels: function(){
                                                var formattedTooltip = "<div>" +
                                                "<b>Ejecutora: </b>" +  + "</br>" +
                                                "<b>Avance: </b>" + this.value + "%</br>" +
                                                "</div>";
                                        return formattedTooltip;
                                        }, lineColor: '#262F13', lineColorSelected: '#2EE2EE', fillColor: '#5A702E'},
                                        {dataField: 'Pendiente', displayText: 'Sin Devengar', showLabels: true, lineColor: '#E10101', lineColorSelected: '#2EE2EE', fillColor: '#FF0000'}
                                    ]
                                }
                            ]
                };
                // setup the chart
                $('#chartContainer').jqxChart(settings);
            });
        </script>
    </head>
    <body class='default'>
        <div id='chartContainer' style="width:100%; height:650px"></div>
    </body>
</html>
