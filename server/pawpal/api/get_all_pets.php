<?php
header("Access-Control-Allow-Origin: *"); // Allow access from anywhere

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    include 'dbconnect.php';

    // Optional search parameter
    $search = isset($_GET['search']) ? $_GET['search'] : "";
    $type   = isset($_GET['type']) ? $_GET['type'] : "";
    $category = isset($_GET['category']) ? $_GET['category'] : ""; // NEW

    $sqlgetpets = "SELECT * FROM `tbl_pets` WHERE 1";

    // Search by pet name
    if (!empty($search)) {
        $sqlgetpets .= " AND `pet_name` LIKE '%$search%'";
    }

    // Filter by pet type
    if (!empty($type) && $type != "All") {
        $sqlgetpets .= " AND `pet_type` = '$type'";
    }

    // Filter by category
    if (!empty($category)) {
        $sqlgetpets .= " AND `category` = '$category'";
    }

    $result = $conn->query($sqlgetpets);

    if ($result->num_rows > 0) {
        $petsdata = array();

        while ($row = $result->fetch_assoc()) {
            $petsdata[] = $row;
        }

        $response = array(
            'status' => 'success',
            'message' => 'Success',
            'data' => $petsdata
        );
        sendJsonResponse($response);

    } else {
        $response = array(
            'status' => 'failed',
            'message' => 'No pets found',
            'data' => null
        );
        sendJsonResponse($response);
    }

} else {
    $response = array(
        'status' => 'failed',
        'message' => 'Method Not Allowed'
    );
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
