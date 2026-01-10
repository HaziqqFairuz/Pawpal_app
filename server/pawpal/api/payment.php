<?php
error_reporting(E_ALL);

$email = $_GET['email']; 
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount'];
$userid = $_GET['userid'];
$petid = $_GET['petid'];

$api_key = 'd7c389ef-9c5d-4161-a6fd-0ac3bf2f70b1'; 
$collection_id = 'py1emgir'; 
$host = 'https://www.billplz-sandbox.com/api/v3/bills'; 

$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'mobile' => $phone,
    'name' => $name,
    'amount' => $amount * 100, // Cents
    'description' => 'Donation for Pet #' . $petid,
    'callback_url' => "https://youcanyouup.com.my/pawpal_hzq/pawpal/api/return_url",
    'redirect_url' => "https://youcanyouup.com.my/pawpal_hzq/pawpal/api/payment_update.php?userid=$userid&email=$email&name=$name&phone=$phone&amount=$amount&petid=$petid" 
);

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data)); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

// Redirect the WebView to the payment URL
if (isset($bill['url'])) {
    header("Location: {$bill['url']}");
} else {
    echo "Error: Could not generate Billplz link. " . ($bill['error']['message'] ?? '');
}
?>