<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

$host = "localhost";
$user = "root"; 
$pass = ""; 
$db   = "solev"; 
$connection = new mysqli($host, $user, $pass, $db);

if ($connection->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $connection->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        handleGet($connection);
        break;
    case 'POST':
        handlePost($connection);
        break;
    case 'PUT':
        handlePut($connection);
        break;
    case 'DELETE':
        handleDelete($connection);
        break;
    default:
        echo json_encode(["error" => "Invalid method"]);
        break;
}

$connection->close();

function handleGet($connection) {
    if (isset($_GET['kd_info'])) {
        $kd_info = $connection->real_escape_string($_GET['kd_info']);
        $sql = "SELECT * FROM info WHERE kd_info = '$kd_info'";
        $result = $connection->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_assoc();
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found for the given kd_info"]);
        }
    } else {
        $sql = "SELECT * FROM info";
        $result = $connection->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_all(MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found"]);
        }
    }
    
    // Add error checking
    if (!$result) {
        echo json_encode(["error" => "Query failed: " . $connection->error]);
    }
}

function handlePost($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    $judul_info = $connection->real_escape_string($input['judul_info']);
    $isi_info = $connection->real_escape_string($input['isi_info']);
    $tgl_post_info = $connection->real_escape_string($input['tgl_post_info']);
    $status_info = $connection->real_escape_string($input['status_info']);
    $kd_petugas = $connection->real_escape_string($input['kd_petugas']);

    $sql = "INSERT INTO info (judul_info, isi_info, tgl_post_info, status_info, kd_petugas)
            VALUES ('$judul_info', '$isi_info', '$tgl_post_info', '$status_info', '$kd_petugas')";
    
    if ($connection->query($sql)) {
        echo json_encode(["message" => "Data added successfully"]);
    } else {
        echo json_encode(["error" => "Failed to add data: " . $connection->error]);
    }
}

function handlePut($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    $kd_info = $connection->real_escape_string($input['kd_info']);
    $judul_info = $connection->real_escape_string($input['judul_info']);
    $isi_info = $connection->real_escape_string($input['isi_info']);
    $tgl_post_info = $connection->real_escape_string($input['tgl_post_info']);
    $status_info = $connection->real_escape_string($input['status_info']);
    $kd_petugas = $connection->real_escape_string($input['kd_petugas']);

    $sql = "UPDATE info SET
            judul_info = '$judul_info',
            isi_info = '$isi_info',
            tgl_post_info = '$tgl_post_info',
            status_info = '$status_info',
            kd_petugas = '$kd_petugas'
            WHERE kd_info = '$kd_info'";
    
    if ($connection->query($sql)) {
        echo json_encode(["message" => "Data updated successfully"]);
    } else {
        echo json_encode(["error" => "Failed to update data: " . $connection->error]);
    }
}

function handleDelete($connection) {
    if (isset($_GET['kd_info'])) {
        $kd_info = $connection->real_escape_string($_GET['kd_info']);
        $sql = "DELETE FROM info WHERE kd_info = '$kd_info'";
        if ($connection->query($sql)) {
            echo json_encode(["message" => "Data deleted successfully"]);
        } else {
            echo json_encode(["error" => "Failed to delete data: " . $connection->error]);
        }
    } else {
        echo json_encode(["error" => "kd_info not found"]);
    }
}
?>