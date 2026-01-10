<?php
    $servername = "localhost";
    $username = "youcapfu_pawpal_hzq";
    $password = "TH91[?u.SQ2_";
    $dbname = "youcapfu_pawpal_db_hzq";
    // $dbname = "pawpal_db";
    // $port = 3307;

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>

