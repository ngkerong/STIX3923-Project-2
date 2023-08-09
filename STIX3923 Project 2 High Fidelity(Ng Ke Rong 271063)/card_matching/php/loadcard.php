<?php
include_once("dbconnect.php");

$userid = $_POST['userid'];
$sqlloadcard = "SELECT * FROM tbl_image WHERE user_id = '$userid' ORDER BY date DESC";

$result = $conn->query($sqlloadcard);

if ($result->num_rows > 0) {
     $cards["cards"] = array();

while ($row = $result->fetch_assoc()) {
        $cardlist = array();
        $cardlist['cardid'] = $row['card_id'];
        $cardlist['userid'] = $row['user_id'];
        $cardlist['date'] = $row['date'];

        array_push($cards["cards"],$cardlist);
    }
     $response = array('status' => 'success', 'data' => $cards);
    sendJsonResponse($response);

}else{

    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>