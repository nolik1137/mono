<?php
require_once 'connect.php';
session_start();
$full_name=$_POST['full_name'];
$login=$_POST['login'];
$email=$_POST['email'];
$password=$_POST['password'];
$phone=$_POST['phone'];
$terms=$_POST['terms'];
$patch='uploads/'.time().$_FILES['avatar']['name'];

if(!move_uploaded_file($_FILES['avatar']['tmp_name'],'../'.$patch)){
   $_SESSION['message'] ='Ошибка при загрузке файла.';
   header('Location:../index.php');
}

mysqli_query($connect,"INSERT INTO `users` (`full_name`, `password`, `login`, `phone`, `email`, `avatar`, `approval`, `id`) VALUES ('$full_name', '$password', '$login', '$phone', '$email', '$patch', '$terms', NULL) ");
header('Location:../index.php');


?>



 

