<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
    exit();
}

$userid      = $_POST['userid'];
$pet_name    = addslashes($_POST['pet_name']);
$pet_type    = $_POST['pet_type'];
$category    = $_POST['category'];
$description = addslashes($_POST['description']);
$lat         = $_POST['lat'];
$lng         = $_POST['lng'];

// Decode array of base64 images
$image_list = json_decode($_POST['image_list'], true);

if (!is_array($image_list) || count($image_list) == 0) {
    sendResponse(['status' => 'failed', 'message' => 'No images received']);
    exit();
}

// Insert the pet WITHOUT image_paths first
$sqlinsert = "INSERT INTO tbl_pets(user_id, pet_name, pet_type, category, description, lat, lng)
              VALUES ('$userid', '$pet_name', '$pet_type', '$category', '$description', '$lat', '$lng')";

if ($conn->query($sqlinsert) === TRUE) {

    $pet_id = $conn->insert_id;  // NEW pet ID
    $saved_paths = [];

    // Save each image
    foreach ($image_list as $index => $imgBase64) {

        $decoded = base64_decode($imgBase64);

        // Save under /assets/pets/
        $relative_path = "assets/pets/pet_" . $pet_id . "_" . $index . ".png";
        $server_path   = "../" . $relative_path;

        file_put_contents($server_path, $decoded);

        // Add to array for JSON
        $saved_paths[] = $relative_path;
    }

    // Convert array → JSON string
    $json_paths = json_encode($saved_paths);

    // Update the DB with JSON
    $sqlupdate = "UPDATE tbl_pets SET image_paths='$json_paths' WHERE pet_id='$pet_id'";

    if (!$conn->query($sqlupdate)) {
        sendResponse(['status' => 'failed', 'message' => $conn->error]);
    }

    sendResponse([
        'status' => 'success',
        'message' => 'Pet submitted successfully',
        'pet_id' => $pet_id,
        'image_paths' => $saved_paths
    ]);

} else {
    sendResponse(['status' => 'failed', 'message' => 'Insert failed']);
}

// Send JSON helper
function sendResponse($data) {
    header('Content-Type: application/json');
    echo json_encode($data);
    exit();
}
?>
