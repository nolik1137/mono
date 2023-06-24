<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Fi.ru </title>
  <link rel="stylesheet" href="css/styles.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@200;800&display=swap" rel="stylesheet">
</head>
<?php
session_start();
if(!$_SESSION['user']){
  header('Location:index.php');
}

?>
<body>
  <header>
    <div class="site-icon">
      <a href="index.php"><img src="Сайт значки/Значок.png" alt=""></a>
    </div>
    <div class="search-container">
      <input type="text" placeholder="Я ищу..." />
    </div>
    <div class="auth-container">
        <div class="profile_log">
            <img src="<?=$_SESSION['user']['avatar'] ?>" width="75px" alt="">
            <h2><?=$_SESSION['user']['full_name'] ?></h2>
            <a href=""><?=$_SESSION['user']['email'] ?></a>
        </div>
        <div class="auth-links">
            <button id="profileLink" class="link-button">
                <a href="profile.php" target="_blank">Профиль</a>
            </button>
            <button id="registerLink" class="link-button">Регистрация</button>
            <form action="logout.php" target="_blank">
  <button class="login-link" type="submit">Выход</button>
</form>


      <div id="registrationFormOverlay">
        <div id="registrationForm">
          <form action="reg/signup.php" name="main-form" id="main-form" method="POST" enctype="multipart/form-data">
            <div class="form-input">
              <input title="Только кириллица." required pattern="^[А-Яа-яЁё\s]+$" type="text" name="full_name" placeholder="Имя" id="name" class="form-control">
            </div>
            <div class="form-input">
              <input  type="password" title="Не менее шести латинских букв и три цифры" name="password" placeholder="Пароль" id="pass">
            </div>
            <div class="form-input">
              <input name="login" type="text" value="" placeholder="Логин" id="login">
            </div>
            <div class="form-input">
              <input required title="Ваш номер телефона" pattern="[0-9]{9,12}" type="text" name="phone" placeholder="Номер телефона" id="phone">
            </div>
            <div class="form-input">
              <input title="Только Латиница" pattern="([A-z0-9_.-]{1,})@([A-z0-9_.-]{1,}).([A-z]{2,8})" placeholder="fi@****.com" name="email" id="email" type="text">
            </div>
            <div class="form-input">
              <input name="avatar" type="file" value="" id="avatar">
            </div>
            <div class="form-input" id="text-consent">
              Согласие на обработку персональных данных:
              <input type="checkbox" name="terms" checked>
            </div>
            
            <div class="form-input">
              <span id="error" style="color:red"></span>
              <button type="submit" name="submit" class="btn btn-default custom-button">Зарегистрироваться</button>
              <?php
                  if($_SESSION['message']){
                    echo '<p class="msg"> '.$_SESSION['message'] . '</p>';
                  }
                  
                  unset($_SESSION['message']);
                  ?>
              
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
    </div>
  </header>
  <nav>
    <ul class="menu">
      <li><a href="index.php?C=6"><img src="Сайт значки/Меню.png" alt=""></a></li>
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
                case "6": echo(file_get_contents("objects6.html"));break;
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