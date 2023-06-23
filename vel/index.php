<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Fi.ru </title>
  <link rel="stylesheet" href="css/styles.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@200;800&display=swap" rel="stylesheet">
</head>
<body>
  <header>
    <div class="site-icon">
      <a href="index.php"><img src="Сайт значки/Значок.png" alt=""></a>
    </div>
    <div class="search-container">
      <input type="text" placeholder="Я ищу..." />
    </div>
    <div class="auth-links">
      <a href="#" id="registerLink">Регистрация</a>
      <div id="registrationFormOverlay">
        <div id="registrationForm">
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
            <div class="text-consent">
                Согласие на обработку персональных данных:
                <input type="checkbox" name="terms" checked> 
            </div>                  
            <div class="form-input">
                <span id="error" style="color:red"></span>
            <input type="submit" name="submit" class="btn btn-default" value="Зарегистрироваться">
            </div>
        </div>
      </div>
      <a href="#" class="loginLink"  id="loginLink">Вход</a>
<div id="loginFormOverlay" class="loginFormOverlay">
  <div id="loginForm" class="loginForm">
    <form>
      <h3 class="text-center">Вход</h3>
      <div class="form-group">
        <input class="login-name" type="text" name="username" maxlength="15" minlength="4" pattern="^[a-zA-Z0-9_.-]*$" id="username" placeholder="Логин" required>
      </div>
      <div class="form-group">
        <input class="login-password" type="password" name="Пароль" minlength="6" id="password" placeholder="Пароль" required>
      </div>
      <div class="form-group">
        <button class="button-login" type="submit">Вход в аккаунт</button>
      </div>
    </form>
  </div>
</div>
       
    </div>
  </div>
</div>
        </div>
      </div>
    </div>
  </header>
  <nav>
    <ul class="menu">
      <li><a href="index.php?C=1"><img src="Сайт значки/Меню.png" alt=""></a></li>
      <li><a href="index.php?C=1">Велосипеды</a></li>
      <li><a href="index.php?C=2">Аксессуары</a></li>
      <li><a href="index.php?C=3">Запчасти</a></li>
      <li><a href="index.php?C=4">Самокаты</a></li>
      <li><a href="index.php?C=5">Экипировка</a></li>
    </ul>
  </nav>
  
  <main>
    
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
              }
          ?>
      </div>
      <div id="content" class="content">
            <?php
            $O=$_GET["O"];
            switch($O){
                case "1-1":echo(file_get_contents("object1-1.html"));break;
                case "1-2":echo(file_get_contents('object1-2.html'));break;
                case "1-3":echo(file_get_contents('object1-3.html'));break;
                }
            ?>
        </div>
    </div> 
  </main>
  <footer>
    <span>©Fi.ru 2022</span>
    <div class="social-links">
      Мы в социальных сетях:
      <a href="#">
        <img src="Сайт значки/youtube.png" alt="Social Icon">
        YouTube
      </a>
      <a href="#">
        <img src="Сайт значки/twitter.png" alt="Social Icon">
        Twitter
      </a>
      <a href="#">
        <img src="Сайт значки/facebook.png" alt="Social Icon">
        Facebook
      </a>
    </div>
  </footer>
  <script src="java/java.js"></script>
</body>
</html>