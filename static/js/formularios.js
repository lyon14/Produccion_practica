$("#solicitarPractica").on("click", "#solicitarPractica_btn", function () {
    var carrera = $("#carrera").val();
    var tipo_practica = $("#tipo_practica").val();
    var nombre_Empresa = $("#nombre_Empresa").val();
    var destinatario = $("#destinatario").val();
    var cargo_destinatario = $("#cargo_destinatario").val();
    var telefono_destinatario = $("#telefono_destinatario").val();
    var email_destinatario = $("#email_destinatario").val();
    var id_usuario = $("#id_usuario").val();
    var nombre_alumno = $("#nombre_alumno").val();
    var telefono_alumno = $("#telefono_alumno").val();
    var email_alumno = $("#email_alumno").val();
    var rut_alumno = $("#rut_alumno").val();


    $.ajax({
        url: "/solicitarPractica",
        method: "POST",
        data: {
            carrera: carrera,
            tipo_practica: tipo_practica,
            nombre_Empresa: nombre_Empresa,
            destinatario: destinatario,
            cargo_destinatario: cargo_destinatario,
            telefono_destinatario: telefono_destinatario,
            email_destinatario: email_destinatario,
            id_usuario: id_usuario,
            nombre_alumno: nombre_alumno,
            telefono_alumno: telefono_alumno,
            email_alumno: email_alumno,
            rut_alumno: rut_alumno

        },
        success: function (data) {
            window.location.reload();
        },
    });

});

$(".tablaSolicitudesPracticante tbody").on("click", "#GenerarDoc_btn", function () {
    var id_solicitud = $(this).attr("id_solicitud");
    //console.log(id_solicitud);

    $.ajax({
        url: "/generarEstadoSolPracticante",
        method: "POST",
        data: {
            id_solicitud: id_solicitud
        },
        success: function (data) {
            //id_solicitud
            //console.log(data[0][0])
            
            //json
            //console.log(data[0][3]);
            $("#myModal_solDePracticante_informatica .id_solicitud").val(data[0][0]);
            $("#myModal_solDePracticante_informatica .nombre_empresa").val(data[0][3]['nombre_Empresa']);
            $("#myModal_solDePracticante_informatica .destinatario").val(data[0][3]['destinatario']);
            $("#myModal_solDePracticante_informatica .cargo_destinatario").val(data[0][3]['cargo_destinatario']);
            $("#myModal_solDePracticante_informatica .telefono_destinatario").val(data[0][3]['telefono_destinatario']);
            $("#myModal_solDePracticante_informatica .email_destinatario").val(data[0][3]['email_destinatario']);
            $("#myModal_solDePracticante_informatica .nombre_alumno").val(data[0][3]['nombre_alumno']);
            $("#myModal_solDePracticante_informatica .rut_alumno").val(data[0][3]['rut_alumno']);
            $("#myModal_solDePracticante_informatica .telefono_alumno").val(data[0][3]['telefono_alumno']);
            $("#myModal_solDePracticante_informatica .email_alumno").val(data[0][3]['email_alumno']);
            
        },
    });
});

$("#solicitud_practicante").on("click", "#btn_aprobar_solicitud", function(){
    var id_solicitud = $("#id_solicitud").val();
    var estado = $("#btn_aprobar_solicitud").val();

    $.ajax({
        url: "/actualizarEstadoSolPracticante",
        method: "POST",
        data: {
            id_solicitud: id_solicitud,
            estado: estado
        },
        success: function (data){
            window.location.reload();
        },
    });

});

$("#solicitud_practicante").on("click", "#btn_rechazar_solicitud", function(){
    var id_solicitud = $("#id_solicitud").val();
    var estado = $("#btn_rechazar_solicitud").val();

    $.ajax({
        url: "/actualizarEstadoSolPracticante",
        method: "POST",
        data: {
            id_solicitud: id_solicitud,
            estado: estado
        },
        success: function (data){
            window.location.reload();
        },
    });

});