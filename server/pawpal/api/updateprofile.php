<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode([
        'status' => 'failed',
        'message' => 'Method Not Allowed'
    ]);
    exit();
}

// ---------- Get POST data ----------
$userid = $_POST['user_id'] ?? '';
$name   = addslashes($_POST['name'] ?? '');
$phone  = addslashes($_POST['phone'] ?? '');
$image  = $_POST['image'] ?? ''; // 🔥 BASE64 IMAGE

if (empty($userid) || empty($name) || empty($phone)) {
    sendJsonResponse([
        'status' => 'failed',
        'message' => 'Missing required fields'
    ]);
    exit();
}

// ---------- SQL UPDATE ----------
if (!empty($image)) {
    // Update with image
    $sqlupdateprofile = "
        UPDATE tbl_users 
        SET name = '$name',
            phone = '$phone',
            image = '$image'
        WHERE user_id = '$userid'
    ";
} else {
    // Update without image
    $sqlupdateprofile = "
        UPDATE tbl_users 
        SET name = '$name',
            phone = '$phone'
        WHERE user_id = '$userid'
    ";
}

try {
    if ($conn->query($sqlupdateprofile) === TRUE) {
        sendJsonResponse([
            'status' => 'success',
            'message' => 'Profile updated successfully'
        ]);
    } else {
        sendJsonResponse([
            'status' => 'failed',
            'message' => 'Profile update failed'
        ]);
    }
} catch (Exception $e) {
    sendJsonResponse([
        'status' => 'failed',
        'message' => $e->getMessage()
    ]);
}

// ---------- JSON response ----------
function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
?>
