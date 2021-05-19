/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function digiClock() {
    var vDate = new Date();
    var vHora = vDate.getHours();
    var vMin = vDate.getMinutes();
    var vSeg = vDate.getSeconds();
    vMin = (vMin < 10 ? "0" : "") + vMin;
    vSeg = (vSeg < 10 ? "0" : "") + vSeg;
    var vAMPM = (vHora < 12) ? "AM" : "PM";
    vHora = (vHora < 10 ? "0" : "") + vHora;
    var vHoraSistema = vHora + ":" + vMin + ":" + vSeg + " " + vAMPM;
    $("#clock").html(vHoraSistema);
}

$(document).ready(function () {
    setInterval("digiClock()", 1000);
});