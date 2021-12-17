$("#formLogin").on("click", "#login_btn", function () {
    var email = $("#email").val();
    var password = $('#password').val();
    if (email != '' && password != '') {
        $.ajax({
            url:"/login",
            method: "POST",
            data: {email:email, password:password},
            success:function(data){
                window.location.reload();
            },
        });
    };

});