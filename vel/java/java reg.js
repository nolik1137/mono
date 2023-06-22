function checkForm(el){
    var name=el.name.value;
    var name=el.pass.value;
    var name=el.repass.value;
    var name=el.state.value;
    var name=el.email.value;
    var fail="";
    if (name=="" || pass=="" || state=="" || email=="")
        fail="Заполните все поля";
    else if(name.length<=1||name.length>15)
        fail="Введите корректное имя";
    else if(pass!=repass)
        fail="Пароли должны совпадать";  
    else if(pass.split("&").length>1)
        fail="Пароль не должен содержать символы вида: &*()^%$#@!";
    else if(pass.split("*").length>1)
        fail="Пароль не должен содержать символы вида: &*()^%$#@!";
    else if(pass.split("^").length>1)
        fail="Пароль не должен содержать символы вида: &*()^%$#@!";  
    if (fail!=""){
        document.getElementById("error").innerHTML=fail;
        return false;
    }
    else{
        alert(" Все данные корректно заполенны");
        return true;
    }

    
}