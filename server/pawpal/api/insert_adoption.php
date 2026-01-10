<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $user_id = $_POST['user_id'] ?? '';
    $pet_id  = $_POST['pet_id'] ?? '';
    $message = $_POST['message'] ?? '';

    if (empty($user_id) || empty($pet_id) || empty($message)) {
        echo json_encode([
            'status' => 'failed',
            'message' => 'All fields are required'
        ]);
        exit();
    }

    // Check if the pet is already requested or adopted
    $check = "SELECT adoption_status FROM tbl_pets WHERE pet_id='$pet_id' LIMIT 1";
    $result = $conn->query($check);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        if ($row['adoption_status'] != 'Available') {
            echo json_encode([
                'status' => 'failed',
                'message' => 'This pet has already been requested or adopted'
            ]);
            exit();
        }
    }

    // Insert adoption request
    $sql = "INSERT INTO tbl_adoptions (user_id, pet_id, message)
            VALUES ('$user_id', '$pet_id', '$message')";

    if ($conn->query($sql) === TRUE) {
        // Update pet status to "Requested"
        $update = "UPDATE tbl_pets SET adoption_status='Requested' WHERE pet_id='$pet_id'";
        $conn->query($update);

        echo json_encode([
            'status' => 'success',
            'message' => 'Adoption request submitted'
        ]);
    } else {
        echo json_encode([
            'status' => 'failed',
            'message' => 'Database error'
        ]);
    }
}
?>
