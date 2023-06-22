<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fi.ru</title>
    <link rel="stylesheet" href="css/tr1.css" id="theme">
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
                <div >
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
            <div class="aks" id="aks">
                <ul class="menu" id="menu">
                    <li>
                        <a href="index.php?C=1" class="zmenu">
                            <img src="Сайт значки/Меню.png">
                        </a>
                    </li>
                    <li>
                        <a href="index.php?C=2">
                            Аксессуары
                            
                            
                        </a>
                    </li>
                    <li>
                        <a href="index.php?C=3">
                            Запчасти
                        </a>
                    </li>
                    <li>
                        <a href="index.php?C=4">
                            Веломастерская
                        </a>
                    </li>
                    <li>
                        <a href="index.php?C=5">
                            Самокаты
                        </a>
                    </li>
                    <li>
                        <a href="index.php?C=6">
                            Экипировка
                        </a>
                    </li> 
                </ul>
                                 
            </div>
            
            
        </div>
    
    <div id="container" >
        <div id="objects">
            <?php
            $C=$_GET["C"];
            switch($C){
                case "1": echo(file_get_contents("objects1.html"));break;
                case "2": echo(file_get_contents("objects2.html"));break;
                case "3": echo(file_get_contents("objects3.html"));break;
                case "4": echo(file_get_contents("objects4.html"));break;
                case "5": echo(file_get_contents("objects5.html"));break;
                case "6": echo(file_get_contents("objects6.html"));break;
            
                }
            ?>
        </div>
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
    <script src="Java/java.js"></script>
</body>
</html>