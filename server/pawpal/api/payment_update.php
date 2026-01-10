<?php
include_once("dbconnect.php");

$email = $_GET['email'];
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$userid = $_GET['userid'];
$petid = $_GET['petid'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'] === "true" ? "Success" : "Failed";
$receiptid = $_GET['billplz']['id'];

// FIXED: Correct signature verification
$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, '192ec16ca63e365294e04e82c59cf1f75b2059d939eea0b41b459c0870d9da343f80c02d05efe1505b796a77080418b3eebe1d97dec4877994a6297e50445420');

if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){
        $description = addslashes("Money donation of RM $amount via Billplz - Receipt: $receiptid");
        
        // FIXED: Changed user_id to donator_user_id to match your database
        $sqlinsertdonation = "INSERT INTO `tbl_donations`(`pet_id`, `user_id`, `donation_type`, `amount`, `description`)
                              VALUES ('$petid', '$userid', 'Money', '$amount', '$description')";
        
        if ($conn->query($sqlinsertdonation) === TRUE){
            display_receipt($receiptid, $name, $email, $phone, $petid, $amount, $paidstatus, true);
        } else {
            display_receipt($receiptid, $name, $email, $phone, $petid, $amount, "DB Error: " . $conn->error, false);
        }
    } else {
        display_receipt($receiptid, $name, $email, $phone, $petid, $amount, $paidstatus, false);
    }
} else {
    echo "
    <html><meta name='viewport' content='width=device-width, initial-scale=1'>
    <link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
    <body>
    <div class='w3-container w3-pale-red w3-border w3-border-red'>
    <center><h3>Security Error</h3></center>
    <p><b>Invalid payment signature.</b></p>
    <p>Transaction rejected for security reasons.</p>
    </div>
    </body></html>";
}

function display_receipt($id, $n, $e, $p, $pid, $amt, $status, $isSuccess) {
    $color = $isSuccess ? "green" : "red";
    $msg = $isSuccess ? "Thank you for your donation! Your contribution will help pets in need." : "Transaction failed or could not be recorded.";
    echo "
    <html><meta name='viewport' content='width=device-width, initial-scale=1'>
    <link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
    <body>
    <div class='w3-container'>
    <center><h4>Payment Receipt</h4></center>
    <table class='w3-table w3-striped w3-bordered'>
    <tr><td><b>Receipt ID</b></td><td>$id</td></tr>
    <tr><td><b>Donor Name</b></td><td>$n</td></tr>
    <tr><td><b>Email</b></td><td>$e</td></tr>
    <tr><td><b>Phone</b></td><td>$p</td></tr>
    <tr><td><b>Pet ID</b></td><td>#$pid</td></tr>
    <tr><td><b>Amount</b></td><td class='w3-text-$color'><b>RM $amt</b></td></tr>
    <tr><td><b>Status</b></td><td class='w3-text-$color'><b>$status</b></td></tr>
    <tr><td><b>Date</b></td><td>".date('d M Y, h:i A')."</td></tr>
    </table><br>
    <div class='w3-panel w3-pale-$color w3-border w3-border-$color'>
        <p><b>$msg</b></p>
    </div>
    </div></body></html>";
}
?>
