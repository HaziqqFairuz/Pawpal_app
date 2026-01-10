<?php
header('Content-Type: application/json');
include_once("dbconnect.php");

if (!isset($_GET['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_GET['userid'];

// Select donation details and join with pets to get the pet name for the UI
$sqlloadmanual = "SELECT d.*, p.pet_name 
                  FROM tbl_donations d 
                  LEFT JOIN tbl_pets p ON d.pet_id = p.pet_id 
                  WHERE d.user_id = '$userid' 
                  ORDER BY d.donation_date DESC";

$result = $conn->query($sqlloadmanual);

if ($result->num_rows > 0) {
    $donations["data"] = array();
    while ($row = $result->fetch_assoc()) {
        $donlist = array();
        $donlist['donation_id'] = $row['donation_id'];
        $donlist['pet_id'] = $row['pet_id'];
        $donlist['pet_name'] = $row['pet_name'] ?? "General Donation";
        $donlist['user_id'] = $row['user_id'];
        $donlist['donation_type'] = $row['donation_type'];
        $donlist['amount'] = $row['amount'];
        $donlist['description'] = $row['description'];
        $donlist['donation_date'] = $row['donation_date'];
        array_push($donations["data"], $donlist);
    }
    $response = array('status' => 'success', 'data' => $donations['data']);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    echo json_encode($sentArray);
}
?>