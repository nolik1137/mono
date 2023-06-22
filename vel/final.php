<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    
</body>
</html>
<?php
$name ="Не известно";
$pass ="Не известно";
$age ="Не известно";
$email ="Не известно";
$sogl ="Не известно";
$phone ="Не известно";
if(isset($_POST['age'])) $age = $_POST['age'];
if(isset($_POST['phone'])) $phone = $_POST['phone'];
if(isset($_POST['email'])) $email = $_POST['email'];
if(isset($_POST['terms'])) $sogl = $_POST['terms'];
if(isset($_POST['name'])) $name = $_POST['name'];
if (isset($_POST['pass'])) $pass = $_POST['pass'];
echo "Ваше имя: $name <br> Ваш пароль: $pass <br>";
echo "Ваш возраст: $age <br> Ваша электронная почта: $email <br>";
echo "Согласие на обработку перс. данных: $sogl <br> Ваш телефон: $phone";
?>
