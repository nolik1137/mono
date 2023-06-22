<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Регистрация</title>
    <link rel="stylesheet" href="css/reg2.css" id="theme">
    <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@200;800&display=swap" rel="stylesheet">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="poisk">
                <div class="znch">
                    <a href="index.php">
                        <img src="Сайт значки/Значок.png" alt="">
                    </a>
                </div>
                <div class="search">
                    <form class="search1">
                        <input type="text" class="search1">
                    </form>
                    <a href="#" class="searchp">
                        <img src="Сайт значки/search.png" alt="">
                    </a>
                <div>
                    <a href="#" class="vhod">
                        Вход
                    </a>
                    <a href="reg.php" class="reg">
                        Регистрация 
                    </a>
                </div>
                </div>
               
                <div class="shop">
                    <a href="#">
                        <img src="Сайт значки/shopping-bag.png" alt="">
                    </a>
                </div>
                <div class="heart">
                   <a href="#">
                        <img src="Сайт значки/heart.png" alt="">
                    </a>
                </div>
            </div>
        </div>
    </header>
    <section class="section">
        <div class="container">
            <div class="aks">
                <ul class="menu">
                    <li>
                        <a href="" class="zmenu">
                            <img src="Сайт значки/Меню.png">
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            Аксессуары
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            Запчасти
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            Веломастерская
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            Самокаты
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            Экипировка
                        </a>
                    </li>
                </ul>                
            </div>
            <div class="form">
                <form  action="final.php" name="main-form" id="main-form" method="post">
                    <div class="form-input">
                        <input  title="Только кириллица." required pattern="^[А-Яа-яЁё\s]+$" type="text" name="name" placeholder="Имя" id="name" class="form-control">
                    </div>
                    <div class="form-input">
                        <input  required  pattern="[A-Za-z]{6,}[0-9]{3}"  type="password" title="Не менее шести латинских букв и три цифры"  name="pass" placeholder="Пароль" id="pass" > 
                    </div>
                    <div class="form-input">
                        <input required title="Ваш номер телефона" pattern="[0-9]{9,12}"  type="text" name="phone" placeholder="Номер телефона" id="phone">
                    </div>
                    <div class="form-input">
                        <input title="Только Латиница" pattern="([A-z0-9_.-]{1,})@([A-z0-9_.-]{1,}).([A-z]{2,8})" placeholder="fi@****.com" name="email" id="email" type="text"> 
                    </div>
                    <div class="form-input">
                        <input name="age" type="number" value="" placeholder="Возраст"> 
                    </div>
                    <div>
                        Согласие на обработку персональных данных
                        <input type="checkbox" name="terms" checked> 
                    </div>                  
                    <div class="form-input">
                        <span id="error" style="color:red"></span>
                    <input type="submit" name="submit" class="btn btn-default" value="Зарегистрироваться">
                    </div>
                    
                </form>         
            </div>
           

    </section>
    <footer class="footer">
        <div class="container">
            <div class="niz">
                <div class="soci">
                    <div class="textsoci">
                        Мы в социальных сетях:
                    </div>
                    <div class="znsoci">
                        <div class="facb">
                            <a href="">
                                <img src="Сайт значки/facebook.png" class="imgfacb">
                            </a>
                            
                        </div>
                        <div class="ytb">
                            <a href="">
                                <img src="Сайт значки/youtube.png" class="imgytb">
                            </a>
                        </div>
                        <div class="twit">
                            <a href="">
                                <img src="Сайт значки/twitter.png" class="imgtwit">
                            </a>
                            
                        </div>
                    </div>
                </div>
                <div class="stobr">
                    ©Fi.ru 2022
                </div>
            </div>
                
        </div>
    </footer>
    <script src="Java/java reg.js"></script>
</body>
</html>